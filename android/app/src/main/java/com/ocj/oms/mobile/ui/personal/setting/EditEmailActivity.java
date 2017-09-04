package com.ocj.oms.mobile.ui.personal.setting;

import android.content.Intent;
import android.view.View;
import android.widget.Button;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.reset.ResetMailActivity;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.RegExpValidatorUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/24.
 * 修改邮箱
 */

public class EditEmailActivity extends BaseActivity {

    @BindView(R.id.slid_lockview) SlideLockView lockView;
    @BindView(R.id.btn_next_step) Button confirm;
    @BindView(R.id.et_email) ClearEditText mail;


    boolean isSafeVerify = false;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_edit_email_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();
    }

    private void initView() {
        if (lockView.getVisibility() == View.VISIBLE) {
            isSafeVerify = false;
            confirm.setEnabled(false);
        } else {
            isSafeVerify = true;
            confirm.setEnabled(true);
        }
        lockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                isSafeVerify = true;
                if (lockView.isAnim()) {
                    lockView.setStopAnim(false);
                    confirm.setEnabled(true);
                }
            }

            @Override
            public void onVerifyFail() {
                isSafeVerify = false;
                confirm.setEnabled(false);
            }
        });
    }

    @OnClick(R.id.btn_close)
    public void onClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C060D003001C003001);
        finish();
    }

    @OnClick({R.id.btn_next_step})
    public void onClickNext(View view) {
        String loginId = mail.getText().toString().trim();
        if (!RegExpValidatorUtils.isEmail(loginId)) {
            ToastUtils.showLongToast("请输入正确的邮箱号");
            return;
        }
        doEditMail(loginId);

    }

    private void doEditMail(final String email) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.EMAIL, email);
        params.put(ParamKeys.ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
        new AccountMode(this).changeMail(params, new ApiResultObserver<Result<String>>(this) {
            @Override
            public void onSuccess(Result<String> apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C061F008001O008001);
                handleIntent(email);

            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

        });


    }

    private void handleIntent(String email) {
        Intent intent = new Intent(mContext, ResetMailActivity.class);
        intent.putExtra(IntentKeys.LOGIN_ID, email);
        startActivity(intent);
        Intent intent1 = new Intent();
        intent.setAction(IntentKeys.FRESH_PROFILE);
        sendBroadcast(intent1);
        finish();
    }


}
