package com.ocj.oms.mobile.ui.fragment;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.ElectronBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.ResultStr;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.ui.fragment.adapter.WalletElertronAdapter;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.view.ClearEditText;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;


public class WalletRechargeFragment extends BaseFragment {

    @BindView(R.id.et_gift_no) ClearEditText etNo;//卡号

    @BindView(R.id.et_gift_pwd) ClearEditText etPwd;//密码
    @BindView(R.id.btn_recharge_confirm) Button btnConfirm;

    @BindView(R.id.ll_slide) LinearLayout verifyLayout;
    @BindView(R.id.slide) SlideLockView slideLockView;


    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;
    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rv_refresh) RecyclerView rvRefresh;
    int repeatTime = 1;//账号输入重复次数
    private List<ElectronBean> electronBeanList = null;
    boolean isVerfy = false;
    private WalletElertronAdapter adapter;

    public static WalletRechargeFragment newInstance(String param1, String param2) {
        WalletRechargeFragment fragment = new WalletRechargeFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    protected int getlayoutId() {
        return R.layout.fragment_wallet_recharge_layout;
    }

    @Override
    protected void lazyLoadData() {

    }

    @Override
    protected void initEventAndData() {
        verifyLayout.setVisibility(View.GONE);
        btnConfirm.setEnabled(false);
        btnConfirm.setBackground(unClickBg);
        electronBeanList = new ArrayList<>();
        initPtr();
        initView();
        initList();
    }

    private void initView() {
        rvRefresh.setLayoutManager(new LinearLayoutManager(mActivity));
        adapter = new WalletElertronAdapter(mActivity, electronBeanList);
        rvRefresh.addItemDecoration(new SpacesItemDecoration(mActivity, LinearLayoutManager.HORIZONTAL));
        rvRefresh.setAdapter(adapter);
        slideLockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                btnConfirm.setEnabled(true);
                slideLockView.setStopAnim(false);
                verifyLayout.setVisibility(View.GONE);
                isVerfy = true;
                repeatTime = 1;
            }

            @Override
            public void onVerifyFail() {
                isVerfy = false;
                btnConfirm.setEnabled(false);
            }
        });
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
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
                initList();
            }

        });
    }


    private void initList() {
        new WalletMode(mActivity).getElectronList(new ApiResultObserver<Result<List<ElectronBean>>>(mActivity) {
            @Override
            public void onSuccess(Result<List<ElectronBean>> apiResult) {
                if (apiResult.getResult() == null){

                }else {
                    ElectronBean bean = new ElectronBean();
                    bean.setCard_amt(-1);
                    bean.setCard_no("卡号");
                    bean.setCard_pass("密码");
                    bean.setCard_state("状态");
                    electronBeanList.add(bean);
                    electronBeanList.addAll(apiResult.getResult());
                    adapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

        });
    }


    @OnTextChanged(value = R.id.et_gift_no, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onNoTextChenge(CharSequence text) {
        checkInput();
    }

    @OnTextChanged(value = R.id.et_gift_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onPwdTextChenge(CharSequence text) {
        checkInput();
    }

    private void checkInput() {
        String cardNo = etNo.getText().toString();
        String cardPwd = etPwd.getText().toString();
        if (TextUtils.isEmpty(cardNo) || TextUtils.isEmpty(cardPwd)) {
            btnConfirm.setEnabled(false);
            btnConfirm.setBackground(unClickBg);
        } else {
            btnConfirm.setEnabled(true);
            btnConfirm.setBackground(normalBg);
        }
    }


    @OnClick({R.id.btn_recharge_confirm})
    public void onButtonClick(View view) {
        final String cardNo = etNo.getText().toString().trim();
        String pwd = etPwd.getText().toString().trim();
        if (TextUtils.isEmpty(cardNo) || TextUtils.isEmpty(pwd)) {
            ToastUtils.showLongToast("请输入卡号和密码");
            return;
        }
        checkVerfy();
        if (verifyLayout.getVisibility() == View.VISIBLE && !isVerfy) {
            return;
        }
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.CARD_NO, cardNo);
        params.put(ParamKeys.CARD_PASS_WD, pwd);
        new WalletMode(mActivity).giftCardRecharge(params, new ApiResultObserver<ResultStr>(mActivity) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                if (e.getMessage().equals("卡号或者密码错误")) {
                    if (cardNo.equals(Constants.CARD_NO)) {
                        ++repeatTime;
                    } else {
                        repeatTime = 1;
                        Constants.CARD_NO = cardNo;
                    }
                }

            }

            @Override
            public void onSuccess(ResultStr apiResult) {
                ToastUtils.showLongToast(apiResult.getResult());
                getActivity().finish();
            }
        });


    }

    private void checkVerfy() {
        if (repeatTime >= 2) {
            verifyLayout.setVisibility(View.GONE);
            slideLockView.reset();
            btnConfirm.setEnabled(false);
            isVerfy = false;
        }
    }
}
