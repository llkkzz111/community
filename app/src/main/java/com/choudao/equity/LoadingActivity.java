package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.Utils;

import java.util.Timer;
import java.util.TimerTask;

import cn.jpush.android.api.JPushInterface;


public class LoadingActivity extends BaseActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        JPushInterface.setAlias(getBaseContext(), "", null);
        setTheme(R.style.AppTheme_Launcher);
        setContentView(R.layout.activity_loading);
        JumpToActivity();
    }

    /**
     * 跳转到相应Activity
     */
    private void JumpToActivity() {
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                if (!PreferencesUtils.getFirstVisitState() || !Utils.getVersion(mContext).equals(PreferencesUtils.getCurrentVersion())) {
                    startNewActivity(GuidedActivity.class);
                } else {
                    if (ConstantUtils.isLogin && ConstantUtils.USER_ID > 0) {
                        startNewActivity(MainActivity.class);
                    } else {
                        startNewActivity(ConstantUtils.URL_ME);
                    }
                }
                PreferencesUtils.setCurrentVersion(Utils.getVersion(mContext));
            }
        }, 1000);

    }

    private void startNewActivity(String url) {
        Intent intent = getIntent();
        intent.setClass(mContext, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    private void startNewActivity(Class clz) {
        Intent intent = getIntent();
        intent.setClass(mContext, clz);
        startActivity(intent);
        finish();
    }
}
