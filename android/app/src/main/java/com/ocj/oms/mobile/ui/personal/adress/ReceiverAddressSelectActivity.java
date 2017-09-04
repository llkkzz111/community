package com.ocj.oms.mobile.ui.personal.adress;

import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.BaseEventBean;
import com.ocj.oms.mobile.bean.ReceiverListBean;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.http.service.address.AddressModel;
import com.ocj.oms.mobile.ui.adapter.AddressSelectAdapter;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.ui.rn.RNActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.DensityUtil;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;


/**
 * Created by yy on 2017/5/18.
 * <p>
 * 收货地址管理
 */
@Route(path = RouterModule.AROUTER_PATH_SELECT_ADDRESS)
public class ReceiverAddressSelectActivity extends BaseActivity implements AddressSelectAdapter.OnItemClickListener {

    @BindView(R.id.ll_content) LinearLayout contentView;
    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.recycleview) RecyclerView adressRecycleView;
    @BindColor(R.color.grey) int lineColor;
    private AddressSelectAdapter adapter;
    private List<ReceiversBean> datas = new ArrayList<>();
    public static final String FROM_RESERVE = "FROM_RESERVE";

    ReceiversBean unSave;

    View empty;


    int page = 1;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_address_select_layout;
    }


    @Override
    protected void initEventAndData() {
        initView();
        initPtr();

    }

    private void initView() {
        adressRecycleView.setLayoutManager(new LinearLayoutManager(mContext));
        adressRecycleView.addItemDecoration(new SpacesItemDecoration(mContext, LinearLayoutManager.HORIZONTAL, DensityUtil.dip2px(mContext, 10), lineColor));

        adapter = new AddressSelectAdapter(mContext, this);
        adapter.setDatas(datas);
        adressRecycleView.setAdapter(adapter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        showLoading();
        getReceiverList();
    }

    private void getReceiverList() {
        new AddressModel(mContext).getReceiverList(new ApiResultObserver<ReceiverListBean>(mContext) {

            @Override
            public void onError(ApiException e) {
                mPtrFrame.refreshComplete();
                hideLoading();
                ToastUtils.showShortToast(e.getMessage());
                showErrorView();
            }

            @Override
            public void onSuccess(ReceiverListBean apiResult) {
                hideLoading();
                if (apiResult.getReceivers() == null || apiResult.getReceivers().size() == 0) {
                    showEmptyView();
                } else {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                    contentView.removeView(empty);
                    adressRecycleView.setVisibility(View.VISIBLE);
                    datas.clear();
                    getDefautAdress(apiResult.getReceivers());
                    datas.addAll(apiResult.getReceivers());
                    adapter.notifyDataSetChanged();
                }
                mPtrFrame.refreshComplete();
//                if (page >= /*服务器返回的最大数量*/100) {
//                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
//                } else {
//                    mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
//                }
            }
        });
    }

    /**
     * 查询到默认地址
     *
     * @param receivers
     */
    private void getDefautAdress(List<ReceiversBean> receivers) {
        for (ReceiversBean bean : receivers) {
            if (bean.getDefault_yn().equals("1")) {
                unSave = bean;
                return;
            }
        }
    }


    @OnClick({R.id.btn_back, R.id.tv_address_manager})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_back:
                sendAdressRN();
                break;
            case R.id.tv_address_manager:
                Intent intent = new Intent(mContext, ReceiverAddressManagerActivity.class);
                startActivity(intent);
                break;
        }

    }

    @Override
    public void onItemClick(ReceiversBean bean) {
        if (TextUtils.equals(getIntent().getStringExtra(IntentKeys.FROM), FROM_RESERVE)) {
            EventBus.getDefault().post(new BaseEventBean(IntentKeys.ADDRESS, bean));
            finish();
            return;
        }
        RouterModule.invokeAddressCallback(
                bean.getReceiver_seq(),
                bean.getCust_no(),
                bean.getReceiver_name(),
                bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3(),
                bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3(),
                bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3(),
                bean.getDefault_yn(),
                bean.getAddr_m(),
                bean.getReceiver_addr(),
                bean.getReceiver_seq(),
                bean.getArea_lgroup(),
                bean.getArea_mgroup(),
                bean.getArea_sgroup()
        );
        ActivityStack.getInstance().finishToActivity(RNActivity.class);
    }


    private void sendAdressRN() {
        if (unSave != null) {
            RouterModule.invokeAddressCallback(
                    unSave.getReceiver_seq(),
                    unSave.getCust_no(),
                    unSave.getReceiver_name(),
                    unSave.getReceiver_hp1() + unSave.getReceiver_hp2() + unSave.getReceiver_hp3(),
                    unSave.getReceiver_hp1() + unSave.getReceiver_hp2() + unSave.getReceiver_hp3(),
                    unSave.getReceiver_hp1() + unSave.getReceiver_hp2() + unSave.getReceiver_hp3(),
                    unSave.getDefault_yn(),
                    unSave.getAddr_m(),
                    unSave.getReceiver_addr(),
                    unSave.getReceiver_seq(),
                    unSave.getArea_lgroup(),
                    unSave.getArea_mgroup(),
                    unSave.getArea_sgroup()
            );
            ActivityStack.getInstance().finishToActivity(RNActivity.class);
        } else {
            finish();
        }
    }

    @Override
    public void onBackPressed() {
        if (TextUtils.equals(getIntent().getStringExtra(IntentKeys.FROM), FROM_RESERVE)) {
            finish();
        } else {
            sendAdressRN();
        }
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
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


    private void showEmptyView() {
        mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
        adressRecycleView.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        empty = instance.showEmptyView(R.drawable.empty_other, "暂无地址信息", "", false, "");
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }


    private void showErrorView() {
        adressRecycleView.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        empty = instance.showEmptyView(R.drawable.empty_other, "暂无地址信息", "", true, "刷新试试");
        instance.setBtnListner(new ViewUtil.OnBtnClickListner() {
            @Override
            public void onBtnClick(View view) {
                getReceiverList();
            }
        });
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }


}
