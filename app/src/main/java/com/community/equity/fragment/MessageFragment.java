package com.community.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.ProgressBar;

import com.community.equity.R;
import com.community.equity.WebViewActivity;
import com.community.equity.base.BaseFragment;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.CDWebChromeClient;
import com.community.equity.view.CDWebView;
import com.community.equity.view.CDWebViewClient;
import com.community.equity.view.TopView;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

import static com.community.imsdk.utils.ApiUtils.TRADING_CENTER;

/**
 * Created by Han on 2016/3/9.
 */
public class MessageFragment extends BaseFragment {
    private CDWebView webMessage;
    private ProgressBar mProgressBar;
    private PtrClassicFrameLayout mPtrFrame;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_meessage_layout, null);
        initView(view);
        initWebViewClient();
        initPtr();
        updateData();
        return view;
    }

    /**
     * 初始化view
     *
     * @param view
     */
    private void initView(View view) {
        webMessage = (CDWebView) view.findViewById(R.id.webview);
        mProgressBar = (ProgressBar) view.findViewById(R.id.progress_bar);
        mPtrFrame = (PtrClassicFrameLayout) view.findViewById(R.id.rotate_header_web_view_frame);
    }

    /**
     * 初始化webview相关
     */
    private void initWebViewClient() {
        webMessage.setWebChromeClient(new CDWebChromeClient(mProgressBar));
        webMessage.setWebViewClient(new CDWebViewClient(getActivity()) {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                startNewActivity(url);
                return true;

            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                mPtrFrame.refreshComplete();
            }
        });

    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, webMessage, header);
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
        webMessage.loadUrl(ConstantUtils.URL_HOME + TRADING_CENTER);
    }

    /**
     * 打开新的Activity
     *
     * @param url WebViewClient 拦截到的URL
     */
    private void startNewActivity(String url) {
        Intent intent = new Intent(getActivity(), WebViewActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        startActivity(intent);
    }


}
