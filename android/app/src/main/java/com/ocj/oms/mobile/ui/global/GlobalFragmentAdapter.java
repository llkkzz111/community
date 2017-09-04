package com.ocj.oms.mobile.ui.global;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.List;

/**
 * 选择框架推荐地区或者字母fragment adapter
 * Created by shizhang.cai on 2017/6/7.
 */

public class GlobalFragmentAdapter extends FragmentPagerAdapter {
    private List<String> tabs;

    List<Fragment> fragmentList;

    public GlobalFragmentAdapter(FragmentManager fm) {
        super(fm);
    }

    public GlobalFragmentAdapter(FragmentManager fm, List<String> titles,List<Fragment> fragmentList) {
        super(fm);
        this.tabs = titles;
        this.fragmentList = fragmentList;
    }

    @Override
    public Fragment getItem(int position) {
        Fragment fragment = null;
        if (tabs != null) {
//            if (tabs.get(position).equals("推荐地区")) {
//                GlobalFragment1 globalFragment1 = new GlobalFragment1();
//                fragment = globalFragment1;
//            } else if (tabs.get(position).equals("字母排序")) {
//                GlobalFragment2 globalFragment2 = new GlobalFragment2();
//                fragment = globalFragment2;
//            }
            fragment = fragmentList.get(position);
        }
        return fragment;
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


}
