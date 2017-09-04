package com.ocj.oms.mobile.ui.fragment.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.PagerAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liu on 2017/5/13.
 */

public class PageTabFragmentAdapter extends FragmentPagerAdapter {

    private List<String> tabs = new ArrayList<>();
    private ArrayList<Fragment> mFragments;
    private ArrayList<String> mFragmentTypes;
    FragmentManager fm;
    String fragmentType = "";

    public PageTabFragmentAdapter(FragmentManager fm, List<String> titles) {
        super(fm);
        this.fm = fm;
        tabs.clear();
        tabs.addAll(titles);
    }

    public PageTabFragmentAdapter(FragmentManager fm, List<String> titles, ArrayList<Fragment> mFragments, ArrayList<String> mFragmentTypes) {
        super(fm);
        this.fm = fm;
        tabs.clear();
        tabs.addAll(titles);
        this.mFragments = mFragments;
        this.mFragmentTypes = mFragmentTypes;
    }

    @Override
    public Fragment getItem(int position) {
        fragmentType = mFragmentTypes.get(position);
        return mFragments.get(position);
    }

    public String getFragmentType() {
        return fragmentType;
    }

    @Override
    public long getItemId(int position) {
        // 获取当前数据的hashCode
        int hashCode = mFragments.get(position).hashCode();
        return hashCode;
    }

    @Override
    public int getCount() {
        return tabs.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {

        if (tabs != null && tabs.size() > 0 && tabs.get(position) != null) {
            return tabs.get(position);
        }
        return "";
    }

    @Override
    public int getItemPosition(Object object) {
        return PagerAdapter.POSITION_NONE;
    }


}
