package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApplication;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.PreferencesUtils;
import com.community.equity.utils.Utils;

import java.util.Timer;
import java.util.TimerTask;

import javax.inject.Inject;

import cn.jpush.android.api.JPushInterface;


public class LoadingActivity extends BaseActivity {

    @Inject BaseApplication application;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (application!=null){
            Toast.makeText(mContext, "buweikong", Toast.LENGTH_SHORT).show();
        }else{
            Toast.makeText(mContext, "weikong", Toast.LENGTH_SHORT).show();

        }
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
