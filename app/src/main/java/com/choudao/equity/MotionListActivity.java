package com.choudao.equity;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.fragment.MotionFragment;
import com.choudao.equity.utils.params.IntentKeys;

public class MotionListActivity extends BaseActivity {
    private int userId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_motion_list_layout);
        userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);
        if (savedInstanceState == null) {
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            MotionFragment fragment = new MotionFragment();
            fragment.setUserId(userId);
            transaction.replace(R.id.frame_content, fragment);

            transaction.commit();
        }
    }
}
