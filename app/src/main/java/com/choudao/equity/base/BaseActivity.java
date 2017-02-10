package com.choudao.equity.base;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.bumptech.glide.Glide;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.UIManager;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.view.ViewController;
import com.umeng.analytics.MobclickAgent;

import java.util.Arrays;

import cn.jpush.android.api.JPushInterface;

/**
 * Created by Han on 2016/3/9.
 */
public class BaseActivity extends AppCompatActivity implements ViewController {
    private final String TAG = getClass().getSimpleName();
    public Activity mContext;
    public boolean isDestory = false;
    public ApiService service = null;
    protected View[] mSubContentView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityStack.getInstance().pushActivity(this);
        mContext = this;
        service = ServiceGenerator.createService(ApiService.class);
    }

    @Override
    protected void onPause() {
        super.onPause();
        Glide.with(mContext).pauseRequests();
        MobclickAgent.onPause(this);
        JPushInterface.onPause(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Glide.with(mContext).resumeRequests();
        MobclickAgent.onResume(this);
        JPushInterface.onResume(this);
    }

    @Override
    protected void onRestart() {
        super.onRestart();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        isDestory = true;
        if (Util.isOnMainThread()) {
            Glide.get(mContext).clearMemory();
        }
        ActivityStack.getInstance().finishActivity(this);
    }



    @Override
    public View showErrorView(String msg) {
        hideContentView();
        hideEmptyView();
        hideLoadView();
        return UIManager.getInstance().showErrorView(this, msg);
    }

    @Override
    public void showLoadView() {
        hideContentView();
        hideEmptyView();
        hideErrorView();
        UIManager.getInstance().showLoadView(this);
    }

    @Override
    public void showContentView() {
        hideEmptyView();
        hideLoadView();
        hideErrorView();
        if (!Utils.isEmpty(Arrays.asList(mSubContentView))) {
            for (int i = 0; i < mSubContentView.length; i++) {
                View view = mSubContentView[i];
                if (view != null) {
                    view.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    @Override
    public View showEmptyView(String msg) {
        hideContentView();
        hideLoadView();
        hideErrorView();
        return UIManager.getInstance().showEmptyView(this, msg);
    }

    private void hideContentView() {
        if (!Utils.isEmpty(Arrays.asList(mSubContentView))) {
            for (int i = 0; i < mSubContentView.length; i++) {
                View view = mSubContentView[i];
                if (view != null) {
                    view.setVisibility(View.GONE);
                }
            }
        }
    }

    /**
     * 当前Activity退出时的动画
     */
    public void animRightToLeft() {
        try {
            overridePendingTransition(R.anim.push_right_in,
                    R.anim.push_right_to);
        } catch (Exception e) {
        }
    }

    /**
     * 当前Activity进入时的动画
     */
    public void animLeftToRight() {
        try {
            overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out);
        } catch (Exception e) {
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        ActivityStack.getInstance().finishActivity();
    }

    private void hideLoadView() {
        UIManager.getInstance().hideLoadView(this);
    }

    private void hideErrorView() {
        UIManager.getInstance().hideErrorView(this);
    }


    private void hideEmptyView() {
        UIManager.getInstance().hideEmptyView(this);
    }

    public void setSubContentView(View... subContentView) {
        this.mSubContentView = subContentView;
    }

}
