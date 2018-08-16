package com.community.equity.ui.base;

import android.content.pm.ActivityInfo;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.community.equity.base.IPresenter;
import com.community.equity.utils.ActivityStack;
import com.community.equity.utils.LoadingDialog;

import butterknife.ButterKnife;

/**
 * Created by liuzhao on 17/2/6.
 */

public abstract class BaseActivity<T extends IPresenter> extends com.community.equity.base.BaseActivity {

    public T mPresenter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setBaseConfig();
        setContentView(getLayoutId());
        ButterKnife.bind(this);
        if (mPresenter != null)
            mPresenter.attachView(this, this);
        initEventAndData();
    }

    private void setBaseConfig() {
        initTheme();
        ActivityStack.getInstance().pushActivity(this);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        ViewGroup contentFrameLayout = (ViewGroup) findViewById(Window.ID_ANDROID_CONTENT);
        View parentView = contentFrameLayout.getChildAt(0);
        if (parentView != null && Build.VERSION.SDK_INT >= 14) {
            parentView.setFitsSystemWindows(true);
        }

    }

    private void initTheme() {
    }

    protected abstract int getLayoutId();

    protected abstract void initEventAndData();

    public void showLoaing() {
        LoadingDialog.showLoading(this);
    }

    public void showLoaing(String msg) {
        LoadingDialog.showLoading(this, msg, true);
    }

    public void dismissLoading() {
        LoadingDialog.disDialog();
    }


}
