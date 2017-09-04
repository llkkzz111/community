package com.ocj.oms.mobile.ui.redpacket;

import android.view.View;
import android.widget.TextView;

import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/11.
 */

public class LotteryRuleActivity extends BaseActivity {

    @BindView(R.id.tv_rule) TextView tvRule;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_lottery_rule_layout;
    }

    @Override
    protected void initEventAndData() {
        tvRule.setText(getIntent().getStringExtra(IntentKeys.LOTTERY_RULE));
    }

    @OnClick(R.id.iv_close)
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_close:
                finish();
                break;
        }
    }

}
