package com.ocj.oms.mobile.ui.personal.wallet.opoint;

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
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiHost;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.bean.OcouponsBean;
import com.ocj.oms.mobile.bean.OcouponsList;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.sign.SignActivity;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_WEBVIEW;

/**
 * Created by yy on 2017/5/13.
 * <p>
 * 鸥点详情
 */
@Route(path = RouterModule.AROUTER_PATH_EUROPE)
public class OcouponsDetailActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.tv_spent)
    TextView tvSpent;
    @BindView(R.id.tv_earn)
    TextView tvEarn;
    @BindView(R.id.tv_opoint)
    TextView tvOpoint;
    @BindView(R.id.ptr_view)
    PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rv_refresh)
    RecyclerView rvRefresh;
    @BindView(R.id.rg_select_pay)
    RadioGroup mRadioGroup;
    @BindView(R.id.inc_list)
    View mIncList;
    @BindView(R.id.rl_content)
    RelativeLayout contentView;
    private int month = 1;
    private int page;
    OpointDetailsAdapter adapter;
    private List<OcouponsBean> opointList;
    private View empty;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_ocoupon_details_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C042);
        page = 1;
        opointList = new ArrayList<>();
        rvRefresh.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new OpointDetailsAdapter(mContext, opointList);
        rvRefresh.setAdapter(adapter);
        initPtr();
        getOpointsNum();
        getOpointsDetails();

    }


    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {

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
                getOpointsDetails();
            }

        });
    }

    private void getOpointsDetails() {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MONTH, month + "");
        params.put(ParamKeys.CURR_PAGE_NO, page + "");

        new WalletMode(mContext).getOpointsDetails(params, new ApiResultObserver<OcouponsList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                showErrorView(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onSuccess(OcouponsList apiResult) {
                if (page == 1) {
                    opointList.clear();
                }
                if (apiResult != null)
                    opointList.addAll(apiResult.getOpointList());


                adapter.notifyDataSetChanged();
                mPtrFrame.refreshComplete();
                if (page >= apiResult.getTotalPage()) {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                } else {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
                }
                if (opointList.size() == 0) {
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

    @Override
    protected void onResume() {
        super.onResume();
        getOpointsNum();
        getOpointsDetails();
    }

    private void showEmptyView() {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        if (month == 1) {
            mRadioGroup.setVisibility(View.GONE);
            empty = instance.showEmptyView(R.drawable.icon_empty, "海鸥～海鸥～我们滴朋友", "然而你还没有鸥点", false, "");
        } else {
            mRadioGroup.setVisibility(View.VISIBLE);
            empty = instance.showEmptyView(R.drawable.icon_empty, "你还没有记录哦", "我还要孤单多久", false, "");
        }
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void showErrorView(String msg) {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showErrorView(R.drawable.ylc_nonet, msg, "", true, "刷新试试", this);
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void getOpointsNum() {

        new WalletMode(mContext).getOpointsLeftSaveamt(new ApiResultObserver<Num>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(Num apiResult) {
                tvOpoint.setText(apiResult.getNum());
            }

            @Override
            public void onComplete() {
            }
        });
    }

    @OnClick({R.id.btn_close, R.id.tv_earn, R.id.tv_spent})
    public void onSameClick(View view) {
        Intent intent = getIntent();
        switch (view.getId()) {
            case R.id.btn_close:
                finish();
                break;
            case R.id.tv_earn:
                intent.setClass(mContext, SignActivity.class);
                startActivity(intent);
                break;
            case R.id.tv_spent:
                ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                        .withString("from", "RNActivity")
                        .withString("url", ApiHost.H5_HOST + "/oclub/product")
                        .navigation();
                break;
        }

    }

    @OnCheckedChanged({R.id.btn_all, R.id.btn_usage, R.id.btn_obtain, R.id.btn_expiring})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.btn_obtain:
                    month = 2;
                    break;
                case R.id.btn_all:
                    month = 1;
                    break;
                case R.id.btn_usage:
                    month = 3;
                    break;
                case R.id.btn_expiring:
                    month = 4;
                    break;
            }
            page = 1;
            getOpointsDetails();

        }
    }

    @Override
    public void onClick(View view) {
        getOpointsDetails();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C042);
    }
}
