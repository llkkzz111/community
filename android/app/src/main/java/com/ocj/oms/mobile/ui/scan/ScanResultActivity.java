package com.ocj.oms.mobile.ui.scan;

import android.content.Intent;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.BindView;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/13 14:39
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class ScanResultActivity extends BaseActivity {
    @BindView(R.id.scan_webview)
    WebView scanWebview;
    private String reasult;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_scanresult_layout;
    }

    @Override
    protected void initEventAndData() {
        Intent intent = getIntent();
        reasult = intent.getStringExtra("result");
        scanWebview.loadUrl(reasult);
        scanWebview.setWebViewClient(new WebViewClient(){
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // TODO Auto-generated method stub
                //返回值是true的时候控制去WebView打开，为false调用系统浏览器或第三方浏览器
                view.loadUrl(url);
                return true;
            }
        });
    }

}
