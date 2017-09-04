package com.ocj.oms.mobile.ui.safty;

import android.content.Intent;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.blankj.utilcode.utils.RegexUtils;
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
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.TimerTextView;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/16.
 * <p>
 * 电视用户固话验证成功 登录
 */

public class BindMobileActivity extends BaseActivity {
    @BindView(R.id.et_mobile) EditText etMobile;
    @BindView(R.id.et_verify_code) EditText etVerifyCode;
    @BindView(R.id.et_password) EditText etPassword;
    @BindView(R.id.timmer_get_code) TimerTextView btnGetCode;
    @BindView(R.id.ll_password) LinearLayout llPassword;
    @BindView(R.id.btn_pwd_hide) ImageView btnPwdHide;
    private String internetId = "";
    private String custNo;
    private String custName;
    private String accessToken;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_bind_mobile_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C013);
        if (getIntent().hasExtra(IntentKeys.NO_MOBILE)) {
            llPassword.setVisibility(View.GONE);
        } else {
            custNo = getIntent().getStringExtra(IntentKeys.MEMBER_ID);
            custName = getIntent().getStringExtra(IntentKeys.CUST_NAME);
        }
        internetId = getIntent().getStringExtra(IntentKeys.INTERNAL_ID);
        accessToken = getIntent().getStringExtra(IntentKeys.ACCESS_TOKEN);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C013);
    }

    @OnClick({R.id.btn_close, R.id.btn_binding, R.id.timmer_get_code, R.id.btn_pwd_hide})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_binding:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C013F008002O008001);
                if (checkMobile()) return;
                if (checkVerifyCode()) return;

                Map<String, String> params = new HashMap<>();
                params.put(ParamKeys.MOBILE, etMobile.getText().toString());
                params.put(ParamKeys.VERIFY_CODE, etVerifyCode.getText().toString());
                params.put(ParamKeys.INTERNAT_ID, internetId);
                if (getIntent().hasExtra(IntentKeys.NO_MOBILE)) {
                    params.put(ParamKeys.PASSWORD, etPassword.getText().toString());
                    new AccountMode(mContext).bindMobile(params, new ApiResultObserver<Result<String>>(mContext) {
                        @Override
                        public void onError(ApiException e) {
                            ToastUtils.showShortToast(e.getMessage());
                        }

                        @Override
                        public void onSuccess(Result<String> apiResult) {
                            if (apiResult.getResult().equals("ok")) {
                                if ("RNActivity".equals(getIntent().getStringExtra("from"))) {
                                    RouterModule.invokeTokenCallback(null, OCJPreferencesUtils.getAccessToken(), "self", false);
                                }
                            } else {
                                ToastUtils.showShortToast("绑定失败");
                            }
                        }

                        @Override
                        public void onComplete() {

                        }
                    });
                } else {
                    params.put(ParamKeys.NEW_PASSWORD, etPassword.getText().toString());
                    params.put(ParamKeys.CUST_NAME, custName);
                    params.put(ParamKeys.CUST_NO, custNo);
                    new AccountMode(mContext).tvUserMoblieLogin(params, new ApiResultObserver<UserInfo>(mContext) {
                        @Override
                        public void onError(ApiException e) {
                            ToastUtils.showShortToast(e.getMessage());
                        }

                        @Override
                        public void onSuccess(UserInfo apiResult) {
                            //回传token
                            Intent intent = getIntent();
                            if ("RNActivity".equals(intent.getStringExtra("from"))) {
                                saveInfo(apiResult);
                                RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                                RouterModule.sendAdviceEvent("refreshMePage", false);
                                RouterModule.sendRefreshCartEvent("", "");
                            }
                        }

                        @Override
                        public void onComplete() {

                        }
                    });
                }

                break;
            case R.id.timmer_get_code:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C013F008001O008001);
                getVerifyCode();
                break;
            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C013D003001C003001);
                finish();
            case R.id.btn_pwd_hide:
                //隐藏密码
                if (PasswordTransformationMethod.getInstance().equals(etPassword.getTransformationMethod())) {
                    etPassword.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                    btnPwdHide.setSelected(true);
                } else {
                    etPassword.setTransformationMethod(PasswordTransformationMethod.getInstance());
                    btnPwdHide.setSelected(false);
                }
                etPassword.setSelection(etPassword.getText().length());
                break;
        }

    }

    private void saveInfo(UserInfo userInfo) {
        OCJPreferencesUtils.setAccessToken(userInfo.getAccessToken());
        OCJPreferencesUtils.setCustName(userInfo.getCust_name());
        OCJPreferencesUtils.setCustNo(userInfo.getCust_no());
        OCJPreferencesUtils.setLoginID(etMobile.getText().toString());
        OCJPreferencesUtils.setLoginType("");
        OCJPreferencesUtils.setVisitor(false);
    }

    private boolean checkVerifyCode() {
        String verifyCode = etVerifyCode.getText().toString();
        if (TextUtils.isEmpty(verifyCode)) {
            ToastUtils.showShortToast("请输入验证码");
            return true;
        }
        return false;
    }

    private void getVerifyCode() {
        if (checkMobile()) return;
        showLoading();
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, etMobile.getText().toString().trim());
        params.put(ParamKeys.INTERNAT_ID, internetId);
        if (getIntent().hasExtra(IntentKeys.NO_MOBILE)) {
            params.put(ParamKeys.PURPOSE, ApiService.EMAILUSER_SMS_CONTEXT);
        } else {
            params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_TVUSER_LOGIN);
        }

        new AccountMode(this).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(this) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                btnGetCode.start();
                etVerifyCode.setText(result.getData().getVerifyode());
                internetId = result.getData().getInternetId();
            }

            @Override
            public void onComplete() {
                hideLoading();
            }
        });
    }

    private boolean checkMobile() {
        String mobile = etMobile.getText().toString();
        if (TextUtils.isEmpty(mobile)) {
            ToastUtils.showShortToast("请输入手机号");
            return true;
        }
        if (!RegexUtils.isMobileSimple(mobile)) {
            ToastUtils.showShortToast("请输入正确的手机号");
            return true;
        }
        return false;
    }

}
