package com.community.equity.ui;


import android.support.annotation.NonNull;
import android.support.design.internal.BottomNavigationItemView;
import android.support.design.widget.BottomNavigationView;
import android.support.v4.app.FragmentTransaction;
import android.view.MenuItem;

import com.community.equity.R;
import com.community.equity.base.BaseFragment;
import com.community.equity.fragment.MeFragment;
import com.community.equity.fragment.PagerFragment;
import com.community.equity.fragment.SessionsFragment;
import com.community.equity.ui.base.BaseActivity;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by liuzhao on 17/2/8.
 */

public class MainActivity extends BaseActivity {
    @BindView(R.id.bottomview) BottomNavigationView bottomView;
    @BindView(R.id.action_found) BottomNavigationItemView bottomItemView;
     private BaseFragment mCurrent, home, message, me = null;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_main_layout;
    }

    @Override
    protected void initEventAndData() {

        bottomView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
                if (mCurrent != null) {
                    fragmentTransaction.hide(mCurrent);
                }
                switch (item.getItemId()) {
                    case R.id.action_found:
                        if (home != null) {
                            fragmentTransaction.show(home);
                        } else {
                            home = new PagerFragment();
                            List<String> tabs = new ArrayList<>();
                            tabs.add("最新");
                            tabs.add("筹道股权");
                            ((PagerFragment)home).setTabs(tabs);
                            fragmentTransaction.add(R.id.content, home);
                        }
                        mCurrent = home;
                        break;
                    case R.id.action_message:
                        if (message != null) {
                            fragmentTransaction.show(message);
                        } else {
                            message = new SessionsFragment();
                            fragmentTransaction.add(R.id.content, message);
                        }
                        mCurrent = message;
                        break;
                    case R.id.action_me:
                        if (me != null) {
                            fragmentTransaction.show(me);
                        } else {
                            me = new MeFragment();
                            fragmentTransaction.add(R.id.content, me);
                        }
                        mCurrent = me;
                        break;
                }

                if (mCurrent != null) {
                    fragmentTransaction.addToBackStack(null);
                    if (!getSupportFragmentManager().isDestroyed()) {
                        fragmentTransaction.commitAllowingStateLoss();
                    }
                }
                return false;
            }
        });
        bottomItemView.performClick();
    }
}
