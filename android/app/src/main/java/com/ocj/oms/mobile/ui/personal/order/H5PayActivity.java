package com.ocj.oms.mobile.ui.personal.order;


import android.content.Intent;
import android.net.Uri;
import android.net.http.SslError;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;

import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.utils.FileUtils;

import butterknife.BindString;
import butterknife.BindView;
import butterknife.OnClick;

import static com.ocj.oms.utils.FileUtils.CACHE_PATH;

public class H5PayActivity extends BaseActivity {

    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.webview) WebView webview;
    @BindString(R.string.h5_pay_text) String h5PayText;
    private String url;
    private String payReturnUrl;
    private String title;
    private final static String FILE_NAME = CACHE_PATH + "/index.html";

    @Override
    protected int getLayoutId() {
        return R.layout.activity_h5_pay_layout;
    }

    @Override
    protected void initEventAndData() {
        url = getIntent().getStringExtra(IntentKeys.PAY_URL);
        title = getIntent().getStringExtra(IntentKeys.PAY_TITLE);
        tvTitle.setText(title);
        if (!url.startsWith("http")) {
            payReturnUrl = getIntent().getStringExtra(IntentKeys.PAY_RETURN_URL);
            FileUtils.writeFile(FILE_NAME, String.format(h5PayText, url), false);
            webview.loadUrl("file:///" + FILE_NAME);
        } else {
            webview.loadUrl(url);
            Uri uri = Uri.parse(url);
            payReturnUrl = uri.getQueryParameter("return_url");
        }
        webview.getSettings().setJavaScriptEnabled(true);

        webview.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                handler.proceed();  // 接受所有网站的证书
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (payReturnUrl.equals(url) || url.startsWith(payReturnUrl)) {
                    Intent intent = new Intent();
                    intent.setAction("com.ocj.oms.pay");
                    sendBroadcast(intent);
                    finish();
                }
            }

            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (payReturnUrl.equals(url) || url.startsWith(payReturnUrl)) {
                    Intent intent = new Intent();
                    intent.setAction("com.ocj.oms.pay");
                    sendBroadcast(intent);
                    finish();
                    return true;
                }
                return false;
            }
        });
    }

    @OnClick({R.id.btn_close})
    void onClick() {

        finish();
    }

    @Override
    public void onBackPressed() {
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        FileUtils.deleteFile(FILE_NAME);
    }
}
