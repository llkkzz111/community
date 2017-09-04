package com.ocj.oms.mobile.ui.reset;

import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import butterknife.BindView;
import butterknife.OnClick;

public class ResetMailActivity extends BaseActivity {
    @BindView(R.id.btn_i_know) Button btnNextStep;
    @BindView(R.id.btn_pwd_back) ImageView btnBack;
    @BindView(R.id.tv_mail) TextView tvMail;
    @BindView(R.id.tv_tips) TextView tvTips;
    @BindView(R.id.tv_title) TextView tvTitle;
    private String loginId;
    private String userName;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_reset_password_mail_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C009);
        loginId = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        userName = getIntent().getStringExtra(IntentKeys.USER_NAME);
        tvTitle.setText("修改邮箱");
        String secretName = createName((TextUtils.isEmpty(userName) ? OCJPreferencesUtils.getCustName() : userName));
        tvTips.setText(secretName + " 您好，");
        tvMail.setText(loginId);
    }

    private String createName(String s) {
        if (s.length() < 2) {
            return s;
        }
        StringBuilder builder = new StringBuilder();
        String firstName = s.substring(0, 1);
        builder.append(firstName);
        for (int i = 0; i < s.length() - 1; i++) {
            builder.append("*");
        }
        return builder.toString();
    }


    @OnClick({R.id.btn_i_know, R.id.btn_pwd_back})
    void onClick(View v) {
        OcjStoreDataAnalytics.trackEvent(mContext, ActivityID.AP1706C009);
        finish();
    }

}
