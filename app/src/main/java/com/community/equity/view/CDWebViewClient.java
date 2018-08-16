package com.community.equity.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * Created by liuzhao on 16/4/5.
 */
public class CDWebViewClient extends WebViewClient {
    public Context mContext;
    private boolean isShowError = false;

    public CDWebViewClient(Context mContext) {
        this.mContext = mContext;
    }


    @Override
    public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
        ((CDWebView) view).showErrorPage(null);
        isShowError = true;
    }

    @Override
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
        ((CDWebView) view).showErrorPage(null);
        isShowError = true;
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);
        isShowError = false;
    }


    @Override
    public void onPageFinished(WebView view, String url) {

        super.onPageFinished(view, url);
        if (!isShowError && (view.getProgress() == 100)) {
            ((CDWebView) view).hideErrorPage();
        }
    }
}
