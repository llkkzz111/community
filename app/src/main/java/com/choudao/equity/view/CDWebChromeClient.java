package com.choudao.equity.view;

import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.ProgressBar;

/**
 * Created by liuzhao on 16/4/5.
 */
public class CDWebChromeClient extends WebChromeClient {

    private ProgressBar mProgressBar;


    public CDWebChromeClient(ProgressBar mProgressBar) {
        this.mProgressBar = mProgressBar;
    }


    @Override
    public void onProgressChanged(WebView view, int newProgress) {
        super.onProgressChanged(view, newProgress);
        mProgressBar.setProgress(newProgress);
        if (newProgress == 100) {
            mProgressBar.setVisibility(View.GONE);
        } else {
            mProgressBar.setVisibility(View.VISIBLE);
        }
    }
}
