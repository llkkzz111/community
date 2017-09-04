package com.ocj.oms.mobile.ui.personal.wallet.integral;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.bean.SaveamtBean;
import com.ocj.oms.mobile.bean.SaveamtList;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindString;
import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

/**
 * 积分详情
 */
@Route(path = RouterModule.AROUTER_PATH_SCORE)
public class IntegralDetailsActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rv_refresh) RecyclerView rvRefresh;
    @BindView(R.id.ll_tips) LinearLayout llTips;
    @BindView(R.id.tv_tips) TextView tvTips;
    @BindView(R.id.tv_integral) TextView tvIntergral;
    @BindView(R.id.rl_content) RelativeLayout contentView;
    @BindView(R.id.inc_list) View mIncList;
    @BindString(R.string.text_intergral_tips) String intergral;

    @BindView(R.id.rg_select_pay) RadioGroup rdGroup;


    private int type = -1;
    private int page = 1;
    private List<SaveamtBean> saveamtBeanList = null;
    private IntergralDetailsAdapter adapter;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_integral_details_layout;
    }

    @Override
    protected void initEventAndData() {

        initReveiver();
        type = -1;
        page = 1;
        saveamtBeanList = new ArrayList<>();
        initPtr();
        rvRefresh.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new IntergralDetailsAdapter(mContext, saveamtBeanList);
        rvRefresh.addItemDecoration(new SpacesItemDecoration(mContext, LinearLayoutManager.VERTICAL, 1));
        rvRefresh.setAdapter(adapter);
        getLeftSaveamt();
        getIntergralList();
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C037);
    }

    /**
     * 初始化广播接收器
     */
    private void initReveiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(IntentKeys.REFRESH_SCORE);
        registerReceiver(scoreReceiver, filter);
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
                getIntergralList();
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
                getIntergralList();
            }

        });
    }

    private void getIntergralList() {
        showLoading();
        new WalletMode(mContext).getSaveamtsDetails(page, type, new ApiResultObserver<SaveamtList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                showErrorView(e.getMessage());
                mPtrFrame.refreshComplete();
                hideLoading();
            }

            @Override
            public void onSuccess(SaveamtList result) {
                hideLoading();
                mPtrFrame.refreshComplete();
                if (page == 1) {
                    saveamtBeanList.clear();
                }
                if (type == -1 && result.getAmtList() != null && result.getAmtList().size() == 0) {
                    //全部没有数据
                    showTotalEmptyView();
                    return;
                } else {
                    rdGroup.setVisibility(View.VISIBLE);
                }
                if (result != null)
                    saveamtBeanList.addAll(result.getAmtList());
                adapter.notifyDataSetChanged();

                if (page >= result.getMaxPage()) {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                } else {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
                }
                if (saveamtBeanList.size() == 0) {
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

    private void showTotalEmptyView() {
        rdGroup.setVisibility(View.GONE);
        showEmptyView();
    }


    private void showEmptyView() {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showEmptyView(R.drawable.icon_empty, "您还没有记录哦~", "我还要孤单多久", false, "");
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void showErrorView(String msg) {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showErrorView(R.drawable.ylc_nonet, msg, "", true, "刷新试试", this);
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }


    @OnCheckedChanged({R.id.btn_all, R.id.btn_usage, R.id.btn_expiring, R.id.btn_obtain})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.btn_all:
                    type = -1;
                    break;
                case R.id.btn_usage:
                    type = 1;
                    break;
                case R.id.btn_expiring:
                    type = 3;
                    break;

                case R.id.btn_obtain:
                    type = 0;
                    break;
            }
            page = 1;
            getIntergralList();
        }
    }


    private void getLeftSaveamt() {
        new WalletMode(mContext).getSaveamtsLeftSaveamt(new ApiResultObserver<Num>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(Num apiResult) {
                tvIntergral.setText(apiResult.getNum());

                float num = 0;
                try {
                    num = Float.valueOf(apiResult.getNum());
                } catch (NumberFormatException e) {
                    ToastUtils.showLongToast("数据格式不对");
                    e.printStackTrace();
                }

                llTips.setVisibility(View.GONE);
            }

            @Override
            public void onComplete() {
            }
        });
    }


    @OnClick({R.id.tv_go_vocher_exchange, R.id.btn_close, R.id.iv_close_tips, R.id.tv_help})
    public void onMoreClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                finish();
                break;
            case R.id.tv_go_vocher_exchange:
                startActivity(new Intent(mContext, IntegralExchangeActivity.class));
                break;
            case R.id.iv_close_tips:
                llTips.setVisibility(View.GONE);
                break;
            case R.id.tv_help:
                ToastUtils.showShortToast("如何获取积分");
                break;
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        this.unregisterReceiver(scoreReceiver);
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C037);
    }

    BroadcastReceiver scoreReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(IntentKeys.REFRESH_SCORE)) {
                getLeftSaveamt();
                refreshList();
            }

        }
    };

    /**
     * 通知刷新相关列表
     */
    private void refreshList() {
        type = -1;
        page = 1;
        getIntergralList();
    }


    @Override
    public void onClick(View view) {
        getIntergralList();
    }
}
