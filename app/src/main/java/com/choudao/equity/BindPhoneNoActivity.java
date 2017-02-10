package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;


public class BindPhoneNoActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.ll_unbind_phone) LinearLayout llUnBindPhone;
    @BindView(R.id.tv_phone) TextView tvPhone;
    @BindView(R.id.ll_binding_phone) LinearLayout llBindingPhone;
    private UserInfo userEntity;
    private long token = -1l;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bind_phone_no_layout);
        ButterKnife.bind(this);
        userEntity = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        if (userEntity == null) {
            userEntity = DBHelper.getInstance().queryUniqueUserInfo(ConstantUtils.USER_ID);
        }
        initView();
    }

    private void initView() {
        topView.setLeftImage();
        topView.setTitle(R.string.text_phone_no_bind);
        tvPhone.setText(String.format(getString(R.string.text_phone_no_), userEntity.getPhone()));
    }

    @Override
    protected void onResume() {
        super.onResume();
        tvPhone.setText(String.format(getString(R.string.text_phone_no_), userEntity.getPhone()));
        if (TextUtils.isEmpty(userEntity.getPhone())) {
            llUnBindPhone.setVisibility(View.VISIBLE);
            llBindingPhone.setVisibility(View.GONE);
        } else {
            llUnBindPhone.setVisibility(View.GONE);
            llBindingPhone.setVisibility(View.VISIBLE);
        }
    }

    @OnClick({R.id.iv_left, R.id.tv_bind_phone, R.id.tv_update_phone})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.tv_bind_phone:
                intent.setClass(mContext, UpdatePhoneActivity.class);
                startActivity(intent);
                break;
            case R.id.tv_update_phone:
                sendSmsCode();
                break;
            case R.id.iv_left:
                finish();
                break;
        }

    }

    /**
     * 发送短信验证码
     */
    private void sendSmsCode() {
        token = System.currentTimeMillis();
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("phone", userEntity.getPhone());
        params.put("token", token);
        Call<BaseApiResponse> call = service.sendSMSCode(params);
        call.enqueue(new BaseCallBack<BaseApiResponse>() {
            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                String toastMsg;
                if (code == 99) {
                    toastMsg = String.format(sInfoFormat, getString(R.string.text_network_error), String.valueOf(code));
                } else if (code == 504) {
                    toastMsg = String.format(sInfoFormat, getString(R.string.text_network_timeout), String.valueOf(code));
                } else {
                    toastMsg = String.format(sInfoFormat, msg, String.valueOf(code));
                }
                Toast.makeText(mContext, toastMsg, Toast.LENGTH_SHORT).show();
            }

            @Override
            protected void onSuccess(BaseApiResponse body) {
                if (body.getStatus().equals("OK")) {
                    Toast.makeText(mContext, getString(R.string.text_verification_no_send_success), Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent();
                    intent.setClass(mContext, CheckPhoneActivity.class);
                    intent.putExtra(IntentKeys.KEY_USER_INFO, userEntity);
                    intent.putExtra(IntentKeys.KEY_TOKEN, body.getToken());
                    startActivity(intent);
                }
            }
        });

    }
}
