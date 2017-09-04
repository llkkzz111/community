package com.ocj.oms.mobile.ui.register;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.blankj.utilcode.utils.RegexUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.view.CallTextView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by yy on 2017/4/27.
 */

public class RegisterInputMobileActivity extends BaseActivity {

    @BindView(R.id.et_mobile_num) ClearEditText etMobileNum;
    @BindView(R.id.btn_rapid_register) Button btnRegister;//注册按钮
    @BindView(R.id.btn_title_right_action) TextView btnLogin;//登录按钮


    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    private String loginId = "";

    @BindView(R.id.callTextView) CallTextView callTextView;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_register_input_mobile_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C010);
        loginId = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {//从第三方关联过来注册的
            btnLogin.setVisibility(View.GONE);
        } else {
            btnLogin.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(loginId) && RegexUtils.isMobileSimple(loginId)) {
            etMobileNum.setText(loginId);
        } else {
            btnRegister.setEnabled(false);
        }
        callTextView.setTraceEvent(EventId.AP1706C010F010001A001001);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C010);
    }

    @OnClick({R.id.btn_title_right_action, R.id.btn_close})
    public void onButtonClick(View view) {
        int id = view.getId();
        switch (id) {
            case R.id.btn_title_right_action:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C010C005001A001001);
                Intent intent = getIntent();
                intent.setClass(mContext, LoginActivity.class);
                startActivity(intent);
                break;

            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C010C005001C003001);
                finish();
                break;


        }
    }


    @OnClick({R.id.btn_rapid_register})
    public void onTextClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C010F008001O008001);
        loginId = etMobileNum.getText().toString().trim();
        if (!(RegexUtils.isMobileSimple(loginId))) {
            ToastUtils.showLongToast("请输入有效手机号!");
            return;
        }
//        btnRegister.setEnabled(true);
        commitRegisterType(loginId);
    }

    @OnTextChanged(value = R.id.et_mobile_num, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onWatchText(CharSequence text) {
        if (!TextUtils.isEmpty(etMobileNum.getText().toString())) {
            btnRegister.setEnabled(true);
        } else {
            btnRegister.setEnabled(false);
        }
    }


    /**
     * 请求用户类型
     */
    private void commitRegisterType(final String loginId) {
        new AccountMode(this).checkLogin(loginId, new ApiResultObserver<UserType>(this) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }


            @Override
            public void onSuccess(final UserType apiResult) {
                Intent intent = getIntent();
                final int type = apiResult.getUserType();
                if (type == 0) {
                    if (RegexUtils.isMobileSimple(loginId)) {
                        intent.setClass(mContext, RegisterActivity.class);
                        intent.putExtra(IntentKeys.LOGIN_ID, etMobileNum.getText().toString().trim());
                        startActivity(intent);
                    } else {
                        ToastUtils.showShortToast("请输入有效的手机号！");
                    }

                } else {
                    DialogFactory.showRightDialog(mContext, loginId + "账号已存在", "返回", "去登录", new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = getIntent();
                            intent.setClass(mContext, LoginActivity.class);
                            intent.putExtra(IntentKeys.LOGIN_ID, etMobileNum.getText().toString().trim());
                            startActivity(intent);
                            OCJPreferencesUtils.setLoginID(etMobileNum.getText().toString().trim());
//                            OCJPreferencesUtils.setCustName(apiResult.getCust_name());
                            OCJPreferencesUtils.setLoginType(type + "");
                            finish();
                        }
                    }).show(getFragmentManager(), "login");
                }
            }

            @Override
            public void onComplete() {

            }
        });


    }


}
