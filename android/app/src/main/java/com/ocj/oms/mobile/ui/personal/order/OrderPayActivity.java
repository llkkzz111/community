package com.ocj.oms.mobile.ui.personal.order;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.LogUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.OrderStatusBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.pay.PayMode;
import com.ocj.oms.mobile.ui.fragment.OrderDetailFragment;
import com.ocj.oms.mobile.ui.fragment.QueryBalanceFragment;
import com.ocj.oms.mobile.ui.fragment.WalletRechargeFragment;
import com.ocj.oms.mobile.ui.fragment.adapter.PageTabFragmentAdapter;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/20.
 */
@Route(path = RouterModule.AROUTER_PATH_PAY)
public class OrderPayActivity extends BaseActivity {

    @BindView(R.id.tab_order_detail) ViewPager viewPager;
    @BindView(R.id.tv_tips) TextView tvTips;
    private PageTabFragmentAdapter pagerAdapter;
    List<String> tabTitles = new ArrayList<>();

    private String ordersJson;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_order_pay_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C018);
        ordersJson = getIntent().getStringExtra(IntentKeys.ORDERS);
        if (!TextUtils.isEmpty(ordersJson)) {
            String[] orderArray = ordersJson.substring(1, ordersJson.length() - 1).split(",");
            for (int i = 0; i < orderArray.length; i++) {
                tabTitles.add(i, orderArray[i].substring(1, orderArray[i].length() - 1));
            }
        }
        initTabs();

        setTipsText();

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("com.ocj.oms.pay");
        registerReceiver(payReceiver, intentFilter);

        IntentFilter orderFilter = new IntentFilter();
        orderFilter.addAction("wechat_orderId");
        registerReceiver(wechatOrderid, orderFilter);
    }

    private void initTabs() {
        pagerAdapter = new PageTabFragmentAdapter(getSupportFragmentManager(), tabTitles, createFragments(tabTitles), createFragmentTypes(tabTitles));
        viewPager.setPageMargin((int) (-DensityUtil.getScreenW(this) / 10 * 1.2));
        viewPager.setOffscreenPageLimit(tabTitles.size());
        viewPager.removeAllViewsInLayout();
        viewPager.setAdapter(pagerAdapter);
        viewPager.setPageTransformer(true, new ZoomOutPageTransformer());
    }

    private ArrayList<Fragment> createFragments(List<String> tabs) {
        if (tabs == null || tabs.size() == 0) {
            return null;
        }

        ArrayList<Fragment> list = new ArrayList<>();
        String fragmentType = null;

        for (int i = 0; i < tabs.size(); i++) {
            if (tabs.get(i).equals("礼包充值")) {
                WalletRechargeFragment homeFragment = new WalletRechargeFragment();
                list.add(homeFragment);
            } else if (tabs.get(i).equals("余额查询")) {
                QueryBalanceFragment motionFragment = new QueryBalanceFragment();
                list.add(motionFragment);
            } else {
                OrderDetailFragment orderFragment = new OrderDetailFragment();
                orderFragment.setOrderId(tabs.get(i));
                orderFragment.setPageNum((i) + 1 + "/" + tabs.size());
                list.add(orderFragment);
            }
        }
        return list;
    }

    private ArrayList<String> createFragmentTypes(List<String> tabs) {
        if (tabs == null || tabs.size() == 0) {
            return null;
        }

        ArrayList<String> list = new ArrayList<>();
        String fragmentType = null;
        for (int i = 0; i < tabs.size(); i++) {
            if (tabs.get(i).equals("礼包充值")) {
                fragmentType = "礼包充值";
                list.add(fragmentType);
            } else if (tabs.get(i).equals("余额查询")) {
                fragmentType = "余额查询";
                list.add(fragmentType);
            } else {
                fragmentType = "订单详情";
                list.add(fragmentType);
            }
        }

        return list;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

    @OnClick(R.id.btn_close)
    public void onClick(View view) {
        if (pagerAdapter.getFragmentType().equals("订单详情")) {
            OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C018D003001C003001);
        }
        RouterModule.sendRefreshCartEvent("", "");
    }

    @Override
    public void onBackPressed() {
        RouterModule.sendRefreshCartEvent("", "");
    }

    BroadcastReceiver payReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String orderNo = intent.getStringExtra(IntentKeys.ORDER_NO);
            if (!TextUtils.isEmpty(orderId)) {
                orderNo = orderId;
            }
            String hint = intent.getStringExtra(IntentKeys.ORDER_HINT);
            String paystyle = intent.getStringExtra(IntentKeys.PAY_STYLE);
            if(TextUtils.isEmpty(hint)){
                hint = "支付成功";
            }
            if("notonlinePay".equals(paystyle)){
                paySuccess(orderNo,hint);
            }else {
                orderPayStatus(orderNo,hint);
            }
        }
    };
    String orderId = null;
    BroadcastReceiver wechatOrderid = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            orderId = intent.getStringExtra(IntentKeys.ORDER_NO);
        }
    };


    private void setTipsText() {
        tvTips.setText(Html.fromHtml(getString(R.string.text_order_pay_tips, tabTitles.size())));
    }

    class ZoomOutPageTransformer implements ViewPager.PageTransformer {
        private static final float MAX_SCALE = 0.9f;
        private static final float MIN_SCALE = 0.8f;//0.85f

        @Override
        public void transformPage(View view, float position) {
            //setScaleY只支持api11以上
            if (position < -1) {
                view.setScaleX(MIN_SCALE);
                view.setScaleY(MIN_SCALE);
            } else if (position <= 1) //a页滑动至b页 ； a页从 0.0 -1 ；b页从1 ~ 0.0
            { // [-1,1]
//              Log.e("TAG", view + " , " + position + "");
                float scaleFactor = MIN_SCALE + (1 - Math.abs(position)) * (MAX_SCALE - MIN_SCALE);
                view.setScaleX(scaleFactor);
                //每次滑动后进行微小的移动目的是为了防止在三星的某些手机上出现两边的页面为显示的情况
                if (position > 0) {
                    view.setTranslationX(-scaleFactor * 2);
                } else if (position < 0) {
                    view.setTranslationX(scaleFactor * 2);
                }
                if (scaleFactor == 1) {
                    Log.e("scale", scaleFactor + "");
                }
                view.setScaleY(scaleFactor);

            } else { // (1,+Infinity]

                view.setScaleX(MIN_SCALE);
                view.setScaleY(MIN_SCALE);

            }
        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(payReceiver);
        unregisterReceiver(wechatOrderid);
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C018);

    }

    private void paySuccess(String orderNo,String hint){
        ToastUtils.showLongToast(hint);
        Iterator<String> iterator = tabTitles.iterator();
        while (iterator.hasNext()) {
            String co = iterator.next();
            if (!TextUtils.isEmpty(co) && co.equals(orderNo)) {
                iterator.remove();
            }
        }

        LogUtils.d("paycenter", tabTitles.size() + tabTitles.toString());

        if (tabTitles.size() == 0) {
            Intent intent = new Intent();
            intent.setClass(mContext, OrderPaySuccedActivity.class);
            intent.putExtra(IntentKeys.ORDER_NO_LIST, ordersJson);
            startActivity(intent);
            finish();
        } else {
            initTabs();
            setTipsText();
        }
        orderId = "";
    }

    private void orderPayStatus(final String orderId, final String hint) {
        Map<String, String> params = new HashMap();
        params.put("order_no", orderId);
        new PayMode(this).orderPayStatus(params, new ApiResultObserver<OrderStatusBean>(this) {
            @Override
            public void onSuccess(OrderStatusBean apiResult) {
                if ("success".equals(apiResult.getResponseResult())) {
                    paySuccess(orderId,hint);
                }
            }

            @Override
            public void onError(ApiException e) {
                if (e.getCode() == 1040100201) {
                    ToastUtils.showLongToast("token为空,不能支付");
                } else if (e.getCode() == 1040100202) {
                    ToastUtils.showLongToast("支付时查询订单详情失败");
                } else if (e.getCode() == 1040100203) {
                    ToastUtils.showLongToast("订单支付时失败");
                }
            }
        });
    }
}
