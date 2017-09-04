package com.ocj.oms.mobile.ui.reset;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.Button;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.view.CallTextView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.RegExpValidatorUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.oms.view.TimerTextView;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class ResetPhoneActivity extends BaseActivity {
    @BindView(R.id.et_verify_code) ClearEditText etVerifyCode;
    @BindView(R.id.timmer_get_code) TimerTextView btnGetCode;
    @BindView(R.id.btn_next_step) Button btnNext;
    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @BindView(R.id.tv_problems) CallTextView callTextView;
    private String loginId;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_reset_password_mobile_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C008);
        loginId = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        btnNext.setBackground(unClickBg);
        btnNext.setEnabled(false);
        callTextView.setTraceEvent(EventId.AP1706C008F010001A001001);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C008);
    }

    @OnTextChanged(value = R.id.et_verify_code, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onAfterTextChanged(CharSequence text) {
        String verifyCode = etVerifyCode.getText().toString().trim();
        if (RegExpValidatorUtils.isNumber(verifyCode)) {
            btnNext.setEnabled(true);
            btnNext.setBackground(normalBg);
        } else {
            btnNext.setBackground(unClickBg);
            btnNext.setEnabled(false);
        }
    }


    @OnClick({R.id.btn_next_step, R.id.btn_pwd_back, R.id.timmer_get_code})
    void onClick(View v) {


        switch (v.getId()) {
            case R.id.btn_next_step:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C008F008002O008001);
                showLoading();
                Map<String, String> params = new HashMap<>();
                params.put(ParamKeys.MOBILE, loginId);
                params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_RETRIEVE_PASSWORD);
                params.put(ParamKeys.VERIFY_CODE, etVerifyCode.getText().toString());
                new AccountMode(this).smsLogin(params, new ApiResultObserver<UserInfo>(this) {
                    @Override
                    public void onError(ApiException e) {
                        hideLoading();
                        ToastUtils.showLongToast(e.getMessage());
                    }


                    @Override
                    public void onSuccess(UserInfo apiResult) {
                        OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                        Intent intent = getIntent();
                        intent.putExtra(IntentKeys.VERIFY_CODE, etVerifyCode.getText().toString().trim());
                        intent.putExtra(IntentKeys.PHONE_RESET, "");
                        intent.setClass(mContext, ResetPasswordActivity.class);
                        startActivity(intent);
                    }

                    @Override
                    public void onComplete() {
                        hideLoading();
                    }
                });

                break;
            case R.id.btn_pwd_back:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C008D003001C003001);
                finish();
                break;
            case R.id.timmer_get_code:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C008F008001O008001);
                getVerifyCode();
                break;

        }

    }

    private void getVerifyCode() {
        showLoading();
        Map<String, String> params = new HashMap<>();
        params.put("mobile", loginId);
        params.put("purpose", ApiService.SMS_PURPOSE_RETRIEVE_PASSWORD);
        new AccountMode(this).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(this) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                btnGetCode.start();
//                etVerifyCode.setText(result.getData().getVerifyode());
            }

            @Override
            public void onComplete() {
                hideLoading();
            }
        });
    }

}
