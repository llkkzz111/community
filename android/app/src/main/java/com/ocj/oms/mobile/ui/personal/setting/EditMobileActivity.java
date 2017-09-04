package com.ocj.oms.mobile.ui.personal.setting;

import android.text.TextUtils;
import android.view.View;
import android.widget.Button;

import com.blankj.utilcode.utils.RegexUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.oms.view.TimerTextView;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/24.
 * 修改手机号
 */

public class EditMobileActivity extends BaseActivity {

    @BindView(R.id.slid_lockview) SlideLockView lockView;
    @BindView(R.id.btn_change_mobile) Button btnConfirm;

    @BindView(R.id.et_mobile) ClearEditText etMobileNum;
    @BindView(R.id.et_verify_code) ClearEditText etCode;
    @BindView(R.id.timmer_get_code) TimerTextView timeCode;
    private String internetId;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_edit_mobile_layout;
    }

    @Override
    protected void initEventAndData() {
        btnConfirm.setEnabled(false);
        initView();

    }

    private void initView() {
        lockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                if (lockView.isAnim()) {
                    lockView.setStopAnim(false);
                }
                btnConfirm.setEnabled(true);
            }

            @Override
            public void onVerifyFail() {
                btnConfirm.setEnabled(false);
            }
        });
    }

    @OnClick(R.id.btn_close)
    public void onClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C059D003001C003001);
        finish();

    }


    @OnClick({R.id.btn_change_mobile})
    public void onButtonClick(View view) {

        String mobile = etMobileNum.getText().toString().trim();
        String code = etCode.getText().toString().trim();
        if (!RegexUtils.isMobileSimple(mobile)) {
            ToastUtils.showLongToast("请输入合法的手机号");
            return;
        }
        if (TextUtils.isEmpty(code)) {
            ToastUtils.showLongToast("请输入验证码");
            return;
        }

        HashMap<String, String> params = new HashMap<String, String>();
        params.put(ParamKeys.MOBILE, mobile);
        params.put(ParamKeys.SMS_PASSWD, code);
        params.put(ParamKeys.ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());

        new AccountMode(mContext).changeMobile(params, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(Result<String> apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C059F008002O008001);
                if (apiResult.getResult().equals("OK")) {
                    ToastUtils.showLongToast("手机号修改成功");
                    finish();
                }
            }

            @Override
            public void onComplete() {

            }
        });

    }

    @OnClick({R.id.timmer_get_code})
    public void onTimmerClick(View view) {
        String mobile = etMobileNum.getText().toString().trim();
        if (!RegexUtils.isMobileSimple(mobile)) {
            ToastUtils.showLongToast("请输入合法的手机号");
            return;
        }
        sendMobileCode(mobile);
    }

    public void sendMobileCode(String phone) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, phone);

        new AccountMode(mContext).smsChange(params, new ApiResultObserver<VerifyBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(VerifyBean apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C059F008001O008001);
                internetId = apiResult.getInternetId();
                etCode.setText(apiResult.getSmspasswd());
                timeCode.start();
            }

            @Override
            public void onComplete() {

            }
        });


    }
}
