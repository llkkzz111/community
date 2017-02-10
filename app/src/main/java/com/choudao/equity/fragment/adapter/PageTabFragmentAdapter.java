package com.choudao.equity.fragment.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.choudao.equity.fragment.ErrorFragment;
import com.choudao.equity.fragment.HomeFragment;
import com.choudao.equity.fragment.MessageFragment;

import java.util.List;

/**
 * Created by liuzhao on 17/2/8.
 */

public class PageTabFragmentAdapter extends FragmentStatePagerAdapter {

    private List<String> tabs;

    public PageTabFragmentAdapter(FragmentManager fm, List<String> titles) {
        super(fm);
        this.tabs = titles;
    }

    @Override
    public Fragment getItem(int position) {
        Fragment fragment = null;
        if (tabs != null) {
            if (tabs.get(position).equals("最新")) {
                HomeFragment homeFragment = new HomeFragment();
                fragment = homeFragment;
            } else if (tabs.get(position).equals("筹道股权")) {
                MessageFragment motionFragment = new MessageFragment();
                fragment = motionFragment;
            } else {
                ErrorFragment errorFragment = new ErrorFragment();
                fragment = errorFragment;

            }
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
