package com.ocj.oms.mobile.ui.personal.wallet.packs;

import android.content.Intent;
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
import com.ocj.oms.mobile.bean.GiftCardBean;
import com.ocj.oms.mobile.bean.GiftCardList;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
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
 * Created by yy on 2017/5/13.
 * <p>
 * 礼包详情
 */
@Route(path = RouterModule.AROUTER_PATH_REWARD)
public class GiftcardsDetailActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.rv_refresh) RecyclerView rvRefresh;
    @BindView(R.id.tv_balance) TextView tvBalance;
    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rg_select_pay) RadioGroup mRadioGroup;
    @BindView(R.id.inc_nodata) View mIncNodata;
    @BindView(R.id.inc_list) View mIncList;
    @BindView(R.id.rl_content) RelativeLayout contentView;
    List<GiftCardBean> datas = new ArrayList<>();
    GiftCardAdapter adapter;
    private String type = "";
    private int page = 1;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_package_details_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C043);
        initView();
        initPtr();
        type = "";
        page = 1;
        rvRefresh.setAdapter(adapter);

    }

    @Override
    protected void onResume() {
        super.onResume();
        getBalance();
        queryGiftcardList();
    }

    private void initView() {
        rvRefresh.setLayoutManager(new LinearLayoutManager(mContext));
        rvRefresh.addItemDecoration(new SpacesItemDecoration(mContext, LinearLayoutManager.HORIZONTAL));
        adapter = new GiftCardAdapter(mContext, datas);
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
                queryGiftcardList();
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
                queryGiftcardList();
            }

        });
    }

    @OnCheckedChanged({R.id.rb_total_report, R.id.rb_use_report, R.id.rb_get_report})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.rb_get_report:
                    type = "1";
                    break;
                case R.id.rb_total_report:
                    type = "";
                    break;
                case R.id.rb_use_report:
                    type = "2";
                    break;
            }
            page = 1;
            queryGiftcardList();
        }
    }

    @OnClick({R.id.btn_packege_recharge})
    public void onButtonClick(View view) {
        switch (view.getId()) {
            case R.id.btn_packege_recharge:
                startActivity(new Intent(mContext, PacksRechargeActivity.class));
                break;

        }
    }


    private void getBalance() {

        new WalletMode(mContext).querryBalance(new ApiResultObserver<Num>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(Num apiResult) {
                tvBalance.setText(apiResult.getNum());
            }

            @Override
            public void onComplete() {

            }
        });
    }

    private void queryGiftcardList() {
        new WalletMode(mContext).getGiftCardDetail(type, page, new ApiResultObserver<GiftCardList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                showErrorView(e.getMessage());
            }

            @Override
            public void onSuccess(GiftCardList apiResult) {
                if (page == 1) {
                    datas.clear();
                }
                if (apiResult != null && apiResult != null)
                    datas.addAll(apiResult.getMyEGiftCardList());
                adapter.notifyDataSetChanged();
                mPtrFrame.refreshComplete();
                //无数据处理
                if (datas.size() == 0) {
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
//        mRadioGroup.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showEmptyView(R.drawable.ylc_libao, "是时候去抱个大礼包啦!", "别怪我没提醒你哦～", false, "");
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void showErrorView(String msg) {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showErrorView(R.drawable.ylc_nonet, msg, "", true, "刷新试试", this);
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }


    @OnClick({R.id.btn_close})
    public void onCloseClick(View view) {
        finish();
    }

    @Override
    public void onClick(View view) {//点击刷新回调
        queryGiftcardList();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C043);
    }
}
