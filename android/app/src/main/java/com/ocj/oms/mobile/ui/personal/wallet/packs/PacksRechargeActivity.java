package com.ocj.oms.mobile.ui.personal.wallet.packs;

import android.content.Intent;
import android.support.design.widget.TabLayout;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.ui.fragment.adapter.PageFragmentAdaper;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.view.UnSlideViewPage;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.Arrays;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
@Route(path = RouterModule.AROUTER_PATH_GIFTRECHARGE)
public class PacksRechargeActivity extends BaseActivity {

    @BindView(R.id.viewpager) UnSlideViewPage viewPager;
    @BindView(R.id.sliding_tabs) TabLayout tabLayout;

    PageFragmentAdaper pagerAdapter;
    private List<String> tabTitles = Arrays.asList("礼包充值", "余额查询");

    @Override
    protected int getLayoutId() {
        return R.layout.activity_packs_recharge_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext,ActivityID.AP1706C044);
        pagerAdapter = new PageFragmentAdaper(getSupportFragmentManager(), tabTitles);
        viewPager.setAdapter(pagerAdapter);
        tabLayout = (TabLayout) findViewById(R.id.sliding_tabs);
        tabLayout.setupWithViewPager(viewPager);
        tabLayout.setTabMode(TabLayout.MODE_FIXED);

    }


    @OnClick({R.id.btn_close})
    public void onClick(View view) {
        finish();
    }

    @OnClick(R.id.btn_go_rapid_register)
    public void onInstrutionClick(View view) {
        startActivity(new Intent(this, UseInstructionActivity.class));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C044);
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C045);
    }
}
