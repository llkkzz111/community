package com.choudao.equity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.RemoteException;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.entity.UserEntity;
import com.choudao.equity.entity.WxAccessToken;
import com.choudao.equity.entity.WxUserInfo;
import com.choudao.equity.service.IMServiceConnector;
import com.choudao.equity.service.IMServiceConnectorAIDL;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.CDWebChromeClient;
import com.choudao.equity.view.CDWebView;
import com.choudao.equity.view.CDWebViewClient;
import com.choudao.imsdk.utils.Logger;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by liuz on 2016/12/22.
 */
public class LoginActivity extends BaseActivity implements View.OnClickListener {
    @BindView(R.id.iv_back) ImageView ivBack;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.webview) CDWebView webView;
    @BindView(R.id.rl_webview_parent) RelativeLayout rlWebParent;
    @BindView(R.id.rotate_header_web_view_frame) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.progress_bar) ProgressBar mProgressBar;
    private View layout = null;
    private IWXAPI WXapi = null;
    private IMServiceConnectorAIDL connectorAIDL;
    private IMServiceConnector imServiceConnector = new IMServiceConnector() {


        @Override
        public void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL) {
            connectorAIDL = imServiceConnectorAIDL;
        }

        @Override
        public void onIMServiceDisconnected() {

        }
    };
    private BroadcastReceiver wxLoginReciver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            //登陆成功
            if (intent.getIntExtra(IntentKeys.KEY_WX_ERR_CODE, 1) == BaseResp.ErrCode.ERR_OK) {

                getWXAccessToken(intent);

            } else {
                String content = intent.getStringExtra(IntentKeys.KEY_WX_CONTENT);
                String errCode = intent.getStringExtra(IntentKeys.KEY_WX_ERR_CODE);

                //登陆失败
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, content, errCode), Toast.LENGTH_SHORT).show();
            }
            unregisterReceiver(wxLoginReciver);

        }


    };
    private Intent intent;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_layout);
        ButterKnife.bind(this);
        intent = getIntent();
        WXapi = WXAPIFactory.createWXAPI(this, ConstantUtils.WEIXIN_APPID, false);
        imServiceConnector.bindService(this);
        ActivityStack.getInstance().closeAllActivityOnlyCls(LoginActivity.class);
        initView();
        initWebView();
        initPtr();
        webView.loadUrl(ConstantUtils.URL_ME);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        this.intent = intent;
    }

    /**
     * 初始化View
     */
    private void initView() {
        layout = LayoutInflater.from(mContext).inflate(R.layout.webview_loading_layout, null);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(layoutParams);
        rlWebParent.addView(layout);
    }


    /**
     * 初始化WebView相关
     */
    private void initWebView() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (getApplicationInfo().flags &= ApplicationInfo.FLAG_DEBUGGABLE)) {
                WebView.setWebContentsDebuggingEnabled(true);
            }
        }

        webView.setVerticalScrollBarEnabled(false);
        webView.setWebViewClient(new CDWebViewClient(this) {
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Uri uri = Uri.parse(url);
                if (uri.getScheme().equals("choudao")) {
                    if (uri.getHost().equals("wechat_login")) {
                        loginByWeChat();
                    } else if (uri.getHost().equals("logout_success")) {
                        webView.loadUrl(ConstantUtils.URL_ME);
                        LogoutStates();
                    } else if (uri.getHost().equals("login_success")) {
                        loginSuccess(url);
                    }
                    return true;
                }
                return false;
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                setTitle(view);
            }


            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                setTitle(view);
                mPtrFrame.refreshComplete();
                //只有本地安装微信，才会将调用js
                if (WXapi.isWXAppInstalled()) {
                    webView.loadUrl("javascript:ChoudaoJSBridge.getWechatShareInfo()");
                }

            }
        });
        //将接口注入到JS中
        webView.addJavascriptInterface(this, "ChoudaoAndroidBridge");
        webView.setWebChromeClient(new CustomChromeClient(mProgressBar));
    }

    private void setTitle(WebView view) {
        String title = view.getTitle();
        if (!TextUtils.isEmpty(title)) {
            if (view.getTitle().indexOf("中国梦网") > 0) {
                title = "新浪微博登陆";
            }
        }
        tvTitle.setText(title);
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(getBaseContext());
        mPtrFrame.setPtrHandler(new PtrHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, webView, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                updateData();
            }

        });
    }

    /**
     * 更新数据
     */
    private void updateData() {
        if (ConstantUtils.URL_ME.equals(webView.getUrl())) {
            webView.loadUrl(ConstantUtils.URL_ME);
        } else {
            webView.loadUrl(webView.getUrl());
        }

    }

    /**
     * 处理退出登录状态保存以及跳转至重新登录界面
     */
    private void LogoutStates() {
        ConstantUtils.isLogin = false;
        PreferencesUtils.setLoginState(false);
        PreferencesUtils.setAccessToken("");
        PreferencesUtils.setTokenType("");
    }

    /**
     * 登陆成功之后的相关状态的保存
     *
     * @param url
     */
    private void loginSuccess(String url) {
        String accessToken = "";
        String returnTo = "";
        String tokenType = "";

        try {
            URI uri = new URI(url);
            Uri andoidUri = Uri.parse("?" + uri.getRawFragment());
            tokenType = andoidUri.getQueryParameter("token_type");
            accessToken = andoidUri.getQueryParameter("access_token");
            returnTo = andoidUri.getQueryParameter("return_to");
            PreferencesUtils.setTokenType(tokenType);
            PreferencesUtils.setAccessToken(accessToken);
            if (!TextUtils.isEmpty(returnTo))
                returnTo = URLDecoder.decode(returnTo);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } finally {
            getUserInfo(returnTo);
        }

    }

    /**
     * 获取用户信息
     *
     * @param url
     */
    private void getUserInfo(final String url) {
        service = ServiceGenerator.createService(ApiService.class);
        Call<UserEntity> repos = service.getUserInfo();
        repos.enqueue(new BaseCallBack<UserEntity>() {

            @Override
            protected void onSuccess(UserEntity body) {
                PreferencesUtils.setUserId(body.getId());
                ConstantUtils.USER_ID = body.getId();
                if (connectorAIDL != null) {
                    try {
                        connectorAIDL.setKickOut(false);
                    } catch (RemoteException e) {
                        Logger.e("===Web===", "logoutIMServer -> " + e.getMessage());
                    }
                }
                Logger.e("===Web===", " getUserInfo -> " + ConstantUtils.USER_ID);
                ConstantUtils.isLogin = true;
                PreferencesUtils.setLoginState(true);
                LoginSuccessJump(url);
            }

            @Override
            protected void onFailure(int code, String msg) {
                if (code == 401) {
                    msg = "登录失败,请刷新重试!";
                } else if (code == 99) {
                    msg = "登录失败,请检查网络!";
                } else {
                    msg = "登录失败,请稍后重试!";
                }
                Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
            }
        });

    }

    /**
     * 页面跳转控制
     *
     * @param url
     */
    private void LoginSuccessJump(String url) {
        //从消息以及我的界面进入返回MainActivity
        intent.setClass(mContext, MainActivity.class);
        startActivity(intent);
        finish();
    }

    @OnClick(R.id.iv_back)
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_back:
                Utils.hideInput(webView);
                if (webView == null) {
                    return;
                }
                if (webView.canGoBack()) {
                    webViewGoBack();
                    return;
                } else {
                    ivBack.setVisibility(View.GONE);
                }
                break;

        }

    }

    @Override
    protected void onDestroy() {
        imServiceConnector.unbindService(this);
        super.onDestroy();
    }


    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webViewGoBack();
        } else {
            super.onBackPressed();
        }
    }

    private void webViewGoBack() {
        if (!webView.copyBackForwardList().getCurrentItem().getUrl().equals(webView.copyBackForwardList().getCurrentItem().getOriginalUrl())) {
            webView.goBack();
        }
        webView.goBack();
    }

    private void loginByWeChat() {
        WXapi.registerApp(ConstantUtils.WEIXIN_APPID);

        if (WXapi.isWXAppInstalled()) {
            //登陆
            SendAuth.Req req = new SendAuth.Req();
            req.scope = "snsapi_userinfo";
            req.state = ConstantUtils.WX_RESP_STATE;
            WXapi.sendReq(req);
            IntentFilter filter = new IntentFilter();
            filter.addAction(ConstantUtils.WX_LOG_ACTION);
            registerReceiver(wxLoginReciver, filter);
        } else {
            Toast.makeText(this, getResources().getString(R.string.share_weixin_toast), Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * 获取WXAccessToken
     *
     * @param intent
     */
    private void getWXAccessToken(Intent intent) {
        Map<String, Object> map = new IdentityHashMap<>();
        map.put("appid", ConstantUtils.WEIXIN_APPID);
        map.put("secret", ConstantUtils.WEIXIN_APPSECRET);
        map.put("code", intent.getStringExtra(IntentKeys.KEY_WX_LOGIN_CODE));
        map.put("grant_type", "authorization_code");
        Call<WxAccessToken> call = service.getWxActionToken(map);
        call.enqueue(new Callback<WxAccessToken>() {
            @Override
            public void onResponse(Call<WxAccessToken> call, Response<WxAccessToken> response) {
                if (response.code() == 200) {
                    getUserInfo(response.body());
                } else {
                    String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                    Toast.makeText(getBaseContext(), String.format(sInfoFormat, response.message(), response.code() + ""), Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onFailure(Call<WxAccessToken> call, Throwable t) {
                Toast.makeText(getBaseContext(), "网络异常,请检查网络", Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 获取用户信息
     *
     * @param wxAccessToken
     */
    private void getUserInfo(WxAccessToken wxAccessToken) {
        Map<String, Object> map = new IdentityHashMap<>();
        map.put("access_token", wxAccessToken.getAccess_token());
        map.put("openid", wxAccessToken.getOpenid());
        Call<WxUserInfo> call = service.getWxUserInfo(map);
        call.enqueue(new Callback<WxUserInfo>() {
            @Override
            public void onResponse(Call<WxUserInfo> call, Response<WxUserInfo> response) {
                if (response.code() == 200) {
                    webView.loadUrl("javascript:ChoudaoJSBridge.wechatLoginSuccess(" + JSON.toJSONString(response.body()) + ")");
                } else {
                    String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                    Toast.makeText(getBaseContext(), String.format(sInfoFormat, response.message(), response.code() + ""), Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onFailure(Call<WxUserInfo> call, Throwable t) {
                Toast.makeText(getBaseContext(), "网络异常,请检查网络", Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 自定义WebChromeClient
     */
    private class CustomChromeClient extends CDWebChromeClient {

        public CustomChromeClient(ProgressBar mProgressBar) {
            super(mProgressBar);
        }

        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
            setTitle(view);
        }

        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            super.onProgressChanged(view, newProgress);
            if (newProgress >= 80) {
                if (rlWebParent.getChildCount() > 1 && layout != null)
                    rlWebParent.removeView(layout);

                if (ConstantUtils.URL_ME.equals(view.getUrl())) {
                    ivBack.setVisibility(View.GONE);
                } else {
                    ivBack.setVisibility(View.VISIBLE);
                }
            }

        }
    }
}
