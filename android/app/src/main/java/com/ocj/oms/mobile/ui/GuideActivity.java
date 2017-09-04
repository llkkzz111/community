package com.ocj.oms.mobile.ui;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;

import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.ui.fragment.GuideFragment;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/7/12.
 */

public class GuideActivity extends BaseActivity {


    @BindView(R.id.vp_guide) ViewPager vpGuide;
    private List<Fragment> fragments;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_guide_layout;
    }

    @Override
    protected void initEventAndData() {
        fragments = new ArrayList<>();
        fragments.add(GuideFragment.newInstance(R.drawable.guide_page1, false));
        fragments.add(GuideFragment.newInstance(R.drawable.guide_page2, false));
        fragments.add(GuideFragment.newInstance(R.drawable.guide_page3, true));
        GuidePageAdapter adapter = new GuidePageAdapter(getSupportFragmentManager());
        vpGuide.setAdapter(adapter);
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A050);


    }


    class GuidePageAdapter extends FragmentPagerAdapter {
        public GuidePageAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }

        @Override
        public int getCount() {
            return fragments.size();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706A050);
    }
}
