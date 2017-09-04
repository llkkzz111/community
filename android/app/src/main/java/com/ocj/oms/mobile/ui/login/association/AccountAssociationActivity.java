package com.ocj.oms.mobile.ui.login.association;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.register.RegisterActivity;
import com.ocj.oms.mobile.ui.register.RegisterInputMobileActivity;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by Administrator on 2017/4/18 0018.
 * 关联帐号
 */

public class AccountAssociationActivity extends BaseActivity {
    @BindView(R.id.et_association_account) ClearEditText etAccount;
    @BindView(R.id.btn_association_commit) Button btnCommit;

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_account_association;
    }


    @Override
    protected void initEventAndData() {
        btnCommit.setEnabled(false);
        btnCommit.setBackground(unClickBg);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @OnClick({R.id.tv_not_member, R.id.btn_association_back, R.id.btn_association_commit})
    public void onClick(View view) {

        switch (view.getId()) {
            case R.id.tv_not_member:
                Intent intent = getIntent();
                intent.putExtra(IntentKeys.LOGIN_ID, etAccount.getText().toString());
                intent.setClass(AccountAssociationActivity.this, RegisterInputMobileActivity.class);//不是会员跳转到注册输入号码页面
                startActivity(intent);
                finish();
                break;
            case R.id.btn_association_commit:
                String account = etAccount.getText().toString();
                if (TextUtils.isEmpty(account)) {
                    ToastUtils.showShortToast("请填写账号");
                    return;
                }
                checkUserType(account);
                break;
            case R.id.btn_association_back:
                finish();
                break;
        }

    }

    @OnTextChanged(value = R.id.et_association_account, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onTextChenge(CharSequence text) {
        checkState();
    }

    private void checkState() {
        String account = etAccount.getText().toString().trim();
        if (TextUtils.isEmpty(account)) {
            btnCommit.setEnabled(false);
            btnCommit.setBackground(unClickBg);
        } else {
            btnCommit.setEnabled(true);
            btnCommit.setBackground(normalBg);
        }
    }


    /**
     * 请求用户类型
     */
    private void checkUserType(String loginId) {
        new AccountMode(this).checkLogin(loginId, new ApiResultObserver<UserType>(this) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(UserType apiResult) {
                Intent intent = getIntent();
                int type = apiResult.getUserType();
                if (type == 0) {
                    intent.setClass(mContext, RegisterActivity.class);
                    intent.putExtra(IntentKeys.LOGIN_ID, etAccount.getText().toString().trim());
                    startActivity(intent);
                } else {
                    intent.setClass(mContext, LoginActivity.class);
                    OCJPreferencesUtils.setLoginID(etAccount.getText().toString().trim());
                    OCJPreferencesUtils.setLoginType(type + "");
                    OCJPreferencesUtils.setCustName(apiResult.getCust_name());
                    intent.putExtra(IntentKeys.LOGIN_ID, etAccount.getText().toString().trim());
                    startActivity(intent);
                }
            }

            @Override
            public void onComplete() {

            }
        });


    }
}
