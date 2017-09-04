package com.ocj.oms.mobile.ui.personal.setting;


import android.content.Intent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.ui.LoadingActivity;
import com.ocj.oms.mobile.view.CustomSeekbar;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

public class SettingTextSizeActivity extends BaseActivity implements CustomSeekbar.ResponseOnTouch {


    @BindView(R.id.btn_close) ImageView btnClose;
    @BindView(R.id.csb_text_size) CustomSeekbar csbTextSize;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.tv_content) TextView tvContent;
    private float fontScale = 0;
    private float newFontScale = 0;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_setting_text_size_layout;
    }

    private ArrayList<String> hintText = new ArrayList<String>();

    @Override
    protected void initEventAndData() {

        hintText.add("标准");
        hintText.add("较大");
        csbTextSize.initData(hintText);
        csbTextSize.setResponseOnTouch(this);
        fontScale = OCJPreferencesUtils.getFontScale();

        if (fontScale > 1) {
            csbTextSize.setProgress(1);
        }
    }

    @OnClick({R.id.btn_close})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C065D003001C003001);
                finishActivity();
                break;
        }
    }

    private void finishActivity() {
        if (fontScale != OCJPreferencesUtils.getFontScale()) {
            startMainActivity();
        } else
            finish();
    }

    private void startMainActivity() {
        ActivityStack.getInstance().finishAllActivity();
        Intent intent = new Intent();
        intent.setClass(mContext, LoadingActivity.class);
        startActivity(intent);
    }

    @Override
    public void onBackPressed() {
        finishActivity();
    }

    @Override
    public void onTouchResponse(int volume) {
        if (volume == 0) {
            newFontScale = 1;

        } else {
            newFontScale = 1.1f;
        }
        DensityUtil.setFountScale(mContext, newFontScale);
        OCJPreferencesUtils.setFontScale(newFontScale);
        tvTitle.setTextSize(18);
        tvContent.setTextSize(16);
    }
}
