package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;

public class CheckPhoneActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_tip_update) TextView tvTipUpdate;
    @BindView(R.id.et_verification_code) EditText etCode;
    @BindView(R.id.tv_resend_code) TextView tvResendCode;

    private UserInfo userEntity;
    private String token = "";
    private TimeCount time;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_phone_layout);
        ButterKnife.bind(this);
        token = getIntent().getStringExtra(IntentKeys.KEY_TOKEN);
        userEntity = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        initView();
        time = new TimeCount(60000, 1000);
        time.start();
    }

    private void initView() {
        topView.setLeftImage();
        topView.setTitle(R.string.text_update_phone_no);
        tvTipUpdate.setText(String.format(getString(R.string.text_check_phone_text), userEntity.getPhone()));
    }


    @OnClick({R.id.tv_finish, R.id.tv_resend_code, R.id.iv_left})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_finish:
                SmsCodeVerify();
                break;
            case R.id.tv_resend_code:
                sendSmsCode();
                break;
            case R.id.iv_left:
                Utils.hideInput(topView);
                finish();
                break;
        }
    }

    /**
     * 校验输入验证码
     */
    private void SmsCodeVerify() {
        final String code = etCode.getText().toString().trim();
        if (TextUtils.isEmpty(code)) {
            Toast.makeText(mContext, getString(R.string.text_hint_input_verification_no), Toast.LENGTH_SHORT).show();
        } else {

            Map<String, Object> params = new IdentityHashMap<>();
            params.put("code", code);
            params.put("token", token);
            Call<BaseApiResponse> call = service.userSmsVerify(params);
            call.enqueue(new BaseCallBack<BaseApiResponse>() {
                @Override
                public void onSuccess(BaseApiResponse response) {
                    if (response.getStatus().equals("OK")) {
                        Toast.makeText(mContext, getString(R.string.text_phone_check_success), Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent();
                        intent.setClass(mContext, UpdatePhoneActivity.class);
                        intent.putExtra(IntentKeys.KEY_USER_INFO, userEntity);
                        intent.putExtra(IntentKeys.KEY_TOKEN, token);
                        startActivity(intent);
                        Utils.hideInput(topView);
                        finish();
                    }
                }

                @Override
                public void onFailure(final int code, String msg) {
                    String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                    Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
                }
            });
        }
    }

    /**
     * 发送短信验证码
     */
    private void sendSmsCode() {
        long timeToken = System.currentTimeMillis();
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("phone", userEntity.getPhone());
        params.put("token", timeToken);
        Call<BaseApiResponse> call = service.sendSMSCode(params);
        call.enqueue(new BaseCallBack<BaseApiResponse>() {
            @Override
            protected void onSuccess(BaseApiResponse body) {
                if (body.getStatus().equals("OK")) {
                    Toast.makeText(mContext, getString(R.string.text_verification_no_send_success), Toast.LENGTH_SHORT).show();
                    token = body.getToken();
                    time.start();
                }
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });

    }

    class TimeCount extends CountDownTimer {
        public TimeCount(long millisInFuture, long countDownInterval) {
            super(millisInFuture, countDownInterval);
        }

        @Override
        public void onFinish() {// 计时完毕
            tvResendCode.setText(R.string.text_resend_verification_no);
            tvResendCode.setClickable(true);
        }

        @Override
        public void onTick(long millisUntilFinished) {// 计时过程
            tvResendCode.setClickable(false);//防止重复点击
            tvResendCode.setText(millisUntilFinished / 1000 + "秒后可点击重新发送");
        }

    }
}