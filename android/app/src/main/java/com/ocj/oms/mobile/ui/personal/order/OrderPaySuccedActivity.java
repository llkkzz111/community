package com.ocj.oms.mobile.ui.personal.order;

import android.content.Intent;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.EventResultsItem;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.fragment.globalbuy.OrderSuccedRecommendFragment;
import com.ocj.oms.mobile.ui.personal.order.dialog.CutEventDialog;
import com.ocj.oms.mobile.ui.rn.RouteConfigs;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.webview.WebViewActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/6/13.
 * <p>
 * 支付成功页面
 */

public class OrderPaySuccedActivity extends BaseActivity {
    @BindView(R.id.btn_close) TextView btnClose;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.iv_alarm) ImageView ivAlarm;
    @BindView(R.id.tv_thanks) TextView tvThanks;
    @BindView(R.id.tv_check_order) TextView tvCheckOrder;
    @BindView(R.id.tv_continue_shop) TextView tvContinueShop;
    @BindView(R.id.fl_fragment) FrameLayout flFragment;
    @BindView(R.id.tv_tips) TextView tvTips;
    @BindView(R.id.tv_order_no) TextView tvOrderNo;

    private String ordersJson;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_succed_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C018);
        if (TextUtils.equals(getIntent().getStringExtra(IntentKeys.RESERVE_SUCCESS), IntentKeys.RESERVE_SUCCESS)) {
            tvTitle.setText("预约成功");
            tvThanks.setText("谢谢您！预约已完成！");
            tvTips.setText("我们将在商品到货后电话通知您并安排配送");
        } else {
            tvTitle.setText("东东收银台");
        }

        ordersJson = getIntent().getStringExtra(IntentKeys.ORDER_NO_LIST);
        if (!TextUtils.isEmpty(ordersJson)) {
            String[] orderArray = ordersJson.substring(1, ordersJson.length() - 1).split(",");
            tvOrderNo.setVisibility(View.VISIBLE);
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < orderArray.length; i++) {
                String orderNo = orderArray[i].substring(1, orderArray[i].length() - 1);
                sb.append(String.format("订单号:%s", orderNo));
                if (i != orderArray.length - 1) {
                    sb.append("\n");
                }
            }
            tvOrderNo.setText(sb.toString());
        }

        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.add(R.id.fl_fragment, new OrderSuccedRecommendFragment()).commit();

        new ItemsMode(mContext).getFullCutEvents(new ApiResultObserver<List<EventResultsItem>>(mContext) {
            @Override
            public void onSuccess(List<EventResultsItem> apiResult) {
                if (apiResult == null || apiResult.size() == 0) {
                    return;
                }
                showEventDialog(apiResult);
            }

            @Override
            public void onError(ApiException e) {

            }
        });
    }

    private CutEventDialog dialog;

    private void showEventDialog(List<EventResultsItem> list) {
        dialog = new CutEventDialog(mContext, list, new CutEventDialog.OnEventClickListener() {
            @Override
            public void itemClick(int position, String url) {
                if (TextUtils.isEmpty(url)) {
                    return;
                }
                Intent intent = new Intent();
                intent.setClass(mContext, WebViewActivity.class);
                intent.putExtra(IntentKeys.URL, url);
                startActivity(intent);
                dialog.dismiss();
            }
        });
        dialog.show();
    }

    @OnClick({R.id.btn_close, R.id.tv_check_order, R.id.tv_continue_shop})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_close:
                RouterModule.invokePayResult(RouteConfigs.OrderCenter);
                break;
            case R.id.tv_check_order:
                RouterModule.invokePayResult(RouteConfigs.OrderCenter);
                break;
            case R.id.tv_continue_shop:
                RouterModule.invokePayResult(RouteConfigs.ResetToHome);
                break;
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C018);
    }
}
