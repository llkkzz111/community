package com.community.equity.view;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.R;
import com.community.equity.utils.UIManager;
import com.community.equity.utils.Utils;

/**
 * Created by Han on 2016/3/9.
 */
public class CDWebView extends WebView {
    public boolean mIsErrorPage;
    private Context _context = null;
    private View mErrorView;
    private boolean mErrorLayoutFlag;

    public CDWebView(Context context) {
        super(context);
        _context = context;
        initSettings();
    }

    public CDWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
        _context = context;
        initSettings();
    }

    public CDWebView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        _context = context;
        initSettings();
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public CDWebView(Context context, AttributeSet attrs, int defStyle,
                     boolean privateBrowsing) {
        super(context, attrs, defStyle, privateBrowsing);
        _context = context;
        initWebView();
        initSettings();
    }

    @Override
    public void loadData(String data, String mimeType, String encoding) {
        super.loadData(data, mimeType, encoding);
    }

    @Override
    public void reload() {
        super.reload();
    }

    @Override
    public void stopLoading() {
        super.stopLoading();
    }

    private void initWebView() {
        this.setNetworkAvailable(true);
        this.setVerticalScrollBarEnabled(false);
        this.setHorizontalScrollBarEnabled(false);
        showErrorPage(null);
    }

    private void initSettings() {

        WebSettings settings = this.getSettings();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
        // 获取缓存路径
        String cacheDir = _context.getApplicationContext()
                .getDir("_cache", Context.MODE_MULTI_PROCESS).getPath();
        String dbDir = _context.getApplicationContext()
                .getDir("_db", Context.MODE_MULTI_PROCESS).getPath();
        settings.setSaveFormData(false);
        settings.setSavePassword(false);
        // 设置所有文件都由该类访问
        settings.setAllowFileAccess(true);
        settings.setUserAgentString(settings.getUserAgentString() + " community/" + Utils.getVersion(UIManager.getInstance().getBaseContext()));
        // 设置可以支持缩放
        settings.setSupportZoom(true);
        // 设置出现缩放工具
//        settings.setBuiltInZoomControls(true);
        //设置自适应屏幕
//        settings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN);
        settings.setLoadWithOverviewMode(true);
        // 设置appCache大小
        //        settings.setAppCacheMaxSize(8 * 1024 * 1024);
        // 设置启用的viewport meta
        //扩大比例的缩放
        settings.setUseWideViewPort(true);

        // 设置缓存路径
        //        settings.setAppCachePath(cacheDir);
        // 设置数据库路径
        //        settings.setDatabasePath(dbDir);
        // 地理db存储路径
        //        settings.setGeolocationDatabasePath(dbDir);
        // 设置数据库启用
        //        settings.setDatabaseEnabled(true);
        // 启用地理定位
        //        settings.setGeolocationEnabled(true);
        // 设置启用applicationCache
        //        settings.setAppCacheEnabled(true);
        // 设置打开localstorage使用
        settings.setDomStorageEnabled(true);
        // 设置启用javascript
        settings.setJavaScriptEnabled(true);
        // 设置从缓存中加载，如果缓存中没有再从网络上下载
        // settings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
        //        settings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
        // 启用硬件加速
        settings.setRenderPriority(WebSettings.RenderPriority.HIGH);
        // 设置js能够打开一个新的webview进行页面加载，可以调window.open()
        //        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        // 支持hover伪类和active伪类 android4.3有用
        // settings.setLightTouchEnabled(true);
        // 设置的WebView是否能顺利过渡，而平移或缩放或在主办的WebView窗口没有焦点。
        // 如果这是真的，web视图会选择一个解决方案，以最大限度地提高性能。
        // 例如web视图的内容不得在过渡期间进行更新。如果是假的，web视图将保持其保真度。
        // 默认值是false。 API 17 4.2.2
        settings.setEnableSmoothTransition(true);
        // 设置解析html的默认编码
        settings.setDefaultTextEncodingName("UTF-8");
        // this.setChildrenDrawnWithCacheEnabled(true);
        // this.setChildrenDrawingCacheEnabled(true);
        // this.setChildrenDrawingOrderEnabled(true);
        // this.setAlwaysDrawnWithCacheEnabled(true);
        // this.setAnimationCacheEnabled(true);

        //		bbCacheTool = BBCacheTool.getInstance(_context);

    }


    @SuppressLint("JavascriptInterface")
    @Override
    public void addJavascriptInterface(Object obj, String interfaceName) {
        if (TextUtils.isEmpty(interfaceName)) {
            return;
        }
        super.addJavascriptInterface(obj, interfaceName);
    }

    /**
     * 这个方法在Android 4.4系统引入，因此只能在Android4.4系统中才能使用，提供在当前页面显示上下文中异步执行javascript代码
     *
     * @param script
     * @param resultCallback
     */
    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void evaluateJavascript(String script, ValueCallback<String> resultCallback) {
        super.evaluateJavascript(script, resultCallback);
    }

    /**
     * Android4.2
     *
     * @return
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private boolean hasJellyBeanMR1() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1;
    }


    /**
     * 显示自定义错误提示页面，用一个View覆盖在WebView
     */
    public void showErrorPage(NetWorkErrorClickListener errorClickListener) {
        if (!mErrorLayoutFlag) {
            mErrorLayoutFlag = true;
            ViewGroup webParentView = (ViewGroup) this.getParent();

            if (webParentView != null) {
                initErrorPage(errorClickListener);
                while (webParentView.getChildCount() > 1) {
                    webParentView.removeViewAt(1);
                }
                LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
                webParentView.addView(mErrorView, 1, lp);
                mErrorView.setVisibility(View.VISIBLE);
                mIsErrorPage = true;
                //				bbCacheTool.setReceivedError(mIsErrorPage);
            }
        }

    }

    /**
     * 隐藏自定义错误页面
     */
    public void hideErrorPage() {
        mErrorLayoutFlag = false;
        ViewGroup webParentView = (ViewGroup) this.getParent();
        if (mErrorView != null)
            mErrorView.setVisibility(View.GONE);
        if (webParentView != null) {
            mIsErrorPage = false;
            //			bbCacheTool.setReceivedError(mIsErrorPage);
            while (webParentView.getChildCount() > 1) {
                webParentView.removeViewAt(1);
            }
        }

    }

    /**
     * 初始化自定义错误页面
     */
    protected void initErrorPage(final NetWorkErrorClickListener errorClickListener) {
        if (mErrorView == null) {
            mErrorView = View.inflate(_context, R.layout.online_error, null);

            TextView textView = (TextView) mErrorView
                    .findViewById(R.id.tv_exception_tip_text);
            textView.setText("抱歉，网络连接失败\n请检查网络设置或刷新");
            TextView tvRefresh = (TextView) mErrorView.findViewById(R.id.tv_refresh);
            tvRefresh.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (Utils.isFastClick()) {
                        if (NetworkTool.isNetworkAvailable(_context)) {
                            if (errorClickListener != null) {
                                errorClickListener.onErrorClick();
                            } else {
                                loadUrl(getUrl());
                            }
                        } else {
                            //						ToastUtils.toastForShort(_context, R.string.network_unavailable_tip);
                        }
                    } else {
                        Toast.makeText(_context, "请勿快速点击", Toast.LENGTH_SHORT).show();
                    }
                }
            });

            mErrorView.setOnClickListener(null);
        }
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {

        return super.dispatchTouchEvent(ev);
    }


    /**
     * 网络异常点击外部监听器
     *
     * @author xjk
     */
    public interface NetWorkErrorClickListener {
        void onErrorClick();
    }
}