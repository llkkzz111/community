package com.community.equity;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.entity.UserEntity;
import com.community.equity.utils.ActivityStack;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.UserInfo;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;

public class CheckVerificationCodeActivity extends BaseActivity implements View.OnClickListener {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_tip_update) TextView tvTipUpdate;
    @BindView(R.id.tv_phone) TextView tvPhone;
    @BindView(R.id.et_verification_code) EditText etCode;
    @BindView(R.id.tv_resend_code) TextView tvResendCode;
    private String phone;
    private UserInfo userEntity;
    private long sendSmsToken = -1l;
    private String token = "";
    private TimeCount time;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_verification_code);
        ButterKnife.bind(this);
        phone = getIntent().getStringExtra(IntentKeys.KEY_PHONE);
        sendSmsToken = getIntent().getLongExtra(IntentKeys.KEY_SEND_SMS_TOKEN, -1l);
        token = getIntent().getStringExtra(IntentKeys.KEY_TOKEN);
        userEntity = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        initView();
        time = new TimeCount(60000, 1000);
        time.start();
    }

    private void initView() {
        topView.setTitle(R.string.text_phone_no_bind);
        topView.setLeftImage();
        tvPhone.setText(phone);

        if (userEntity != null) {
            topView.setTitle(R.string.text_update_phone_no);
            tvTipUpdate.setText(String.format(getString(R.string.text_update_phone_text), userEntity.getPhone()));

        } else {
            topView.setTitle(R.string.text_phone_no_bind);
        }

    }


    @OnClick({R.id.tv_finish, R.id.tv_resend_code, R.id.iv_left})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_finish:
                updatePhoneNo();
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
     * 修改手机号接口
     */
    private void updatePhoneNo() {
        final String code = etCode.getText().toString().trim();
        //校验验证码是否为空
        if (TextUtils.isEmpty(code)) {
            Toast.makeText(mContext, getString(R.string.text_hint_input_verification_no), Toast.LENGTH_SHORT).show();
        } else {
            Map<String, Object> params = new IdentityHashMap<>();
            params.put("code_token", sendSmsToken);
            params.put("cell_phone", phone);
            params.put("cell_phone_code", etCode.getText().toString());
            if (token != null)
                params.put("token", token);
            Call<UserEntity> call = service.userSettingPhone(params);
            call.enqueue(new BaseCallBack<UserEntity>() {
                @Override
                public void onSuccess(UserEntity response) {
                    if (userEntity == null) {
                        Toast.makeText(mContext, "手机号码绑定成功", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(mContext, "手机号码更新成功", Toast.LENGTH_SHORT).show();
                    }
                    Utils.hideInput(topView);
                    UserInfo userInfo = DBHelper.getInstance().queryMyInfo();
                    userInfo.setPhone(response.getPhone());
                    DBHelper.getInstance().saveUserInfo(userInfo);


                    ActivityStack.getInstance().popAllActivityUntilCls(SettingActivity.class);
                }

                @Override
                public void onFailure(final int code, String msg) {
                    onHttpFailure(code, msg);
                }
            });


        }
    }

    /**
     * 修改手机号码的异常处理
     *
     * @param errorCode
     * @param msg
     */
    private void onHttpFailure(int errorCode, String msg) {
        String sInfoFormat = getResources().getString(R.string.error_no_refresh);
        String toastMsg = null;
        if (errorCode == 1003) {
            toastMsg = String.format(sInfoFormat, getString(R.string.text_network_error), String.valueOf(errorCode));
        } else if (errorCode == 504) {
            toastMsg = String.format(sInfoFormat, getString(R.string.text_network_timeout), String.valueOf(errorCode));
        } else if (errorCode == 492) {
            toastMsg = String.format(sInfoFormat, msg, String.valueOf(errorCode));
        } else {
            toastMsg = String.format(sInfoFormat, msg, String.valueOf(errorCode));
        }
        if (errorCode == 492) {
            BaseDialogFragment dialogFragment = new BaseDialogFragment();
            dialogFragment.setCancelable(true);
            dialogFragment.addContent(toastMsg).addButton(1, getString(R.string.text_confirm), new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    finish();
                }
            }).show(getSupportFragmentManager(), "cellphone" + errorCode);
            return;
        }
        Toast.makeText(mContext, toastMsg, Toast.LENGTH_SHORT).show();
    }

    /**
     * 发送短信验证码
     */
    private void sendSmsCode() {
        long timeToken = System.currentTimeMillis();
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("phone", phone);
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
            protected void onFailure(int errorCode, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                String toastMsg;
                if (errorCode == 99) {
                    toastMsg = String.format(sInfoFormat, getString(R.string.text_network_error), String.valueOf(errorCode));
                } else if (errorCode == 504) {
                    toastMsg = String.format(sInfoFormat, getString(R.string.text_network_timeout), String.valueOf(errorCode));
                } else {
                    toastMsg = String.format(sInfoFormat, msg, String.valueOf(errorCode));
                }


                Toast.makeText(mContext, toastMsg, Toast.LENGTH_SHORT).show();
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
