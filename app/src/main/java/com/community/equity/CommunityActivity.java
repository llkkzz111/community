package com.community.equity;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;

import com.community.equity.base.BaseActivity;
import com.community.equity.fragment.CommunityFragment;

public class CommunityActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_motion_list_layout);
        if (savedInstanceState == null) {
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            CommunityFragment fragment = new CommunityFragment();
            transaction.replace(R.id.frame_content, fragment);

            transaction.commit();
        }
    }
}
