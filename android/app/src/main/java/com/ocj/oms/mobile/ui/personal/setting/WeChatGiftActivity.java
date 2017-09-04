package com.ocj.oms.mobile.ui.personal.setting;

import android.content.Intent;
import android.view.KeyEvent;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/15.
 */

public class WeChatGiftActivity extends BaseActivity {

    @BindView(R.id.webview) WebView webview;
    String myurl = "http://m.ocj.com.cn/image_site/event/2014/10/ocjfw_rule/index.html";//彭斌给的链接

    @Override
    protected int getLayoutId() {
        return R.layout.activity_wechat_gift_layout;
    }

    @Override
    protected void initEventAndData() {

        webview.getSettings().setJavaScriptEnabled(true);
// 加载需要显示的网页
        webview.loadUrl(myurl);
// 设置Web视图
        webview.setWebViewClient(new MyWebViewClient());
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && webview.canGoBack()) {
            webview.goBack();
            finish();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }


    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (url != null && myurl.contains(url)) {
                Intent intent = new Intent(mContext, SettingActivity.class);
                mContext.startActivity(intent);
                finish();
                return true;
            }
            return super.shouldOverrideUrlLoading(view, url);
        }
    }


}
