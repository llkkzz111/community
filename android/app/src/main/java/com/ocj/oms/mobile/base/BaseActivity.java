package com.ocj.oms.mobile.base;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.basekit.view.BaseView;
import com.ocj.oms.common.net.mode.ApiHost;
import com.ocj.oms.mobile.R;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.system.AppUtil;
import com.orhanobut.logger.Logger;
import com.trello.rxlifecycle2.components.support.RxFragmentActivity;
import com.umeng.analytics.MobclickAgent;

import javax.inject.Inject;

import butterknife.ButterKnife;


/**
 * Created by liuz on 16/9/30.
 */
public abstract class BaseActivity<M, V extends BaseContract.View<M>, P extends BaseContract.Presenter<V>> extends RxFragmentActivity implements BaseView<M> {

    @Inject
    protected P mPresenter;
    protected Activity mContext;

    private Dialog mLoadingDialog;
    private View mLoadingView;

    @Override
    public Resources getResources() {
        Resources resources = super.getResources();
        Configuration configuration = new Configuration();
        configuration.setToDefaults();
        configuration.fontScale = OCJPreferencesUtils.getFontScale();
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
        return resources;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        ActivityStack.getInstance().add(this);
        setBaseConfig();
        if (getLayoutId() > 0) {
            setContentView(getLayoutId());
            ButterKnife.bind(this);
        }
//        unifiedNativeApiHost();
        initEventAndData();
    }


    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    private void setBaseConfig() {
        initTheme();
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }

    protected abstract int getLayoutId();


    protected abstract void initEventAndData();

    private void initTheme() {
    }


    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            Logger.e("   现在是横屏");
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            Logger.e("   现在是竖屏");
        }
    }


    public void showLoading(String msg, boolean cancelable) {
        if (mLoadingDialog == null) {
            mLoadingView = LayoutInflater.from(this).inflate(R.layout.dialog_loading, null);
            TextView loadingText = (TextView) mLoadingView.findViewById(R.id.id_tv_loading_dialog_text);
            loadingText.setText("加载中...");
            mLoadingDialog = new Dialog(this, R.style.CustomProgressDialog);
            mLoadingDialog.setCanceledOnTouchOutside(false);
            mLoadingDialog.setContentView(mLoadingView, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        }
        if (!mLoadingDialog.isShowing() && !isFinishing()) {
            ((TextView) mLoadingView.findViewById(R.id.id_tv_loading_dialog_text)).setText(TextUtils.isEmpty(msg) ? "加载中..." : msg);
            mLoadingDialog.setCancelable(cancelable);
            mLoadingDialog.show();
        }
    }

    public void showLoading(String msg) {
        showLoading(msg, true);
    }

    public void showLoading() {
        showLoading(null, true);
    }

    @Override
    public void showShortToast(String msg) {
        ToastUtils.showShortToast(msg);
    }

    public void showShortToast(int msg_id) {
        ToastUtils.showShortToast(getString(msg_id));
    }

    @Override
    public void showLongToast(String msg) {
        ToastUtils.showLongToast(msg);
    }

    @Override
    public void hideLoading() {
        if (mLoadingDialog != null && mLoadingDialog.isShowing() && !isFinishing()) {
            mLoadingDialog.dismiss();
        }
    }

    public boolean equalsTwo(String a, String b) {
        if (a == null || b == null) {
            return false;
        }
        return a.equalsIgnoreCase(b);
    }

    public void showException(Throwable e) {

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ActivityStack.getInstance().remove(this);
    }


    @TargetApi(Build.VERSION_CODES.M)
    public void requestPermissionsSafely(String[] permissions, int requestCode) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(permissions, requestCode);
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    public boolean hasPermission(String permission) {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED;
    }

    /**
     * 将native的host设置为何RN一致
     */
    private void unifiedNativeApiHost() {
        if (AppUtil.isDebug()) {
            if (OCJPreferencesUtils.getRNApiHost() != null &&
                    !TextUtils.isEmpty(OCJPreferencesUtils.getRNApiHost())) {
                if (!ApiHost.API_HOST.equals(OCJPreferencesUtils.getRNApiHost())) {
                    ApiHost.API_HOST = OCJPreferencesUtils.getRNApiHost();
                }
            }
            if (OCJPreferencesUtils.getRNH5ApiHost() != null &&
                    !TextUtils.isEmpty(OCJPreferencesUtils.getRNH5ApiHost())) {
                if (!ApiHost.H5_HOST.equals(OCJPreferencesUtils.getRNH5ApiHost())) {
                    ApiHost.H5_HOST = OCJPreferencesUtils.getRNH5ApiHost();
                }
            }
        }
    }
}
