package com.ocj.oms.mobile.ui.fragment;


import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * A simple {@link Fragment} subclass.
 */
public class QueryBalanceFragment extends BaseFragment {


    @BindView(R.id.et_gift_no) ClearEditText etNo;//卡号

    @BindView(R.id.et_gift_pwd) ClearEditText etPwd;//密码
    @BindView(R.id.btn_qerry_balance) Button btnConfirm;

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @BindView(R.id.ll_slide) LinearLayout verifyLayout;
    @BindView(R.id.slide) SlideLockView slideLockView;
    int repeatTime = 1;//账号输入重复次数

    boolean isVerfy = false;


    public static QueryBalanceFragment newInstance(String param1, String param2) {
        QueryBalanceFragment fragment = new QueryBalanceFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_query_balance_layout;
    }


    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mActivity, ActivityID.AP1706C045);
        btnConfirm.setEnabled(false);
        btnConfirm.setBackground(unClickBg);
        verifyLayout.setVisibility(View.GONE);
        initView();
    }

    private void initView() {
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


    @Override
    protected void lazyLoadData() {

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


    @OnClick({R.id.btn_qerry_balance})
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

        new WalletMode(mActivity).querryGiftCardBalance(params, new ApiResultObserver<Num>(mActivity) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                if (e.getMessage().equals("卡号或者密码错误")) {
                    if (cardNo.equals(Constants.CARD_NO_Query)) {
                        ++repeatTime;
                    } else {
                        repeatTime = 1;
                        Constants.CARD_NO_Query = cardNo;
                    }
                }


            }

            @Override
            public void onSuccess(Num apiResult) {
                ToastUtils.showShortToast("您的余额为" + apiResult.getNum().toString());
            }

            @Override
            public void onComplete() {

            }
        });


    }

    private void checkVerfy() {
        if (repeatTime >= 2) {
            verifyLayout.setVisibility(View.VISIBLE);
            slideLockView.reset();
            btnConfirm.setEnabled(false);
            isVerfy = false;
        }
    }


}
