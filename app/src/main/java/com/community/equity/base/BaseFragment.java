package com.community.equity.base;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.community.equity.api.ServiceGenerator;
import com.community.equity.api.service.ApiService;
import com.community.equity.utils.UIManager;
import com.community.equity.view.ViewController;

import butterknife.Unbinder;

/**
 * Created by Han on 2016/3/7.
 */
public class BaseFragment extends Fragment implements ViewController {
    public Unbinder unbinder;
    protected View[] mSubContentView;
    private View mParentView;
    public ApiService service = null;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        service = ServiceGenerator.createService(ApiService.class);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (unbinder != null) {
            unbinder.unbind();
        }
    }

    @Override
    public View showErrorView(String msg) {
        hideContentView();
        hideLoadView();
        hideErrorView();
        hideEmptyView();
        return UIManager.getInstance().showErrorView(mParentView, msg);
    }

    @Override
    public void showLoadView() {
        hideContentView();
        hideErrorView();
        hideEmptyView();
        UIManager.getInstance().showLoadView(mParentView);
    }

    @Override
    public View showEmptyView(String msg) {
        hideContentView();
        hideLoadView();
        hideErrorView();
        return UIManager.getInstance().showEmptyView(mParentView, msg);
    }

    @Override
    public void showContentView() {
        hideLoadView();
        hideErrorView();
        hideEmptyView();
        if (mSubContentView != null && mSubContentView.length > 0) {
            for (int i = 0; i < mSubContentView.length; i++) {
                View view = mSubContentView[i];
                if (view != null) {
                    view.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    private void hideContentView() {
        if (mSubContentView != null && mSubContentView.length > 0) {
            for (int i = 0; i < mSubContentView.length; i++) {
                View view = mSubContentView[i];
                if (view != null) {
                    view.setVisibility(View.GONE);
                }
            }
        }
    }

    private void hideLoadView() {
        UIManager.getInstance().hideLoadView(mParentView);
    }

    private void hideErrorView() {
        UIManager.getInstance().hideErrorView(mParentView);
    }


    private void hideEmptyView() {
        UIManager.getInstance().hideEmptyView(mParentView);
    }

    public View getParentView() {
        return mParentView;
    }

    public void setParentView(View parentView) {
        this.mParentView = parentView;
    }

    public void setSubContentView(View... subContentView) {
        this.mSubContentView = subContentView;
    }

}
