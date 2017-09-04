package com.ocj.oms.mobile.ui.personal.advice;

import android.content.Intent;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.AdviceSuccedActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * 我要提意见
 * Created by yy on 2017/5/23.
 */

public class AdviceCtiticActivity extends BaseActivity {
    @BindView(R.id.btn_close) ImageView btnClose;
    @BindView(R.id.rb_login) RadioButton rbLogin;
    @BindView(R.id.rb_order) RadioButton rbOder;
    @BindView(R.id.rb_pay) RadioButton rbPay;
    @BindView(R.id.rb_other) RadioButton rbOther;
    @BindView(R.id.rg_select_pay) RadioGroup rgSelectPay;
    @BindView(R.id.et_daily_content) EditText etDailyContent;
    @BindView(R.id.tv_submit) TextView tvSubmit;
    private String feedbackType = "1";

    @Override
    protected int getLayoutId() {
        return R.layout.activity_criticism_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C067);
    }

    @OnCheckedChanged({R.id.rb_login, R.id.rb_order, R.id.rb_pay, R.id.rb_other})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.rb_login:
                    feedbackType = "1";
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068F012001O006001);
                    break;
                case R.id.rb_order:
                    feedbackType = "2";
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068F012001O006002);
                    break;
                case R.id.rb_pay:
                    feedbackType = "3";
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068F012001O006003);
                    break;
                case R.id.rb_other:
                    feedbackType = "4";
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068F012001O006004);
                    break;
            }
        }
    }


    @OnTextChanged(value = R.id.et_daily_content, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onNoTextChanged(CharSequence text) {

    }

    @OnClick({R.id.btn_close, R.id.tv_submit})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068D003001C003001);

                finish();
                break;
            case R.id.tv_submit:

                String detail = etDailyContent.getText().toString();
                if (detail.length() > 200) {
                    ToastUtils.showShortToast("意见太长");
                    return;
                }
                showLoading();
                Map<String, String> params = new HashMap<>();
                params.put(ParamKeys.FEEDBACK_TYPE, feedbackType);
                params.put(ParamKeys.FEEDBACK_DETAIL, etDailyContent.getText().toString());
                new AccountMode(mContext).suggestion(params, new ApiResultObserver<Result<String>>(mContext) {
                    @Override
                    public void onSuccess(Result<String> apiResult) {
                        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C068F008001O008001);
                        hideLoading();
                        RouterModule.sendAdviceEvent("refreshToHomePage", false);
                        Intent intent = getIntent();
                        intent.setClass(mContext, AdviceSuccedActivity.class);
                        startActivity(intent);
                        ToastUtils.showShortToast("提交成功");
                    }

                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showShortToast(e.getMessage());
                        hideLoading();
                    }
                });
                break;
        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext,ActivityID.AP1706C067);
    }
}
