package com.ocj.oms.mobile.ui.personal.advice;

import android.content.Intent;
import android.net.Uri;
import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.OnClick;

/**
 * Created by yy on 2017/5/23.
 */

public class AdviceActivity extends BaseActivity {
    @Override
    protected int getLayoutId() {
        return R.layout.activity_advice_feedback_layout;
    }

    @Override
    protected void initEventAndData() {

    }

    @OnClick({R.id.btn_close})
    public void onClick(View view) {
        finish();

    }

    @OnClick({R.id.tv_praise_arrow, R.id.tv_criticism_arrow})
    public void onItemClick(View view) {
        switch (view.getId()) {

            case R.id.tv_praise_arrow:
                Intent viewIntent = new Intent("android.intent.action.VIEW",
                        Uri.parse("market://details?id=com.ocj.oms.mobile"));
                startActivity(viewIntent);
                break;

            case R.id.tv_criticism_arrow:
                startActivity(new Intent(mContext, AdviceCtiticActivity.class));
                break;


        }
    }


}
