package com.ocj.oms.mobile.ui.fragment;


import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.InputFilter;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.App;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.OrderBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.dialog.CommonDialogFragment;
import com.ocj.oms.mobile.dialog.PaySafeVerifyActivity;
import com.ocj.oms.mobile.http.service.pay.PayMode;
import com.ocj.oms.mobile.popup.BankListPopupWindow;
import com.ocj.oms.mobile.third.pay.PayCenterUtils;
import com.ocj.oms.mobile.ui.fragment.adapter.OrderItemsAdapter;
import com.ocj.oms.mobile.utils.CashierInputFilter;
import com.ocj.oms.rn.NumUtils;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;
import com.wei.android.lib.fingerprintidentify.FingerprintIdentify;
import com.wei.android.lib.fingerprintidentify.base.BaseFingerprint;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindString;
import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * A simple {@link BaseFragment} subclass.
 */
public class OrderDetailFragment extends BaseFragment implements BankListPopupWindow.onSelectPayStyleListener {

    @BindView(R.id.tv_order_id) TextView tvOrderId;
    @BindView(R.id.tv_page_tab) TextView tvPageTab;
    @BindView(R.id.rv_items) RecyclerView rvItems;
    @BindView(R.id.tv_all_points) CheckBox tvAllPoints;
    @BindView(R.id.et_use_points) EditText etUsePoints;
    @BindView(R.id.tv_deduction_points_money) TextView tvDeductionPointsMoney;
    @BindView(R.id.tv_all_imprest) CheckBox tvAllImprest;
    @BindView(R.id.et_imprest) EditText etImprest;
    @BindView(R.id.tv_deduction_impest_money) TextView tvDeductionImpestMoney;
    @BindView(R.id.tv_all_gift) CheckBox tvAllGift;
    @BindView(R.id.et_gift) EditText etGift;
    @BindView(R.id.tv_deduction_gift_money) TextView tvDeductionGiftMoney;
    @BindView(R.id.tv_order_money) TextView tvOrderMoney;
    @BindView(R.id.tv_deduction_money) TextView tvDeductionMoney;
    @BindView(R.id.tv_actual_pay) TextView tvActualPay;
    @BindView(R.id.tv_select_pay_type) TextView tvSelectPayType;
    @BindView(R.id.rg_select_pay) RadioGroup rgSelectPay;
    @BindView(R.id.btn_pay) Button btnPay;
    @BindView(R.id.ll_points) LinearLayout llPoints;
    @BindView(R.id.ll_imprest) LinearLayout llImprest;
    @BindView(R.id.ll_gift) LinearLayout llGift;
    @BindView(R.id.view_line) View viewLine;
    @BindView(R.id.ll_reduce) LinearLayout llReduce;
    @BindView(R.id.tv_discount) TextView tvDiscount;
    @BindView(R.id.tv_pay_title) TextView tvPayTitle;//在线支付头条名称
    @BindView(R.id.tv_pay_hint) TextView tvPayHint;//在线支付头条提示
    @BindView(R.id.img_pay) ImageView imgPay;//在线支付头条图片
    @BindView(R.id.rl_othe_pay) RelativeLayout rlOtherPay;//选择其他支付

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    private String orderId;
    private String pageNum;

    @BindString(R.string.text_points) String points;//可用￥%1$s积分
    @BindString(R.string.text_imprest) String imprest;//可用￥%1$s预付款
    @BindString(R.string.text_gift_package) String giftPackage;//可用￥%1$s礼包
    @BindString(R.string.text_money) String money;//￥%1$s
    @BindString(R.string.text_deduction_money) String deductionMoney; //抵￥%1$s
    private float disCount = 0;
    private float orderNum;//订单需付金额
    private float giftNum = 0;//礼品卡
    private float pointNum = 0;//积分
    private float imprestNum = 0;//预付款
    private float deductionNum = 0;//折扣额
    private OrderBean orderBean = null;
    private String payment;//支付方式
    private List<RadioButton> tabList = new ArrayList<>();
    private OrderBean.LastPaymentBean lastPaymentBean;
    private boolean isAllPoint = true;//第一次textchange不取消积分checkbox选中
    private boolean isAllImprest = true;//第一次textchange不取消预付款checkbox选中
    private boolean isAllGift = true;//第一次不取textchange消礼品卡checkbox选中
    private String TAG = OrderDetailFragment.class.getSimpleName();

    private CommonDialogFragment dialogFragment;

    private int PAY_CODE = 100;

    FingerprintIdentify mFingerprintIdentify;

    public OrderDetailFragment() {

    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_order_pay_layout;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }


    public void setPageNum(String pageNum) {
        this.pageNum = pageNum;
    }

    @Override
    protected void initEventAndData() {
        dialogFragment = CommonDialogFragment.newInstance();
        mFingerprintIdentify = new FingerprintIdentify(App.getInstance());

        OcjStoreDataAnalytics.trackPageBegin(getActivity(), ActivityID.AP1706C018);
        tvOrderId.setText(orderId);
        tvPageTab.setText(pageNum);

        etImprest.setFilters(new InputFilter[]{new CashierInputFilter()});
        etUsePoints.setFilters(new InputFilter[]{new CashierInputFilter()});
        etGift.setFilters(new InputFilter[]{new CashierInputFilter()});

        tvDeductionGiftMoney.setText(String.format(deductionMoney, "0"));
        tvDeductionImpestMoney.setText(String.format(deductionMoney, "0"));
        tvDeductionPointsMoney.setText(String.format(deductionMoney, "0"));
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.HORIZONTAL, false);
        rvItems.setLayoutManager(linearLayoutManager);

        btnPay.setEnabled(false);
        btnPay.setBackground(unClickBg);

        etUsePoints.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                isAllPoint = false;
                String ponits = etUsePoints.getText().toString();
                if (TextUtils.isEmpty(ponits) || ".".equals(ponits))
                    ponits = "0";
                pointNum = Float.valueOf(ponits);
                if (NumUtils.getFloat(imprestNum + pointNum + giftNum) < orderBean.getRealPayAmt()) {
                    if (pointNum >= 0 && pointNum < orderBean.getRealPayAmt()) {
                        if (tvAllImprest.isChecked()) {
                            etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
                        }
                        if (tvAllGift.isChecked()) {
                            etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
                        }
                    }
                }
                return false;
            }
        });
        etImprest.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                isAllImprest = false;
                String imprest = etImprest.getText().toString();
                if (TextUtils.isEmpty(imprest) || ".".equals(imprest))
                    imprest = "0";
                imprestNum = Float.valueOf(imprest);
                if (NumUtils.getFloat(imprestNum + pointNum + giftNum) < orderBean.getRealPayAmt()) {
                    if (imprestNum >= 0 && imprestNum < orderBean.getRealPayAmt()) {
                        if (tvAllPoints.isChecked()) {
                            etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
                        }
                        if (tvAllGift.isChecked()) {
                            etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
                        }
                    }
                }
                return false;
            }
        });

        etGift.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                isAllGift = false;
                String gift = etGift.getText().toString();
                if (TextUtils.isEmpty(gift) || ".".equals(gift))
                    gift = "0";
                giftNum = Float.valueOf(gift);
                if (NumUtils.getFloat(imprestNum + pointNum + giftNum) < orderBean.getRealPayAmt()) {
                    if (giftNum >= 0 && giftNum < orderBean.getRealPayAmt()) {
                        if (tvAllPoints.isChecked()) {
                            etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
                        }
                        if (tvAllImprest.isChecked()) {
                            etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
                        }
                    }
                }
                return false;
            }
        });
    }


    @Override
    protected void lazyLoadData() {
        getOrderInfo();
    }

    private void getOrderInfo() {
        ((BaseActivity) mActivity).showLoading();
        new PayMode(mActivity).getOrderDetail(orderId, new ApiResultObserver<OrderBean>(mActivity) {
            @Override
            public void onSuccess(OrderBean apiResult) {
                ((BaseActivity) mActivity).hideLoading();
                btnPay.setEnabled(true);
                btnPay.setBackground(normalBg);
                orderBean = apiResult;
                if (apiResult.getPayStyle().equals("onlinePay")) {
                    tvSelectPayType.setText("在线支付：");
                    if (orderBean.isOnline_redu_5() != 0) {
                        llReduce.setVisibility(View.VISIBLE);
                        disCount = orderBean.isOnline_redu_5();
                        tvDiscount.setText(String.format(money, NumUtils.parseString(disCount)));
                    } else {
                        llReduce.setVisibility(View.GONE);
                    }

                } else {
                    tvSelectPayType.setText("货到付款：");
                }
                tvActualPay.setText(String.format(money, NumUtils.parseString(orderBean.getRealPayAmt() - disCount)));
                tvOrderMoney.setText(String.format(money, NumUtils.parseString(orderBean.getRealPayAmt())));
                tvDeductionMoney.setText(String.format(money, NumUtils.parseString(deductionNum)));
                tvAllImprest.setText(String.format(imprest, orderBean.getUseable_deposit()));
                tvAllPoints.setText(String.format(points, orderBean.getUseable_saveamt()));
                tvAllGift.setText(String.format(giftPackage, orderBean.getUseable_cardamt()));


                OrderItemsAdapter adapter = new OrderItemsAdapter(mActivity, orderBean.getImgUrlList());
                rvItems.setAdapter(adapter);

                int state = 0;
                if ("yes".equals(orderBean.getCardamt_yn()) && orderBean.getDouble_cardamt() > 0) {
                    llGift.setVisibility(View.VISIBLE);
                } else {
                    llGift.setVisibility(View.GONE);
                    state++;
                }

                if ("yes".equals(orderBean.getDeposit_yn()) && orderBean.getDouble_deposit() > 0) {
                    llImprest.setVisibility(View.VISIBLE);
                } else {
                    llImprest.setVisibility(View.GONE);
                    state++;
                }

                if ("yes".equals(orderBean.getSaveamt_yn()) && orderBean.getDouble_saveamt() > 0) {
                    llPoints.setVisibility(View.VISIBLE);
                } else {
                    llPoints.setVisibility(View.GONE);
                    state++;
                }
                if (state == 3) {
                    viewLine.setVisibility(View.GONE);
                } else {
                    viewLine.setVisibility(View.VISIBLE);
                }

                if (orderBean.getLastPayment().size() > 0) {
                    OrderBean.LastPaymentBean paymentBean = orderBean.getLastPayment().get(0);
                    tvPayTitle.setText(paymentBean.getTitle());
                    LoaderFactory.getLoader().loadNet(imgPay, paymentBean.getIocnUrl());
                    tvPayTitle.setText(paymentBean.getTitle());
                    tvPayHint.setText(paymentBean.getEventContent());
                    lastPaymentBean = paymentBean;
                    payment = paymentBean.getId();
                }

            }

            @Override
            public void onError(ApiException e) {
                ((BaseActivity) mActivity).hideLoading();
                ToastUtils.showShortToast(e.getMessage());
                if (e.getCode() == 4010) {
                    showPayVerify();
                }
            }
        });
    }

    //积分
    @OnCheckedChanged(R.id.tv_all_points)
    void points() {
        if (tvAllPoints.isChecked()) {
            isAllPoint = true;
            etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
            if (tvAllImprest.isChecked()) {
                etImprest.setText("");
                etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
                etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
            }
            if (tvAllGift.isChecked()) {
                etGift.setText("");
                etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
                etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
            }
        } else {
            if (isAllPoint)
                etUsePoints.setText("");
            if (tvAllImprest.isChecked() && "yes".equals(orderBean.getDeposit_yn()) && orderBean.getDouble_deposit() > 0) {
                etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
            }
            if (tvAllGift.isChecked() && "yes".equals(orderBean.getCardamt_yn()) && orderBean.getDouble_cardamt() > 0) {
                etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
            }
        }
    }

    //预付款
    @OnCheckedChanged(R.id.tv_all_imprest)
    void imprest() {
        if (tvAllImprest.isChecked()) {
            isAllImprest = true;
            etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
            if (tvAllGift.isChecked()) {
                etGift.setText("");
                etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
                etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
            }
        } else {
            if (isAllImprest)
                etImprest.setText("");
            if (tvAllPoints.isChecked() && "yes".equals(orderBean.getSaveamt_yn()) && orderBean.getDouble_saveamt() > 0) {
                etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
            }
            if (tvAllGift.isChecked() && "yes".equals(orderBean.getCardamt_yn()) && orderBean.getDouble_cardamt() > 0) {
                etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
            }
        }
    }

    //礼包
    @OnCheckedChanged(R.id.tv_all_gift)
    void gift() {
        if (tvAllGift.isChecked()) {
            isAllGift = true;
            etGift.setText(NumUtils.parseString(orderBean.getDouble_cardamt()));
        } else {
            if (isAllGift)
                etGift.setText("");
            if (tvAllPoints.isChecked() && "yes".equals(orderBean.getSaveamt_yn()) && orderBean.getDouble_saveamt() > 0) {
                etUsePoints.setText(NumUtils.parseString(orderBean.getDouble_saveamt()));
            }
            if (tvAllImprest.isChecked() && "yes".equals(orderBean.getDeposit_yn()) && orderBean.getDouble_deposit() > 0) {
                etImprest.setText(NumUtils.parseString(orderBean.getDouble_deposit()));
            }
        }
    }


    @OnClick(R.id.rl_othe_pay)
    void othepay() {
        if (orderBean != null && orderBean.getLastPayment().size() > 1) {
            BankListPopupWindow bankListPopupWindow = new BankListPopupWindow(mActivity, OrderDetailFragment.this);
            bankListPopupWindow.setmDatas(orderBean.getLastPayment());
            bankListPopupWindow.popShow(rlOtherPay);
        }
    }


    /**
     * 礼包输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_gift, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onGiftChenge(CharSequence charSequence) {
        String gift = etGift.getText().toString();
        if (TextUtils.isEmpty(gift) || ".".equals(gift))
            gift = "0";
        giftNum = Float.valueOf(gift);

        if (orderBean != null) {
            if (giftNum > orderBean.getDouble_cardamt()) {
                giftNum = orderBean.getDouble_cardamt();
                etGift.setText(NumUtils.parseString(giftNum));
                etGift.setSelection(etGift.length());
            }

            if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
                if (tvAllImprest.isChecked() && pointNum + giftNum < orderBean.getRealPayAmt()) {
                    imprestNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - giftNum);
                    etImprest.setText(NumUtils.parseString(imprestNum));
                }
                if (tvAllPoints.isChecked() && imprestNum + giftNum < orderBean.getRealPayAmt()) {
                    pointNum = NumUtils.getFloat(orderBean.getRealPayAmt() - imprestNum - giftNum);
                    etUsePoints.setText(NumUtils.parseString(pointNum));
                }
            }
        }

        if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
            giftNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - imprestNum);
            etGift.setText(NumUtils.parseString(giftNum));
            etGift.setSelection(etGift.length());
        }

        if (!isAllGift && tvAllGift.isChecked()) {
            tvAllGift.setChecked(false);
        }
        setOrderNum();
        if (isAllGift) {
            etGift.setSelection(etGift.length());
        }
        tvDeductionGiftMoney.setText(String.format(deductionMoney, NumUtils.parseString(giftNum)));
    }

    /**
     * 积分输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_use_points, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onPointChenge(CharSequence charSequence) {
        String points = etUsePoints.getText().toString();
        if (TextUtils.isEmpty(points) || ".".equals(points))
            points = "0";
        pointNum = Float.valueOf(points);

        if (orderBean != null) {
            if (pointNum > orderBean.getDouble_saveamt()) {
                pointNum = orderBean.getDouble_saveamt();
                etUsePoints.setText(NumUtils.parseString(pointNum));
                etUsePoints.setSelection(etUsePoints.length());
            }

            if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
                if (tvAllImprest.isChecked() && pointNum + giftNum < orderBean.getRealPayAmt()) {
                    imprestNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - giftNum);
                    etImprest.setText(NumUtils.parseString(imprestNum));
                }
                if (tvAllGift.isChecked() && pointNum + imprestNum < orderBean.getRealPayAmt()) {
                    giftNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - imprestNum);
                    etGift.setText(NumUtils.parseString(giftNum));
                }
            }
        }

        if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
            pointNum = NumUtils.getFloat(orderBean.getRealPayAmt() - giftNum - imprestNum);
            etUsePoints.setText(NumUtils.parseString(pointNum));
            etUsePoints.setSelection(etUsePoints.length());
        }


        if (!isAllPoint && tvAllPoints.isChecked()) {
            tvAllPoints.setChecked(false);
        }
        setOrderNum();
        tvDeductionPointsMoney.setText(String.format(deductionMoney, NumUtils.parseString(pointNum)));
        if (isAllPoint) {
            etUsePoints.setSelection(etUsePoints.length());
        }


    }

    /**
     * 预付款输入
     *
     * @param charSequence
     */
    @OnTextChanged(value = R.id.et_imprest, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onImprestChenge(CharSequence charSequence) {
        String imprest = etImprest.getText().toString();
        if (TextUtils.isEmpty(imprest) || ".".equals(imprest))
            imprest = "0";
        imprestNum = Float.parseFloat(imprest);

        if (orderBean != null) {
            if (imprestNum > orderBean.getDouble_deposit()) {
                imprestNum = orderBean.getDouble_deposit();
                etImprest.setText(NumUtils.parseString(imprestNum));
                etImprest.setSelection(etImprest.length());
            }

            if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
                if (tvAllPoints.isChecked() && imprestNum + giftNum < orderBean.getRealPayAmt()) {
                    pointNum = NumUtils.getFloat(orderBean.getRealPayAmt() - imprestNum - giftNum);
                    etUsePoints.setText(NumUtils.parseString(pointNum));
                }
                if (tvAllGift.isChecked() && pointNum + imprestNum < orderBean.getRealPayAmt()) {
                    giftNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - imprestNum);
                    etGift.setText(NumUtils.parseString(giftNum));
                }
            }
        }

        if (NumUtils.getFloat(imprestNum + giftNum + pointNum) > orderBean.getRealPayAmt()) {
            imprestNum = NumUtils.getFloat(orderBean.getRealPayAmt() - pointNum - giftNum);
            etImprest.setText(NumUtils.parseString(imprestNum));
            etImprest.setSelection(etImprest.length());
        }

        if (!isAllImprest && tvAllImprest.isChecked()) {
            tvAllImprest.setChecked(false);
        }
        setOrderNum();
        if (isAllImprest) {
            etImprest.setSelection(etImprest.length());
        }
        tvDeductionImpestMoney.setText(String.format(deductionMoney, NumUtils.parseString(imprestNum)));


    }

    private void setOrderNum() {
        deductionNum = (giftNum + pointNum + imprestNum);
        tvDeductionMoney.setText(String.format(deductionMoney, NumUtils.parseString(deductionNum)));
        if (orderBean != null) {
            orderNum = orderBean.getRealPayAmt() - deductionNum;
        }
        if (orderBean.getRealPayAmt() - deductionNum >= disCount + 1 && disCount > 0) {
            tvActualPay.setText(String.format(money, NumUtils.parseString(orderBean.getRealPayAmt() - deductionNum - disCount)));
            llReduce.setVisibility(View.VISIBLE);
        } else {
            tvActualPay.setText(String.format(money, NumUtils.parseString(orderBean.getRealPayAmt() - deductionNum)));
            llReduce.setVisibility(View.GONE);
        }

    }


    @OnClick(R.id.btn_pay)
    public void onClick(View view) {
        if (TextUtils.isEmpty(payment)) {
            ToastUtils.showShortToast("正在获取支付方式，请稍等...");
            return;
        }
//        mFingerprintIdentify = new FingerprintIdentify(getActivity());
        if (OCJPreferencesUtils.getFinger() && mFingerprintIdentify.isFingerprintEnable()) {
            dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                @Override
                public void initData() {
                    dialogFragment.setTopImage(R.drawable.icon_finger)
                            .setTitle("指纹安全校验")
                            .setTitleSize(17)
                            .setTitleClolor(R.color.black)
                            .setContent("通过Home键验证已有手机指纹")
                            .setContentClolor(R.color.text_grey_666666)
                            .setContentSize(14)
                            .setNegative("取消")
                            .setNegativeClolor(R.color.text_grey_666666)
                            .setNegativeSize(17)
                            .setNegativeListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    mFingerprintIdentify.cancelIdentify();
                                }
                            });
                }
            });
            dialogFragment.show(getActivity().getFragmentManager(), "2");
            mFingerprintIdentify.startIdentify(3, new BaseFingerprint.FingerprintIdentifyListener() {
                @Override
                public void onSucceed() {
                    // 验证成功，自动结束指纹识别
                    payOrder();
                }

                @Override
                public void onNotMatch(int availableTimes) {
                    // 指纹不匹配，并返回可用剩余次数并自动继续验证
                    dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                        @Override
                        public void initData() {
                            dialogFragment.setTopImage(R.drawable.icon_finger)
                                    .setTitle("再试一次")
                                    .setContent("通过Home键验证已有手机指纹")
                                    .setNegative("取消")
                                    .setNegativeListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                            mFingerprintIdentify.cancelIdentify();
                                        }
                                    });
                        }
                    });
                }

                @Override
                public void onFailed(boolean isDeviceLocked) {
                    // 错误次数达到上限或者API报错停止了验证，自动结束指纹识别
                    // isDeviceLocked 表示指纹硬件是否被暂时锁定
                    dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                        @Override
                        public void initData() {
                            dialogFragment.setTopImage(R.drawable.icon_finger)
                                    .setTitle("指纹验证失败")
                                    .setContent("请通过密码或验证码进行校验")
                                    .setPositive("确定")
                                    .setNegative("取消")
                                    .setNegativeListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                            mFingerprintIdentify.cancelIdentify();
                                        }
                                    })
                                    .setPositiveListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View v) {
                                            showFingerPayVerify();
                                            mFingerprintIdentify.cancelIdentify();
                                        }
                                    });
                        }
                    });
                }

                @Override
                public void onStartFailedByDeviceLocked() {
                    // 第一次调用startIdentify失败，因为设备被暂时锁定
                    dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                        @Override
                        public void initData() {
                            dialogFragment.setTopImage(R.drawable.icon_finger)
                                    .setTitle("指纹验证失败")
                                    .setContent("请通过密码或验证码进行校验")
                                    .setPositive("确定")
                                    .setNegative("取消")
                                    .setNegativeListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                            mFingerprintIdentify.cancelIdentify();
                                        }
                                    })
                                    .setPositiveListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View v) {
                                            showFingerPayVerify();
                                            mFingerprintIdentify.cancelIdentify();
                                        }
                                    });
                        }
                    });
                }
            });
        } else {
            payOrder();
        }

    }

    private void showPayVerify() {
        Intent intent = getActivity().getIntent();
        intent.setClass(getContext(), PaySafeVerifyActivity.class);
        startActivity(intent);
    }


    private void showFingerPayVerify() {
        Intent intent = new Intent(getActivity(),PaySafeVerifyActivity.class);
        OrderDetailFragment.this.startActivityForResult(intent, PAY_CODE);
    }

    @Override
    public void onPay(OrderBean.LastPaymentBean bean) {
        lastPaymentBean = bean;
        payment = bean.getId();
        tvPayTitle.setText(lastPaymentBean.getTitle());
        tvPayHint.setText(lastPaymentBean.getEventContent());
        LoaderFactory.getLoader().loadNet(imgPay, bean.getIocnUrl());
    }


    @Override
    public void cancleSelect() {
        if (lastPaymentBean == null) {
            for (RadioButton tab : tabList) {
                if ((!TextUtils.isEmpty(tab.getTag().toString())) && tab.getTag().equals(payment)) {
                    tab.setChecked(true);
                } else {
                    tab.setChecked(false);
                }
            }
        }
    }

    /**
     * 订单支付
     */
    private void payOrder() {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.ORDER_NO, orderId);
        params.put(ParamKeys.PAY_SAVEAMT, etUsePoints.getText().toString());
        params.put(ParamKeys.PAY_DESPOST, etImprest.getText().toString());
        params.put(ParamKeys.PAY_GIFCARD, etGift.getText().toString());
        params.put(ParamKeys.PAY_PAYMTHD, payment);
        btnPay.setEnabled(false);
        btnPay.setBackground(unClickBg);

        if (null != dialogFragment && dialogFragment.isVisible()) {
            dialogFragment.dismiss();
        }
        mFingerprintIdentify.cancelIdentify();

        new PayMode(mActivity).payCenter(params, new ApiResultObserver<Result<String>>(mActivity) {
            @Override
            public void onSuccess(Result<String> apiResult) {
                Intent intent = new Intent();
                if (orderBean.getPayStyle().equals("onlinePay")) {
                    btnPay.setEnabled(true);
                    btnPay.setBackground(normalBg);
                    switch (payment) {
                        case "3":
                        case "4":
                        case "5":
//                            ToastUtils.showLongToast("支付成功");
                            intent.setAction("com.ocj.oms.pay");
                            intent.putExtra(IntentKeys.ORDER_NO, orderId);
                            intent.putExtra(IntentKeys.ORDER_HINT,"支付成功");
                            mActivity.sendBroadcast(intent);
                            break;
                        default:
                            if (deductionNum == orderBean.getRealPayAmt()) {
//                                ToastUtils.showLongToast("支付成功");
                                intent.setAction("com.ocj.oms.pay");
                                intent.putExtra(IntentKeys.ORDER_NO, orderId);
                                intent.putExtra(IntentKeys.ORDER_HINT,"支付成功");
                                mActivity.sendBroadcast(intent);
                            } else {
                                new PayCenterUtils(mActivity, apiResult.getResult(), orderId).pay(payment, lastPaymentBean.getTitle());
                            }
                            break;
                    }
                } else {
//                    ToastUtils.showLongToast("订购成功");
                    intent = new Intent("com.ocj.oms.pay");
                    intent.putExtra(IntentKeys.ORDER_NO, orderId);
                    intent.putExtra(IntentKeys.PAY_STYLE, "notonlinePay");
                    intent.putExtra(IntentKeys.ORDER_HINT,"订购成功");
                    mActivity.sendBroadcast(intent);
                }

                Map<String, Object> params1 = new HashMap<String, Object>();
                params1.put("type", payment);
                params1.put("orderid", orderId);

                OcjStoreDataAnalytics.trackEvent(getActivity(), EventId.AP1706C018F008001O008001, "", params1);

            }

            @Override
            public void onError(ApiException e) {
                btnPay.setEnabled(true);
                btnPay.setBackground(normalBg);
                ToastUtils.showShortToast(e.getMessage());
                if (e.getCode() == 4010) {
                    showPayVerify();
                    if (null != dialogFragment && dialogFragment.isVisible()) {
                        dialogFragment.dismiss();
                    }
                    mFingerprintIdentify.cancelIdentify();
                }
            }
        });
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mFingerprintIdentify.cancelIdentify();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == PAY_CODE && resultCode == getActivity().RESULT_OK) {
            payOrder();
        }
        super.onActivityResult(requestCode, resultCode, data);

    }
}
