package com.ocj.oms.mobile.ui;

import android.text.Html;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.BindView;

/**
 * Created by liu on 2017/6/22.
 */

public class UiTestActivity extends BaseActivity {

    @BindView(R.id.tv_tips) TextView tvTips;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_ui_test;//
    }

    @Override
    protected void initEventAndData() {
        tvTips.setText(Html.fromHtml(getString(R.string.text_order_pay_tips, 22)));

        tvTips.setText(Html.fromHtml(getString(R.string.count_down_time, 1, 2, 3, 4)));
    }
}
