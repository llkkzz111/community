package com.ocj.oms.mobile.ui.webview;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.TypedArray;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.google.gson.Gson;
import com.ocj.oms.common.JConfig;
import com.ocj.oms.common.net.NetUtils;
import com.ocj.oms.common.net.mode.ApiHost;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.h5.FragmentBean;
import com.ocj.oms.mobile.bean.h5.H5ParamsBean;
import com.ocj.oms.mobile.ui.LoadingActivity;
import com.ocj.oms.mobile.ui.register.RegisterInputMobileActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.video.player.OcjLiveEmptyActivity;
import com.ocj.oms.mobile.utils.FileUitls;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.OCJPreferencesUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

import static com.ocj.oms.mobile.IntentKeys.VIDEO_URL;
import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_LOGIN;
import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_PAY;
import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_RELOGIN;
import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_SHARE;

@Route(path = RouterModule.AROUTER_PATH_WEBVIEW)
public class WebViewActivity extends BaseActivity {
    private static final int FILECHOOSER_RESULTCODE = 10;
    @BindView(R.id.webview) WebView webview;
    private String url;
    private ValueCallback<Uri> mUploadMessage;
    private ValueCallback<Uri[]> mUploadMessages;
    protected int activityCloseEnterAnimation;
    protected int activityCloseExitAnimation;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_web_view_layout;
    }

    @Override
    protected void initEventAndData() {

        TypedArray activityStyle = getTheme().obtainStyledAttributes(new int[]{android.R.attr.windowAnimationStyle});
        int windowAnimationStyleResId = activityStyle.getResourceId(0, 0);
        activityStyle.recycle();
        activityStyle = getTheme().obtainStyledAttributes(windowAnimationStyleResId, new int[]{android.R.attr.activityCloseEnterAnimation, android.R.attr.activityCloseExitAnimation});
        activityCloseEnterAnimation = activityStyle.getResourceId(0, 0);
        activityCloseExitAnimation = activityStyle.getResourceId(1, 0);
        activityStyle.recycle();

        showLoading();
        url = getIntent().getStringExtra(IntentKeys.URL);
        if (TextUtils.isEmpty(url) || Uri.parse(url).getEncodedPath().startsWith("/detail/sx/") && !getIntent().hasExtra(IntentKeys.FROM_SCAN)) {
            url = JConfig.RNReturnUrl;
            if (TextUtils.isEmpty(url))
                backPressed();
            if (url.contains("#")) {
                url = url.substring(0, url.indexOf('#'));
            }
            Uri uri = Uri.parse(url);
            List<String> listpath = uri.getPathSegments();

            if (listpath.contains("mobileappdetail") || listpath.contains("detail")) {
                backPressed();
                return;
            }
        } else if (url.equals("https://m.ocj.com.cn/customers/emp/new/method1/rednumber")) {
            toLogin();
            return;
        } else if (url.equals(" http://m.ocj.com.cn/01_03_sd")) {
            backPressed();
            return;
        }

        if (toVideoPlay(url)) {
            backPressed();
            return;
        }

        if (toRNDetails(url, true)) {
            backPressed();
            return;
        }

        if (toCart(url)) {
            backPressed();
            return;
        }

        webview.getSettings().setJavaScriptEnabled(true);
        webview.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        webview.getSettings().setUserAgentString("OCJ_A1JKapp_log Mozilla/5.0 (Linux; U; Android 4.3; zh-cn; C6802 Build/14.2.A.0.290) AppleWebKit/534.30 (KHTML, like Gecko) Android Mobile[355066062891876#f0:25:b7:b3:15:69#SM-G9008V#6.0.1#WIFIMAC:f0:25:b7:b3:15:69]app_reconsitution");
        webview.setWebChromeClient(new WebChromeClient());

        Map<String, String> extraHeaders = new HashMap<String, String>();
        extraHeaders.put("X-access-token", OCJPreferencesUtils.getAccessToken());
        webview.loadUrl(url, extraHeaders);
        webview.addJavascriptInterface(this, "Ocj");
        webview.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                hideLoading();
                JumpNative(url);
            }

            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                return toRNDetails(url, false);
            }

        });

        webview.setWebChromeClient(new OCJWebChromeClient());

    }

    private void toLogin() {
        Intent intent = new Intent();
        intent.setClass(mContext, RegisterInputMobileActivity.class);
        startActivity(intent);
        backPressed();
    }

    //跳购物车
    private boolean toCart(String url) {
        if ((ApiHost.H5_HOST + "/cart.jhtml").equals(url)) {
            RouterModule.videoToCart();
            return true;
        }
        return false;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == FILECHOOSER_RESULTCODE) {
            if (null == mUploadMessage && mUploadMessages == null) return;
            Uri result = data == null || resultCode != RESULT_OK ? null : data.getData();
            if (result == null) {
                if (mUploadMessage != null) {
                    mUploadMessage.onReceiveValue(null);
                    mUploadMessage = null;
                }
                if (mUploadMessages != null) {
                    mUploadMessages.onReceiveValue(null);
                    mUploadMessages = null;
                }
                return;
            }
            Log.i("UPFILE", "onActivityResult" + result.toString());
            String dataString = data.getDataString();

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                dataString = "file://" + FileUitls.getPath(mContext, result);
                Uri[] results = new Uri[]{Uri.parse(dataString)};
                mUploadMessages.onReceiveValue(results);
            } else {
                result = Uri.parse(dataString);
                mUploadMessage.onReceiveValue(result);
            }

            mUploadMessage = null;
        }

    }

    private boolean toVideoPlay(String url) {
        if (TextUtils.isEmpty(url)) {
            return false;
        }
        String urlLow = url.toLowerCase();
        if (urlLow.contains("eventbarragevideo")) {
            Intent intent = new Intent();
            intent.putExtra(VIDEO_URL, urlLow);
            intent.setClass(mContext, OcjLiveEmptyActivity.class);
            startActivity(intent);
            return true;
        }
        return false;
    }


    private boolean toRNDetails(String url, boolean isScan) {
        if (TextUtils.isEmpty(url)) {
            return false;
        }
        if (closeWebView(url)) {
            return true;
        }

        Uri uri = Uri.parse(url);

        String path = uri.getPath();
        List<String> listpath = uri.getPathSegments();

        String isBone = null;
        String itemId = null;
        if (listpath.size() > 0) {
            itemId = listpath.get(listpath.size() - 1);
        }

        if (!TextUtils.isEmpty(uri.getQuery())) {
            for (String key : uri.getQueryParameterNames()) {
                if ("isBone".equals(key)) {
                    isBone = uri.getQueryParameter(key);
                    break;
                }
            }
        }

        if (listpath.contains("mobileappdetail")) {
            JConfig.RNReturnUrl = webview.getUrl();
            RouterModule.h5ToDetail(itemId, isBone, getIntent().getStringExtra("url"), isScan);
            return true;
        } else if (isUrlDetail(uri)) {
            RouterModule.h5ToDetail(itemId, isBone, getIntent().getStringExtra("url"), isScan);
            return true;
        } else {
            JumpNative(url);
        }
        return hasFragment(url);
    }

    /**
     * 判断是否是商品详情跳转
     *
     * @param
     * @return
     */
    private boolean isUrlDetail(Uri uri) {
        if (uri == null) {
            return false;
        }
        String host = uri.getHost();

        if (TextUtils.isEmpty(host)) {
            return false;
        }
        if (!(host.equals("m.ocj.com.hk") || host.equals("m.ocj.com.cn") || host.equals("www.ocj.com.cn"))) {
            return false;
        }
        String path = uri.getPath();
        if (path == null) {
            return false;
        }
        int index = 0;
        if (path.contains("/")) {
            index = path.lastIndexOf("/");
        }
        String flag = path.substring(0, index);
        if (!TextUtils.isEmpty(flag) && (flag.equals("/detail") || flag.equals("/qr/detail"))) {
            return true;
        }
        return false;
    }

    private boolean hasFragment(String url) {
        Uri uri = Uri.parse(url);
        String fragment = uri.getFragment();
        if (TextUtils.isEmpty(fragment)) {
            return false;
        } else return fragment.startsWith("{");
    }

    private void JumpNative(String url) {

        String urlLow = url.toLowerCase();
        if (urlLow.contains("eventbarragevideo")) {
            Intent intent = new Intent();
            intent.putExtra(VIDEO_URL, urlLow);
            intent.setClass(mContext, OcjLiveEmptyActivity.class);
            startActivity(intent);
            return;
        }

        Uri uri = Uri.parse(url);
        String fragment = uri.getFragment();
        if (!TextUtils.isEmpty(fragment) && fragment.contains("#")) {
            fragment = fragment.substring(0, fragment.indexOf("#"));
        }
        if (!TextUtils.isEmpty(fragment)) {
            try {
                FragmentBean fragmentBean = new Gson().fromJson(fragment, FragmentBean.class);
                if ("share".equals(fragmentBean.getAction())) {
                    H5ParamsBean shareBean = fragmentBean.getParam();
                    ARouter.getInstance().build(AROUTER_PATH_SHARE).withString("from", "WebView")
                            .withString("title", shareBean.getTitle())
                            .withString("content", shareBean.getContent())
                            .withString("image_url", shareBean.getImage_url())
                            .withString("target_url", shareBean.getTarget_url())
                            .navigation();
                } else if ("login".equals(fragmentBean.getAction())) {
                    if (!TextUtils.isEmpty(OCJPreferencesUtils.getLoginId())) {
                        ARouter.getInstance().build(AROUTER_PATH_RELOGIN)
                                .withString("from", "WebView")
                                .withString("fromPage", fragmentBean.getUrl())
                                .navigation();
                    } else {
                        ARouter.getInstance().build(AROUTER_PATH_LOGIN)
                                .withString("from", "WebView")
                                .withString("fromPage", fragmentBean.getUrl())
                                .navigation();
                    }
                } else if ("pay".equals(fragmentBean.getAction())) {
                    ARouter.getInstance().build(AROUTER_PATH_PAY).withString("from", "WebView")
                            .withString("orders", "[\"" + fragmentBean.getParam().getOrder_no() + "\"]")
                            .navigation();
                } else if ("back".equals(fragmentBean.getAction())) {
                    RouterModule.onRouteBack();
                    backPressed();
                } else if ("detail".equals(fragmentBean.getAction())) {
                    JConfig.RNReturnUrl = webview.getUrl();
                    RouterModule.h5ToDetail(fragmentBean.getParam().getItemCode(), "", JConfig.RNReturnUrl, false);
                } else if ("cart".equals(fragmentBean.getAction())) {
                    RouterModule.videoToCart();
                }
            } catch (Exception e) {
            } finally {
            }

        } else if (url.equals("https://m.ocj.com.cn/customers/emp/new/method1/rednumber")) {
            toLogin();
        }
    }

    private boolean closeWebView(String url) {
        if (TextUtils.equals(url, "http://rm.ocj.com.cn/") ||
                TextUtils.equals(url, "http://m.ocj.com.cn/") ||
                TextUtils.equals(url, "http://rm.ocj.com.cn") ||
                TextUtils.equals(url, "http://m.ocj.com.cn") ||
                TextUtils.equals(url, "http://rm.ocj.com.cn/?substation_code") ||
                TextUtils.equals(url, "http://m.ocj.com.cn/?substation_code") ||
                TextUtils.equals(url, "http://rm.ocj.com.cn/") ||
                TextUtils.equals(url, "http://m.ocj.com.cn/") ||
                TextUtils.equals(url, "https://rm.ocj.com.hk/") ||
                TextUtils.equals(url, "https://m.ocj.com.hk/") ||
                TextUtils.equals(url, "http://rm.ocj.com.hk/") ||
                TextUtils.equals(url, "http://m.ocj.com.hk/")) {
            RouterModule.onRouteBack();
            backPressed();
            return true;
        }
        return false;
    }

    @JavascriptInterface
    public String getNetWorkState() {
        boolean isNet = NetUtils.isConnected(mContext);
        if (!isNet) {
            return "noNetWork";
        } else {
            if (NetUtils.isWiFi(mContext)) {
                return "WIFI";
            } else {
                return "WWAN";
            }
        }
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(activityCloseEnterAnimation, activityCloseExitAnimation);
    }

    class OCJWebChromeClient extends WebChromeClient {
        // For Android 3.0+
        public void openFileChooser(ValueCallback<Uri> uploadMsg) {
            if (mUploadMessage != null) {
                mUploadMessage.onReceiveValue(null);
            }
            mUploadMessage = uploadMsg;
            Intent i = new Intent(Intent.ACTION_GET_CONTENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
            i.setType("*/*");
            startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_RESULTCODE);
        }

        // For Android 3.0+
        public void openFileChooser(ValueCallback uploadMsg, String acceptType) {
            if (mUploadMessage != null) {
                mUploadMessage.onReceiveValue(null);
            }
            mUploadMessage = uploadMsg;
            Intent i = new Intent(Intent.ACTION_GET_CONTENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
            String type = TextUtils.isEmpty(acceptType) ? "*/*" : acceptType;
            i.setType(type);
            startActivityForResult(Intent.createChooser(i, "File Chooser"),
                    FILECHOOSER_RESULTCODE);
        }

        // For Android 4.1
        public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture) {
            if (mUploadMessage != null) {
                mUploadMessage.onReceiveValue(null);
            }
            mUploadMessage = uploadMsg;
            Intent i = new Intent(Intent.ACTION_GET_CONTENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
            String type = TextUtils.isEmpty(acceptType) ? "*/*" : acceptType;
            i.setType(type);
            startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_RESULTCODE);
        }


        //Android 5.0+
        @Override
        @SuppressLint("NewApi")
        public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, WebChromeClient.FileChooserParams fileChooserParams) {
            if (mUploadMessage != null) {
                mUploadMessage.onReceiveValue(null);
            }
            mUploadMessages = filePathCallback;


            Intent contentSelectionIntent = new Intent(Intent.ACTION_GET_CONTENT);
            contentSelectionIntent.addCategory(Intent.CATEGORY_OPENABLE);
            contentSelectionIntent.setType("image/*");

            Intent chooserIntent = new Intent(Intent.ACTION_CHOOSER);
            chooserIntent.putExtra(Intent.EXTRA_INTENT, contentSelectionIntent);
            chooserIntent.putExtra(Intent.EXTRA_TITLE, "Image Chooser");

            startActivityForResult(chooserIntent, FILECHOOSER_RESULTCODE);

            return true;
        }
    }

    @Override
    public void onBackPressed() {
        backPressed();
    }

    private void backPressed() {
        hideLoading();
        if (ActivityStack.getInstance().getActivityStack().size() >= 1) {
            finish();
        } else {
            Intent intent = new Intent();
            intent.setClass(mContext, LoadingActivity.class);
            startActivity(intent);
        }
    }
}
