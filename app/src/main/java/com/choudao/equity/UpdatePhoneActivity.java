package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
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

import retrofit2.Call;

public class UpdatePhoneActivity extends BaseActivity {
    private TopView topView;
    private EditText etPhone;
    private long SendSmsToken;
    private UserInfo userEntity;
    private TextView tvTipUpdate;
    private String token;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_phone_layout);
        userEntity = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        token = getIntent().getStringExtra(IntentKeys.KEY_TOKEN);
        initView();
    }

    private void initView() {
        tvTipUpdate = (TextView) findViewById(R.id.tv_tip_update);
        topView = (TopView) findViewById(R.id.topview);
        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Utils.hideInput(topView);
                finish();
            }
        });
        topView.setRightText(R.string.text_next);
        topView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendSmsCode();
            }
        });
        if (userEntity != null) {
            tvTipUpdate.setText(String.format(getString(R.string.text_update_phone_text), userEntity.getPhone()));
            topView.setTitle(R.string.text_update_phone_no);
        } else {
            topView.setTitle(R.string.text_phone_no_bind);
        }
        etPhone = (EditText) findViewById(R.id.et_phone);
    }

    /**
     * 发送验证码
     */
    private void sendSmsCode() {
        final String phone = etPhone.getText().toString().trim();
        if (userEntity != null && phone.equals(userEntity.getPhone())) {
            Toast.makeText(mContext, "该手机号与当前绑定的手机号相同", Toast.LENGTH_SHORT).show();
            return;
        } else if (TextUtils.isEmpty(phone)) {
            Toast.makeText(mContext, "请输入手机号", Toast.LENGTH_SHORT).show();
            return;
        }
        /**
         * 校验手机格式
         */
        if (!phone.matches("(^(13\\d|15[^4,\\D]|17[13678]|18\\d)\\d{8}|170[^346,\\D]\\d{7})$")) {
            Toast.makeText(UpdatePhoneActivity.this, "请输入正确的手机号码", Toast.LENGTH_SHORT).show();
        } else {
            sendSmsMsg(phone);
        }
    }

    private void sendSmsMsg(final String phone) {
        SendSmsToken = System.currentTimeMillis();


        Map<String, Object> params = new IdentityHashMap<>();
        params.put("phone", phone);
        params.put("token", SendSmsToken);
        Call<BaseApiResponse> call = service.sendSMSCode(params);
        call.enqueue(new BaseCallBack<BaseApiResponse>() {
            @Override
            protected void onSuccess(BaseApiResponse body) {
                if (body.getStatus().equals("OK")) {
                    Toast.makeText(mContext, getString(R.string.text_verification_no_send_success), Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent();
                    intent.setClass(mContext, CheckVerificationCodeActivity.class);
                    intent.putExtra(IntentKeys.KEY_SEND_SMS_TOKEN, SendSmsToken);
                    intent.putExtra(IntentKeys.KEY_TOKEN, token);
                    intent.putExtra(IntentKeys.KEY_PHONE, phone);
                    if (userEntity != null) {
                        intent.putExtra(IntentKeys.KEY_USER_INFO, userEntity);
                    }
                    Utils.hideInput(topView);
                    startActivity(intent);
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

}
