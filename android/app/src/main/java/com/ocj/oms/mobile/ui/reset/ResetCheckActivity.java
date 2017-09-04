package com.ocj.oms.mobile.ui.reset;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;

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
import com.ocj.oms.mobile.ui.register.RegisterInputMobileActivity;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

import static com.ocj.oms.mobile.IntentKeys.LOGIN_ID;
import static com.ocj.oms.mobile.IntentKeys.USER_NAME;

public class ResetCheckActivity extends BaseActivity {
    @BindView(R.id.et_mobile_num) ClearEditText etUserName;
    @BindView(R.id.btn_next_step) Button btnNext;
    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;
    private String loginId;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_reset_password_check_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C006);
        loginId = getIntent().getStringExtra(LOGIN_ID);
        etUserName.setText(loginId);
        if (TextUtils.isEmpty(loginId)) {
            btnNext.setBackground(unClickBg);
            btnNext.setEnabled(false);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C006);
    }

    @OnTextChanged(value = R.id.et_mobile_num, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onAfterTextChanged(CharSequence text) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C006F008001O008001);

        if (TextUtils.isEmpty(loginId)) {
            String userName = etUserName.getText().toString().trim();
            if (RegexUtils.isEmail(userName) || RegexUtils.isMobileSimple(userName)) {
                btnNext.setEnabled(true);
                btnNext.setBackground(normalBg);
            } else {
                btnNext.setBackground(unClickBg);
                btnNext.setEnabled(false);
            }
        }
    }

    @OnClick({R.id.btn_next_step, R.id.btn_pwd_back})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_next_step:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C006F010001A001001);
                loginId = etUserName.getText().toString();
                if (!RegexUtils.isEmail(loginId) && !RegexUtils.isMobileSimple(loginId)) {
                    ToastUtils.showShortToast("请检查用户名格式");
                    return;
                }
                showLoading();
                new AccountMode(this).checkLogin(loginId, new ApiResultObserver<UserType>(this) {
                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showLongToast(e.getMessage());
                        hideLoading();
                    }

                    @Override
                    public void onSuccess(UserType result) {
                        final Intent intent = getIntent();
                        intent.putExtra(LOGIN_ID, loginId);
                        intent.putExtra(USER_NAME, result.getCust_name());
                        switch (result.getUserType()) {
                            case UserType.TYPE_MAIL:
                                intent.setClass(mContext, ResetMailActivity.class);
                                startActivity(intent);
                                return;
                            case UserType.TYPE_MOBILE:
                                intent.putExtra(IntentKeys.PHONE_RESET, "");
                                intent.putExtra(IntentKeys.LOGIN_TYPE, UserType.TYPE_MOBILE + "");
                                intent.setClass(mContext, ResetPhoneActivity.class);
                                startActivity(intent);
                                return;
                            case UserType.TYPE_UNKNOWN:
                                DialogFactory.showRightDialog(mContext, loginId + " 尚未成为会员", "返回", "去注册", new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        intent.setClass(mContext, RegisterInputMobileActivity.class);
                                        intent.putExtra(IntentKeys.LOGIN_ID, loginId);
                                        startActivity(intent);
                                    }
                                }).show(getFragmentManager(), "register");
                                break;
                            default:
                                ToastUtils.showShortToast("用户类型非新媒体会员邮箱手机号码");
                                break;
                        }
                    }

                    @Override
                    public void onComplete() {
                        hideLoading();
                    }
                });
                break;
            case R.id.btn_pwd_back:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C006D003001C003001);
                finish();
                break;
        }
    }
}
