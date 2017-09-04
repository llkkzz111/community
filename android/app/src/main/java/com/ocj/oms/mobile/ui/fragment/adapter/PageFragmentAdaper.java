package com.ocj.oms.mobile.ui.fragment.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.ocj.oms.mobile.ui.fragment.OrderDetailFragment;
import com.ocj.oms.mobile.ui.fragment.QueryBalanceFragment;
import com.ocj.oms.mobile.ui.fragment.WalletRechargeFragment;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liu on 2017/8/8.
 */

public class PageFragmentAdaper extends FragmentPagerAdapter {
    private List<String> tabs = new ArrayList<>();

    String fragmentType = "";

    public PageFragmentAdaper(FragmentManager fm, List<String> titles) {
        super(fm);
        tabs.clear();
        tabs.addAll(titles);
    }

    @Override
    public Fragment getItem(int position) {
        Fragment fragment = null;
        if (tabs != null) {
            if (tabs.get(position).equals("礼包充值")) {
                fragmentType = "礼包充值";
                WalletRechargeFragment homeFragment = new WalletRechargeFragment();
                fragment = homeFragment;
            } else if (tabs.get(position).equals("余额查询")) {
                fragmentType = "余额查询";
                QueryBalanceFragment motionFragment = new QueryBalanceFragment();
                fragment = motionFragment;
            } else {
                fragmentType = "订单详情";
                OrderDetailFragment orderFragment = new OrderDetailFragment();
                orderFragment.setOrderId(tabs.get(position));
                orderFragment.setPageNum((position) + 1 + "/" + tabs.size());
                fragment = orderFragment;
            }
        }
        return fragment;
    }

    public String getFragmentType() {
        return fragmentType;
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
