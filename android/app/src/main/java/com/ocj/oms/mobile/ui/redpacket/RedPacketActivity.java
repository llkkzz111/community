package com.ocj.oms.mobile.ui.redpacket;

import android.support.v7.widget.AppCompatTextView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/11.
 */

public class RedPacketActivity extends BaseActivity {
    @BindView(R.id.tv_goods) AppCompatTextView tvGoods;
    @BindView(R.id.tv_time) TextView tvTime;
    @BindView(R.id.tv_way) TextView tvWay;
    @BindView(R.id.iv_close) ImageView ivClose;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_red_packet_layout;
    }

    @Override
    protected void initEventAndData() {
        String hint = getIntent().getStringExtra(IntentKeys.PRIZE_NAME);
        String start = getIntent().getStringExtra(IntentKeys.START_DATE);
        String end = getIntent().getStringExtra(IntentKeys.END_DATE);
        if (!TextUtils.isEmpty(end)) {
            if (!TextUtils.isEmpty(start)) {
                tvTime.setText("使用时间：" + start + " - " + end);
            } else {
                tvTime.setText("使用时间至：" + end);
            }
        } else {
            tvTime.setVisibility(View.INVISIBLE);
        }

        tvGoods.setText(hint);
    }

    @OnClick(R.id.rl_root)
    public void onViewClicked() {
        finish();
    }
}
