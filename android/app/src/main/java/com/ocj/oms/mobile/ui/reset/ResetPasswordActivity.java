package com.ocj.oms.mobile.ui.reset;

import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.view.CallTextView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * 1、登录界面修改密码
 * 2、安全校验 设置密码
 * 3、设置界面修改密码
 */
public class ResetPasswordActivity extends BaseActivity {
    @BindView(R.id.et_new_pwd) ClearEditText etNewPwd;
    @BindView(R.id.et_confirm_pwd) ClearEditText etConfirmPwd;
    @BindView(R.id.et_old_pwd) ClearEditText etOldPwd;
    @BindView(R.id.btn_reset) Button btnReset;
    @BindView(R.id.iv_pwd_state) ImageView ivPwdState;
    @BindView(R.id.iv_old_pwd_state) ImageView ivOldPwdState;

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @BindView(R.id.tv_title) TextView tvTitle;

    @BindView(R.id.ll_et_confirm_pwd) LinearLayout llRepeatPwd;
    @BindView(R.id.ll_old_pwd) LinearLayout llOldPwd;
    @BindView(R.id.tv_problems) CallTextView callTextView;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_reset_password_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C007);
        initView();
        btnReset.setEnabled(false);
        btnReset.setBackground(unClickBg);
        callTextView.setTraceEvent(EventId.AP1706C007F010001A001001);
    }

    private void initView() {
        //从电话用户登录成功过来的
        if (getIntent().hasExtra(IntentKeys.TVMOBILE_USER_PWD)) {
            tvTitle.setText("设置登录密码");
            llRepeatPwd.setVisibility(View.GONE);
            llRepeatPwd.setVisibility(View.VISIBLE);
        }
        if (getIntent().hasExtra(IntentKeys.FROM_SETTING)) {
            tvTitle.setText("设置密码");
            llOldPwd.setVisibility(View.VISIBLE);
            llRepeatPwd.setVisibility(View.VISIBLE);
        }
        if (getIntent().hasExtra(IntentKeys.PHONE_RESET)) {
            tvTitle.setText("设置新密码");
            llOldPwd.setVisibility(View.GONE);
            llRepeatPwd.setVisibility(View.VISIBLE);
        }
    }


    @OnTextChanged(value = R.id.et_old_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onOldPwdChenge(CharSequence text) {

    }

    @OnTextChanged(value = R.id.et_confirm_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onConfirmChenge(CharSequence text) {

        checkPassword();
    }

    @OnTextChanged(value = R.id.et_new_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onPasswordChenge(CharSequence text) {
        checkPassword();
    }

    /**
     * 检查两次输入密码是否符合规则
     */
    private void checkPassword() {
        String confirm = etConfirmPwd.getText().toString().trim();
        String password = etNewPwd.getText().toString().trim();

        if (llRepeatPwd.getVisibility() == View.GONE) {
            if (TextUtils.isEmpty(password) || password.length() < 6) {
                btnReset.setEnabled(false);
                btnReset.setBackground(unClickBg);
            } else {
                btnReset.setEnabled(true);
                btnReset.setBackground(normalBg);
            }
            return;
        } else {
            if (!(password.length() < 6 || TextUtils.isEmpty(confirm))) {
                btnReset.setEnabled(true);
                btnReset.setBackground(normalBg);
            }
        }

    }

    @OnClick({R.id.btn_reset, R.id.btn_pwd_back, R.id.iv_pwd_state, R.id.iv_old_pwd_state})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_reset:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C007F008001O008001);

                if (etNewPwd.getText().length() < 6) {
                    ToastUtils.showLongToast("密码长度最短为6位");
                    return;
                }
                String confirm = etConfirmPwd.getText().toString().trim();
                String password = etNewPwd.getText().toString().trim();
                if (!confirm.equals(password)) {
                    ToastUtils.showLongToast("密码输入不一致");
                    return;
                }
                Map<String, String> params = new HashMap<>();
                if (getIntent().hasExtra(IntentKeys.FROM_SETTING)) {
                    params.put(ParamKeys.OLD_PASSWORD, etOldPwd.getText().toString().trim());
                }
                params.put(ParamKeys.NEW_PASSWORD, etNewPwd.getText().toString().trim());
                params.put(ParamKeys.ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
                new AccountMode(mContext).updatePassword(params, new ApiResultObserver<UserInfo>(mContext) {
                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showShortToast(e.getMessage());
                    }

                    @Override
                    public void onSuccess(UserInfo apiResult) {
                        OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());

                        String loginId = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
                        OCJPreferencesUtils.setLoginID(loginId);
                        OCJPreferencesUtils.setLoginType(getIntent().getStringExtra(IntentKeys.LOGIN_TYPE));
                        OCJPreferencesUtils.setCustName(apiResult.getCust_name());
                        OCJPreferencesUtils.setCustNo(apiResult.getCust_no());
                        OCJPreferencesUtils.setVisitor(false);
                        if (getIntent().hasExtra(IntentKeys.FROM_SETTING)) {
                            finish();
                        } else {
                            OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                            if ("WebView".equals(getIntent().getStringExtra("fromPage"))) {
                                RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                            } else {
                                RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                                RouterModule.sendAdviceEvent("refreshMePage", false);
                                RouterModule.sendRefreshCartEvent("", "");
                            }

                        }
                    }

                    @Override
                    public void onComplete() {
                        if (getIntent().hasExtra(IntentKeys.TVMOBILE_USER_PWD)) {
                            ToastUtils.showShortToast("密码设置成功");
                        } else {
                            ToastUtils.showShortToast("密码修改成功");
                        }
                    }
                });
                break;
            case R.id.iv_pwd_state:
                onNewCheckState();
                break;
            case R.id.iv_old_pwd_state:
                onOldCheckState();
                break;
            case R.id.btn_pwd_back:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C007D003001C003001);
                finish();
                break;

        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C007);
    }

    private void onNewCheckState() {
        if (etNewPwd.getTransformationMethod() == HideReturnsTransformationMethod.getInstance()) {//隐藏密码
            etConfirmPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
            etNewPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
            ivPwdState.setSelected(false);
        } else {//显示密码
            etNewPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
            etConfirmPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
            ivPwdState.setSelected(true);
        }
        if (etNewPwd.hasFocus()) {
            etNewPwd.setSelection(etNewPwd.getText().length());
        }
        if (etConfirmPwd.hasFocus()) {
            etConfirmPwd.setSelection(etConfirmPwd.getText().length());
        }
    }

    private void onOldCheckState() {
        if (etOldPwd.getTransformationMethod() == HideReturnsTransformationMethod.getInstance()) {//隐藏密码
            etOldPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
            ivOldPwdState.setSelected(false);
        } else {//显示密码
            etOldPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
            ivOldPwdState.setSelected(true);
        }
        if (etOldPwd.hasFocus()) {
            etOldPwd.setSelection(etOldPwd.getText().length());
        }
    }

}
