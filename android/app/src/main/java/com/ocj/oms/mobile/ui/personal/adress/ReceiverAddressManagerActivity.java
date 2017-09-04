package com.ocj.oms.mobile.ui.personal.adress;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.ReceiverListBean;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.address.AddressModel;
import com.ocj.oms.mobile.ui.adapter.AddressManagerAdapter;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

import static com.ocj.oms.mobile.ui.adapter.AddressManagerAdapter.CHENGE;
import static com.ocj.oms.mobile.ui.adapter.AddressManagerAdapter.DELETE;

/**
 * Created by yy on 2017/5/18.
 * <p>
 * 收货地址管理
 */

public class ReceiverAddressManagerActivity extends BaseActivity implements AddressManagerAdapter.OnItemClickListener {

    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.recycleview) RecyclerView adressRecycleView;
    @BindView(R.id.rl_content) RelativeLayout contentView;
    //@BindView(R.id.rl_cotent) RelativeLayout ryEmpty;
    View empty;


    @BindColor(R.color.grey) int lineColor;
    private AddressManagerAdapter adapter;
    private List<ReceiversBean> datas = new ArrayList<>();

    ReceiversBean defaultBean = null;
    int page = 1;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_address_manager_layout;
    }


    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C062);
        initView();
        initReceiver();
        showLoading();
        getReceiverList();
    }


    private void initView() {
        adressRecycleView.setLayoutManager(new LinearLayoutManager(mContext));
        adressRecycleView.addItemDecoration(new SpacesItemDecoration(mContext, LinearLayoutManager.HORIZONTAL, DensityUtil.dip2px(mContext, 10), lineColor));
        adapter = new AddressManagerAdapter(mContext, this);
        adapter.setDatas(datas);
        adressRecycleView.setAdapter(adapter);
        initPtr();
    }


    private void getReceiverList() {
        new AddressModel(mContext).getReceiverList(new ApiResultObserver<ReceiverListBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onSuccess(ReceiverListBean apiResult) {
                hideLoading();
                if (apiResult.getReceivers() == null || apiResult.getReceivers().size() == 0) {
                    showEmptyView();
                } else {
                    //ryEmpty.setVisibility(View.GONE);
                    contentView.removeView(empty);
                    adressRecycleView.setVisibility(View.VISIBLE);
                    datas.clear();
                    datas.addAll(apiResult.getReceivers());
                    adapter.notifyDataSetChanged();
                }
                mPtrFrame.refreshComplete();

            }
        });
    }

    private void showEmptyView() {
        adressRecycleView.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        empty = instance.showEmptyView(R.drawable.empty_other, "暂无地址信息", "", true, "添加");
        instance.setBtnListner(new ViewUtil.OnBtnClickListner() {
            @Override
            public void onBtnClick(View view) {
                Intent intent = new Intent(mContext, AddressEditActivity.class);
                intent.putExtra(IntentKeys.ADDRESS_ADD, "");
                startActivity(intent);
            }
        });
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

    }


    @OnClick({R.id.btn_back, R.id.tv_address_add})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_back:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C062C005001C003001);
                finish();
                break;
            case R.id.tv_address_add:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C062C005001A001001);
                Intent intent = new Intent(mContext, AddressEditActivity.class);
                intent.putExtra(IntentKeys.ADDRESS_ADD, "");
                startActivity(intent);
                break;
        }

    }

    @Override
    public void onItemClick(ReceiversBean bean, int type, boolean checked) {
        final Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.ADDRESS_ID, bean.getReceivermanage_seq());
        switch (type) {
            case DELETE:
                DialogFactory.showNoIconDialog("确定要删除该地址吗？", "取消", "确认", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        showLoading();
                        new AddressModel(mContext).deleteReceiver(params, new ApiResultObserver<Result<String>>(mContext) {
                            @Override
                            public void onError(ApiException e) {
                                hideLoading();
                                ToastUtils.showShortToast(e.getMessage());
                            }

                            @Override
                            public void onSuccess(Result<String> apiResult) {
                                hideLoading();
                                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C062F012001O006002);
                                ToastUtils.showShortToast("删除成功");
                                getReceiverList();
                            }

                        });
                    }
                }).show(getFragmentManager(), "delete");
                break;
            case CHENGE:
                showLoading();
                new AddressModel(mContext).defaultReceiver(params, new ApiResultObserver<Result<String>>(mContext) {
                    @Override
                    public void onError(ApiException e) {
                        hideLoading();
                        ToastUtils.showShortToast(e.getMessage());
                    }

                    @Override
                    public void onSuccess(Result<String> apiResult) {
                        getReceiverList();

                    }
                });
                break;
        }

    }


    private void initReceiver() {
        IntentFilter recIntent = new IntentFilter();
        recIntent.addAction(IntentKeys.Fresh_ADESS);
        registerReceiver(defaultReceiver, recIntent);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        this.unregisterReceiver(defaultReceiver);
    }

    BroadcastReceiver defaultReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            getReceiverList();
        }
    };


    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);//暂时只支持刷新
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                page++;
                getReceiverList();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, adressRecycleView, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, adressRecycleView, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                page = 1;
                getReceiverList();
            }

        });
    }


}
