package com.choudao.equity.fragment;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.choudao.equity.R;
import com.choudao.equity.base.BaseFragment;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.view.CDWebChromeClient;
import com.choudao.equity.view.CDWebView;
import com.choudao.equity.view.CDWebViewClient;
import com.choudao.equity.view.TopView;

import butterknife.BindView;
import butterknife.ButterKnife;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by Han on 2016/3/9.
 */
public class HomeFragment extends BaseFragment {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.webview) CDWebView webHome;
    @BindView(R.id.rl_webview_parent) RelativeLayout rlWebParent;
    @BindView(R.id.rotate_header_web_view_frame) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.progress_bar) ProgressBar mProgressBar;

    private View layout = null;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_home_layout, null);
        ButterKnife.bind(this, view);
        initView();
        initPtr();
        initWebViewClient();
        updateData();
        return view;
    }

    /**
     * 初始化view
     */
    private void initView() {
        topView.setTitle(getString(R.string.text_tab_home));
        topView.setRightImage();
        layout = LayoutInflater.from(getContext()).inflate(R.layout.webview_loading_layout, null);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(layoutParams);
        LinearLayout llLoadingMain = (LinearLayout) layout.findViewById(R.id.ll_loading_main);
        llLoadingMain.removeAllViews();
        llLoadingMain.setBackgroundResource(R.drawable.img_loading_home);
        rlWebParent.addView(layout);
    }

    /**
     * 初始化WebView
     */
    private void initWebViewClient() {
        webHome.setWebChromeClient(new CDWebChromeClient(mProgressBar));
        webHome.setWebViewClient(new CDWebViewClient(getActivity()) {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Intent intent = new Intent();
                Uri uri = Uri.parse(url);
                intent.setAction("com.choudao.equity.action");
                intent.setData(uri);
                startActivity(intent);
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                mPtrFrame.refreshComplete();
                if (rlWebParent.getChildCount() > 1 && layout != null)
                    rlWebParent.removeView(layout);
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
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, webHome, header);
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
        webHome.loadUrl(ConstantUtils.URL_HOME);
    }

}
