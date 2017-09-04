package com.ocj.oms.mobile.ui;

import android.content.Intent;
import android.graphics.Paint;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.BaseEventBean;
import com.ocj.oms.mobile.bean.CouponListBean;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.bean.RequestReserveBean;
import com.ocj.oms.mobile.bean.ReserveOrderBean;
import com.ocj.oms.mobile.bean.SubmitReserveOrderBean;
import com.ocj.oms.mobile.dialog.PopupType;
import com.ocj.oms.mobile.dialog.PopupWindowActivity;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.personal.adress.ReceiverAddressSelectActivity;
import com.ocj.oms.mobile.ui.personal.order.OrderPaySuccedActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.rn.NumUtils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.Disposable;

/**
 * Created by liutao on 2017/6/20.
 */
@Route(path = RouterModule.AROUTER_PATH_RESERVE)
public class ReserveOrderActivity extends BaseActivity {
    @BindView(R.id.iv_back) ImageView ivBack;
    @BindView(R.id.rl_top_bar) RelativeLayout rlTopBar;
    @BindView(R.id.tv_text) TextView tvText;
    @BindView(R.id.tv_reserve) TextView tvReserve;
    @BindView(R.id.rl_bottom) RelativeLayout rlBottom;
    @BindView(R.id.tv_name) TextView tvName;
    @BindView(R.id.tv_mobile) TextView tvMobile;
    @BindView(R.id.tv_default) TextView tvDefault;
    @BindView(R.id.tv_change) TextView tvChange;
    @BindView(R.id.tv_address) TextView tvAddress;
    @BindView(R.id.ll_address) LinearLayout llAddress;
    @BindView(R.id.iv_goods) ImageView ivGoods;
    @BindView(R.id.sw_contact) Switch swContact;
    @BindView(R.id.rb_pay_type1) RadioButton rbPayType1;
    @BindView(R.id.rb_pay_type2) RadioButton rbPayType2;
    @BindView(R.id.rg_select_pay) RadioGroup rgSelectPay;
    @BindView(R.id.line) View line;
    @BindView(R.id.tv_all_points) TextView tvAllPoints;
    @BindView(R.id.et_use_points) EditText etUsePoints;
    @BindView(R.id.tv_deduction_points_money) TextView tvDeductionPointsMoney;
    @BindView(R.id.tv_all_imprest) TextView tvAllImprest;
    @BindView(R.id.et_imprest) EditText etImprest;
    @BindView(R.id.tv_deduction_impest_money) TextView tvDeductionImpestMoney;
    @BindView(R.id.tv_all_gift) TextView tvAllGift;
    @BindView(R.id.et_gift) EditText etGift;
    @BindView(R.id.tv_deduction_gift_money) TextView tvDeductionGiftMoney;
    @BindView(R.id.tv_price1) TextView tvPrice1;
    @BindView(R.id.tv_price2) TextView tvPrice2;
    @BindView(R.id.tv_price3) TextView tvPrice3;
    @BindView(R.id.tv_price4) TextView tvPrice4;
    @BindView(R.id.tv_agreement) TextView tvAgreement;
    @BindView(R.id.tv_coupon_name) TextView tvCouponName;
    @BindView(R.id.tv_actual_pay) TextView tvActualPay;
    @BindView(R.id.tv_address_bottom) TextView tvAddressBottom;
    @BindView(R.id.rl_coupon) RelativeLayout rlCoupon;
    @BindView(R.id.ll_points) LinearLayout llPoints;
    @BindView(R.id.tv_goods_name) TextView tvGoodsName;
    @BindView(R.id.tv_goods_price) TextView tvGoodsPrice;
    @BindView(R.id.tv_goods_count) TextView tvGoodsCount;
    @BindView(R.id.tv_gift) TextView tvGift;
    @BindView(R.id.ll_gift) LinearLayout llGift;
    @BindView(R.id.rl_no_address) RelativeLayout rlNoAddress;
    @BindView(R.id.rl_address) RelativeLayout rlAddress;

    private ReceiversBean receiversBean;
    private float giftNum = 0;//礼品卡
    private float pointNum = 0;//积分
    private float imprestNum = 0;//预付款

    private float totalNum = 0;//商品总额
    private float couponNum = 0;//抵用券价格
    private float discountNum = 0;//优惠价格

    private ReserveOrderBean reserveOrderBean;
    private CouponListBean couponListBean = null;


    private RequestReserveBean requestReserveBean;

    private boolean isShow = false;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_reserve_order_layout;
    }

    @Override
    protected void initEventAndData() {
        EventBus.getDefault().register(this);
        tvAgreement.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
        Intent intent = getIntent();
        String reserveData = intent.getStringExtra("reserveData");
        requestReserveBean = new Gson().fromJson(reserveData, RequestReserveBean.class);
        getReserveOrder();
    }

    /**
     * 礼包输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_gift, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onGiftChenge(CharSequence charSequence) {
        if (charSequence.toString().contains(".")) {
            if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                charSequence = charSequence.toString().subSequence(0,
                        charSequence.toString().indexOf(".") + 3);
                etGift.setText(charSequence);
                etGift.setSelection(charSequence.length());
            }
        }
        if (charSequence.toString().startsWith(".")) {
            charSequence = "0" + charSequence;
            etGift.setText(charSequence);
            etGift.setSelection(2);
        }

        if (charSequence.toString().startsWith("0")
                && charSequence.toString().trim().length() > 1) {
            if (!charSequence.toString().substring(1, 2).equals(".")) {
                etGift.setText(charSequence.subSequence(0, 1));
                etGift.setSelection(1);
                return;
            }
        }
        String gift = etGift.getText().toString();
        if (TextUtils.isEmpty(gift))
            gift = "0";
        giftNum = Float.parseFloat(gift);
        if (imprestNum + giftNum + pointNum + discountNum + couponNum > totalNum) {
            giftNum = (totalNum - pointNum - imprestNum - discountNum - couponNum);
            etGift.setText(NumUtils.parseString(giftNum));
        }
        if (giftNum > Float.parseFloat(reserveOrderBean.getUseable_cardamt().replace(",", ""))) {
            giftNum = Float.parseFloat(reserveOrderBean.getUseable_cardamt().replace(",", ""));
            etGift.setText(NumUtils.parseString(giftNum));
        }
        setOrderNum();
        etGift.setSelection(etGift.length());
        tvDeductionGiftMoney.setText(String.format(" 抵 ￥%s", NumUtils.parseString(giftNum)));

    }

    /**
     * 积分输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_use_points, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onPointChenge(CharSequence charSequence) {
        if (charSequence.toString().contains(".")) {
            if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                charSequence = charSequence.toString().subSequence(0,
                        charSequence.toString().indexOf(".") + 3);
                etUsePoints.setText(charSequence);
                etUsePoints.setSelection(charSequence.length());
            }
        }
        if (charSequence.toString().startsWith(".")) {
            charSequence = "0" + charSequence;
            etUsePoints.setText(charSequence);
            etUsePoints.setSelection(2);
        }

        if (charSequence.toString().startsWith("0")
                && charSequence.toString().trim().length() > 1) {
            if (!charSequence.toString().substring(1, 2).equals(".")) {
                etUsePoints.setText(charSequence.subSequence(0, 1));
                etUsePoints.setSelection(1);
                return;
            }
        }
        String points = etUsePoints.getText().toString();
        if (TextUtils.isEmpty(points))
            points = "0";
        pointNum = Float.parseFloat(points);
        if (imprestNum + giftNum + pointNum + discountNum + couponNum > totalNum) {
            pointNum = (totalNum - giftNum - imprestNum - discountNum - couponNum);
            etUsePoints.setText(NumUtils.parseString(pointNum));
        }
        if (pointNum > Float.parseFloat(reserveOrderBean.getUseable_saveamt().replace(",", ""))) {
            pointNum = Float.parseFloat(reserveOrderBean.getUseable_saveamt().replace(",", ""));
            etUsePoints.setText(NumUtils.parseString(pointNum));
        }
        setOrderNum();
        tvDeductionPointsMoney.setText(String.format(" 抵 ￥%s", NumUtils.parseString(pointNum)));
        etUsePoints.setSelection(etUsePoints.length());
    }

    /**
     * 预付款输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_imprest, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onImprestChenge(CharSequence charSequence) {
        if (charSequence.toString().contains(".")) {
            if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                charSequence = charSequence.toString().subSequence(0,
                        charSequence.toString().indexOf(".") + 3);
                etImprest.setText(charSequence);
                etImprest.setSelection(charSequence.length());
            }
        }
        if (charSequence.toString().startsWith(".")) {
            charSequence = "0" + charSequence;
            etImprest.setText(charSequence);
            etImprest.setSelection(2);
        }

        if (charSequence.toString().startsWith("0")
                && charSequence.toString().trim().length() > 1) {
            if (!charSequence.toString().substring(1, 2).equals(".")) {
                etImprest.setText(charSequence.subSequence(0, 1));
                etImprest.setSelection(1);
                return;
            }
        }
        String imprest = etImprest.getText().toString();
        if (TextUtils.isEmpty(imprest))
            imprest = "0";
        imprestNum = Float.parseFloat(imprest);
        if (imprestNum + giftNum + pointNum + couponNum > totalNum - discountNum) {
            imprestNum = (totalNum - pointNum - giftNum - discountNum - couponNum);
            etImprest.setText(NumUtils.parseString(imprestNum));
        }

        if (imprestNum > Float.parseFloat(reserveOrderBean.getUseable_deposit().replace(",", ""))) {
            imprestNum = Float.parseFloat(reserveOrderBean.getUseable_deposit().replace(",", ""));
            etImprest.setText(NumUtils.parseString(imprestNum));
        }
        setOrderNum();
        etImprest.setSelection(etImprest.length());
        tvDeductionImpestMoney.setText(String.format(" 抵 ￥%s", NumUtils.parseString(imprestNum)));
    }

    private void setOrderNum() {
        tvActualPay.setText(String.format("￥%s", NumUtils.parseString(totalNum - (giftNum + pointNum + imprestNum) - couponNum - discountNum)));
    }

    private void getReserveOrder() {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.ITEM_CODE, requestReserveBean.getItem_code());
        params.put(ParamKeys.UNIT_CODE, requestReserveBean.getUnit_code());
        params.put(ParamKeys.QTY, requestReserveBean.getQty());
        params.put(ParamKeys.SHOP_NO, requestReserveBean.getShop_no());
        params.put(ParamKeys.MEMBERPROMO, requestReserveBean.getMemberPromo());
        params.put(ParamKeys.GIFT_ITEM_CODE, requestReserveBean.getGift_item_code());
        params.put(ParamKeys.GIFT_UNIT_CODE, requestReserveBean.getGift_unit_code());
        params.put(ParamKeys.GIFTPROMO_NO, requestReserveBean.getGiftPromo_no());
        params.put(ParamKeys.GIFTPROMO_SEQ, requestReserveBean.getGiftPromo_seq());
        params.put(ParamKeys.RECEIVER_SEQ, requestReserveBean.getReceiver_seq());
        showLoading();
        new AccountMode(mContext).getReserveOrder(params, new ApiObserver<ApiResult<ReserveOrderBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onNext(@NonNull ApiResult<ReserveOrderBean> reserveOrderBeanApiResult) {
                reserveOrderBean = reserveOrderBeanApiResult.getData();
                hideLoading();
                initView();
            }
        });
    }

    private void initView() {
        if (reserveOrderBean == null) {
            return;
        }
        if (reserveOrderBean.getReceivers() != null) {
            llAddress.setVisibility(View.VISIBLE);
            rlNoAddress.setVisibility(View.GONE);
            receiversBean = reserveOrderBean.getReceivers();
            tvName.setText(receiversBean.getReceiver_name());
            tvMobile.setText(receiversBean.getReceiver_hp());
            tvAddress.setText(receiversBean.getAddr_m() + receiversBean.getReceiver_addr());
            tvDefault.setVisibility(receiversBean.getDefault_yn().equals("1") ? View.VISIBLE : View.GONE);
            tvAddressBottom.setText(receiversBean.getAddr_m() + receiversBean.getReceiver_addr());
        } else {
            llAddress.setVisibility(View.GONE);
            rlNoAddress.setVisibility(View.VISIBLE);
        }
        totalNum = reserveOrderBean.getTotal_price();
        discountNum = reserveOrderBean.getDc_amt();
        tvPrice1.setText(String.format("￥%s", NumUtils.parseString(totalNum)));
        tvPrice2.setText(String.format("- ￥%s", NumUtils.parseString(discountNum)));
        tvPrice3.setText(String.format("- ￥%s", NumUtils.parseString(couponNum)));
        tvAllPoints.setText(String.format("可用%s积分", reserveOrderBean.getUseable_saveamt()));
        tvAllGift.setText(String.format("可用%s礼包", reserveOrderBean.getUseable_cardamt()));
        tvAllImprest.setText(String.format("可用%s预付款", reserveOrderBean.getUseable_deposit()));
        if (reserveOrderBean.isAuto_order_yn()) {
            llPoints.setVisibility(View.VISIBLE);
        }

        if (reserveOrderBean.getOrders() != null && reserveOrderBean.getOrders().get(0).isIsCouponUsable()) {
            rlCoupon.setVisibility(View.VISIBLE);
        }
        if (reserveOrderBean.getOrders() != null && reserveOrderBean.getOrders().size() > 0 && reserveOrderBean.getOrders().get(0).getCarts() != null) {
            LoaderFactory.getLoader().loadNet(ivGoods, reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getPath());
            tvGoodsName.setText(String.format("                   %s", reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getItem_name()));
            tvGoodsPrice.setText(String.format("￥%s", reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getSale_price()));
            tvGoodsCount.setText(String.format("x%s", reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getCount()));
            if (reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getSx_gifts() != null && reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getSx_gifts().size() > 0) {
                llGift.setVisibility(View.VISIBLE);
                tvGift.setText(reserveOrderBean.getOrders().get(0).getCarts().get(0).getItem().getSx_gifts().get(0).trim());
            }
            if (reserveOrderBean.getOrders().get(0).getCarts().get(0).getTwgiftcartVO() != null && reserveOrderBean.getOrders().get(0).getCarts().get(0).getTwgiftcartVO().size() > 0) {
                llGift.setVisibility(View.VISIBLE);
                tvGift.setText(tvGift.getText().toString() + "\n" + reserveOrderBean.getOrders().get(0).getCarts().get(0).getTwgiftcartVO().get(0).getItem_name());
            }
        }
        setOrderNum();
    }

    private void submitReserveOrder() {
        if ((totalNum - (giftNum + pointNum + imprestNum) - couponNum - discountNum) < 0) {
            ToastUtils.showLongToast("你使用了过多的抵扣，请重新选择!");
            return;
        }
        final Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.ITEM_CODE, requestReserveBean.getItem_code());
        params.put(ParamKeys.UNIT_CODE, requestReserveBean.getUnit_code());
        params.put(ParamKeys.PAY_MTHD, rbPayType1.isChecked() ? "2" : "1");
        params.put(ParamKeys.PAY_SAVEAMT, pointNum + "");
        params.put(ParamKeys.PAY_DESPOST, imprestNum + "");
        params.put(ParamKeys.PAY_GIFCARD, giftNum + "");
        params.put(ParamKeys.SAVEBOUNS, "");
        if (receiversBean != null) {
            params.put(ParamKeys.RECEIVER_SEQ, receiversBean.getReceiver_seq());
        }
        if (couponListBean != null) {
            params.put(ParamKeys.ITEM_CODE_COUPON, requestReserveBean.getItem_code() + "_" + couponListBean.getCoupon_no() + "_" + couponListBean.getCoupon_seq());
            params.put(ParamKeys.DCCOUPON_AMT, couponListBean.getReal_coupon_amt() + "");
        }
        params.put(ParamKeys.PAY_FLG, swContact.isChecked()?"0":"1");
        showLoading();
        new AccountMode(mContext).submitReserveOrder(params, new ApiObserver<ApiResult<SubmitReserveOrderBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onNext(@NonNull ApiResult<SubmitReserveOrderBean> submitReserveOrderBeanApiResult) {
                ToastUtils.showShortToast("预约成功");
                hideLoading();
                Intent intent = new Intent(mContext, OrderPaySuccedActivity.class);
                intent.putExtra(IntentKeys.RESERVE_SUCCESS, IntentKeys.RESERVE_SUCCESS);
                intent.putExtra(IntentKeys.ORDER_NO, submitReserveOrderBeanApiResult.getData().getOrder_no());
                startActivity(intent);
                finish();
            }
        });
    }

    @Subscribe
    public void onEvent(BaseEventBean event) {
        switch (event.type) {
            case IntentKeys.COUPON:
                couponListBean = (CouponListBean) event.data;
                if (couponListBean != null && !TextUtils.isEmpty(couponListBean.getCoupon_note())) {
                    tvCouponName.setText(couponListBean.getCoupon_note());
                    if (TextUtils.equals(couponListBean.getDc_gb(), "10")) {
                        couponNum = couponListBean.getReal_coupon_amt();
                    } else {
                        couponNum = totalNum * (10 - couponListBean.getReal_coupon_amt()) / 10;
                    }
                } else {
                    tvCouponName.setText("不使用抵用券");
                    couponNum = 0;
                }
                tvPrice3.setText(String.format("- ￥%s", NumUtils.parseString(couponNum)));
                setOrderNum();
                break;
            case IntentKeys.ADDRESS:
                receiversBean = (ReceiversBean) event.data;
                if (receiversBean != null) {
                    rlNoAddress.setVisibility(View.GONE);
                    llAddress.setVisibility(View.VISIBLE);
                    tvName.setText(receiversBean.getReceiver_name());
                    tvMobile.setText(receiversBean.getReceiver_hp1() + " **** " + receiversBean.getReceiver_hp3());
                    tvAddress.setText(receiversBean.getAddr_m() + receiversBean.getReceiver_addr());
                    tvDefault.setVisibility(receiversBean.getDefault_yn().equals("1") ? View.VISIBLE : View.GONE);

                    tvAddressBottom.setText(receiversBean.getAddr_m() + receiversBean.getReceiver_addr());
                }
                break;
        }
    }


    @OnClick({R.id.iv_back, R.id.rl_coupon, R.id.rl_address, R.id.tv_reserve, R.id.tv_agreement})
    public void onClick(final View view) {
        Intent intent;
        switch (view.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.rl_coupon:
                if (!isShow) {
                    intent = new Intent(mContext, PopupWindowActivity.class);
                    intent.putExtra(IntentKeys.POP_TYPE, PopupType.COUPON);
                    intent.putExtra(IntentKeys.COUPON, (Serializable) reserveOrderBean.getOrders().get(0).getCouponList());
                    startActivity(intent);
                    isShow = true;
                }
                //防止快速点击
                Observable.interval(0, 1, TimeUnit.SECONDS)
                        .take(2)
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Observer<Long>() {
                            @Override
                            public void onSubscribe(Disposable d) {

                            }

                            @Override
                            public void onNext(Long aLong) {
                            }

                            @Override
                            public void onError(Throwable e) {

                            }

                            @Override
                            public void onComplete() {
                                isShow = false;
                            }
                        });
                break;
            case R.id.rl_address:
                intent = new Intent(mContext, ReceiverAddressSelectActivity.class);
                intent.putExtra(IntentKeys.FROM, ReceiverAddressSelectActivity.FROM_RESERVE);
                startActivity(intent);
                break;
            case R.id.tv_reserve:
                submitReserveOrder();
                break;
            case R.id.tv_agreement:
                RouterModule.globalToWebView("http://m.ocj.com.cn/other/thh.jsp");
                break;
        }
    }

    @Override
    protected void onDestroy() {
        EventBus.getDefault().unregister(this);
        super.onDestroy();
    }
}
