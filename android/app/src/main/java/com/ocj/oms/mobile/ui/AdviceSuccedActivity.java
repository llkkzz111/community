package com.ocj.oms.mobile.ui;

import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.OCJPreferencesUtils;

import butterknife.OnClick;

/**
 * Created by yy on 2017/6/25.
 */

public class AdviceSuccedActivity extends BaseActivity {
    @Override
    protected int getLayoutId() {
        return R.layout.activity_advice_succed_layout;
    }

    @Override
    protected void initEventAndData() {

    }

    @OnClick({R.id.btn_close, R.id.tv_submit})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                finish();
                break;

            case R.id.tv_submit:
                RouterModule.sendEvent("refreshApp", "self", OCJPreferencesUtils.getAccessToken(), "refreshToHomePage");
                break;
        }
    }


}
