package com.ocj.oms.mobile.dialog;


import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;

import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.CouponListBean;
import com.ocj.oms.mobile.view.CouponLayout;
import com.ocj.oms.mobile.view.ShoppingRuleLayout;
import com.ocj.oms.mobile.view.TakePhotoLayout;
import com.ocj.oms.mobile.view.TaxAlarmLayout;

import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;


/**
 * Created by yy on 2017/5/8.
 */

public class PopupWindowActivity extends BaseActivity {

    @BindView(R.id.ll_popup_window) FrameLayout ryvBanlist;//银行卡列表


    String popType = "";
    private List<CouponListBean> couponListBeen;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_popup_window_layout;
    }


    @Override
    protected void initEventAndData() {
        popType = getIntent().getStringExtra(IntentKeys.POP_TYPE);
        couponListBeen = (List<CouponListBean>) getIntent().getSerializableExtra(IntentKeys.COUPON);
        switch (popType) {
            case PopupType.PHOTO:// 拍照/从相册 浮层
                addPhotoView();
                break;
            case "3":

                break;
            case PopupType.ALARM:
                addCustomeView();
                break;
            case PopupType.COUPON:
                addCouponView();
                break;
            case PopupType.SHOPPING_RULE:
                addShoppingRule();
                break;

        }
    }


    public void addCustomeView() {
        TaxAlarmLayout view = new TaxAlarmLayout(mContext, "");
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        ryvBanlist.addView(view, layoutParams);
    }

    private void addPhotoView() {
        TakePhotoLayout pop = new TakePhotoLayout(this);
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        ryvBanlist.addView(pop, layoutParams);
    }

    private void addCouponView() {
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        CouponLayout couponLayout = new CouponLayout(this);
        couponLayout.setCouponListBeen(couponListBeen);
        couponLayout.setOnCloseClickListener(new CouponLayout.OnCloseClickListener() {
            @Override
            public void onCloseClick() {
                finishAnimte();
            }
        });
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        ryvBanlist.addView(couponLayout, layoutParams);
    }

    private void addShoppingRule() {
        ShoppingRuleLayout shoppingRuleLayout = new ShoppingRuleLayout(this);
        shoppingRuleLayout.setOnCloseClickListener(new ShoppingRuleLayout.OnCloseClickListener() {
            @Override
            public void onCloseClick() {
                finishAnimte();
            }
        });
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        ryvBanlist.addView(shoppingRuleLayout, layoutParams);
    }

    @OnClick(R.id.view_dismiss)
    public void onClick() {
        finishAnimte();
    }

    private void finishAnimte() {
        finish();
        overridePendingTransition(R.anim.push_bottom_in, R.anim.push_bottom_out);
    }

    @Override
    public void onBackPressed() {
        finishAnimte();
    }


}
