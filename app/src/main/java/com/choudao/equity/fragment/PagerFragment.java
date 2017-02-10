package com.choudao.equity.fragment;

import android.support.v4.view.ViewPager;

import com.choudao.equity.R;
import com.choudao.equity.base.BaseLazyLoadFragment;
import com.choudao.equity.fragment.adapter.PageTabFragmentAdapter;
import com.viewpagerindicator.TabPageIndicator;

import java.util.List;

import butterknife.BindView;
import butterknife.OnPageChange;

/**
 * Created by liuzhao on 17/2/8.
 */

public class PagerFragment extends BaseLazyLoadFragment {

    @BindView(R.id.indicator) TabPageIndicator indicator;
    @BindView(R.id.viewpager) ViewPager viewPager;
    List<String> tabs;
    PageTabFragmentAdapter fragmentAdapter;

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_view_pager;
    }

    @Override
    protected void initEventAndData() {
        fragmentAdapter = new PageTabFragmentAdapter(getFragmentManager(), tabs);
        viewPager.setAdapter(fragmentAdapter);
        indicator.setViewPager(viewPager);
    }

    @Override
    protected void lazyLoadData() {

    }

    public void setTabs(List<String> tabs) {
        this.tabs = tabs;
    }

    @OnPageChange(value = R.id.viewpager, callback = OnPageChange.Callback.PAGE_SELECTED)
    public void onPageSelected(int position) {

    }
}
