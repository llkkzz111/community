package com.ocj.oms.mobile.ui.personal.wallet.imprest;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.DepositBean;
import com.ocj.oms.mobile.bean.DepositList;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

/**
 * 预付款详情
 */
@Route(path = RouterModule.AROUTER_PATH_PRE_BARGAIN)
public class ImprestDetailsActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rv_refresh) RecyclerView rvRefresh;
    @BindView(R.id.tv_imprest_count) TextView tvCount;
    @BindView(R.id.rl_content) RelativeLayout contentView;

    @BindView(R.id.tab_imprest) RadioGroup radioGroup;

    @BindView(R.id.inc_list) View mIncList;
    private String type = "";
    private int page = 1;
    private List<DepositBean> depositBeanList;
    private ImprestDetailsAdapter adapter;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_imprest_details_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C039);
        type = "";
        page = 1;
        depositBeanList = new ArrayList<>();
        initPtr();

        getImprestList();
        getLeftDeposit();
        rvRefresh.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new ImprestDetailsAdapter(mContext, depositBeanList);
        rvRefresh.setAdapter(adapter);
    }


    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                page++;
                getImprestList();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, rvRefresh, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, rvRefresh, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                page = 1;
                getImprestList();
            }

        });
    }


    @OnCheckedChanged({R.id.btn_all, R.id.btn_usage, R.id.btn_obtain})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.btn_obtain:
                    type = "1";
                    break;
                case R.id.btn_all:
                    type = "";
                    break;
                case R.id.btn_usage:
                    type = "2";
                    break;
            }
            page = 1;
            getImprestList();
        }
    }

    /**
     * 获取预付款详情
     */
    private void getImprestList() {
        new WalletMode(mContext).getDepositsDetails(page, type, new ApiResultObserver<DepositList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                showErrorView(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onSuccess(DepositList result) {
                if (page == 1) {
                    depositBeanList.clear();
                }
                if (result != null)
                    depositBeanList.addAll(result.getMyPrepayList());
                adapter.notifyDataSetChanged();
                mPtrFrame.refreshComplete();
                if (page >= result.getMaxPage()) {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                } else {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
                }
                if (depositBeanList.size() == 0) {
                    showEmptyView();
                } else {
                    mIncList.setVisibility(View.VISIBLE);
                    contentView.removeAllViews();
                }

            }

            @Override
            public void onComplete() {
            }
        });
    }

    private void showEmptyView() {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        if (type.equals("")) {
            radioGroup.setVisibility(View.GONE);
        } else {
            radioGroup.setVisibility(View.VISIBLE);
        }
        View empty = instance.showEmptyView(R.drawable.icon_empty, "怎么可以没有预付款", "没钱也任性", false, "");
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void showErrorView(String msg) {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showErrorView(R.drawable.ylc_nonet, msg, "", true, "刷新试试", this);
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    /**
     * 获取预付款余额
     */
    private void getLeftDeposit() {
        new WalletMode(mContext).getLeftDeposit(new ApiResultObserver<Num>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onSuccess(Num result) {
                tvCount.setText(result.getNum());
            }

            @Override
            public void onComplete() {
            }
        });
    }


    @OnClick({R.id.btn_close})
    void onMoreClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                finish();
                break;
            case R.id.tv_help:
                ToastUtils.showShortToast("什么是预付款详情");
                break;
        }
    }

    @Override
    public void onClick(View view) {
        getImprestList();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C039);
    }
}

