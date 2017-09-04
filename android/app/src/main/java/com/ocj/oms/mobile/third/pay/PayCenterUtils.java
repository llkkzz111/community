package com.ocj.oms.mobile.third.pay;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.third.pay.alipay.AlipayUtils;
import com.ocj.oms.mobile.third.pay.union.UnionPayActivity;
import com.ocj.oms.mobile.third.pay.wechat.WechatBean;
import com.ocj.oms.mobile.third.pay.wechat.WechatUtil;
import com.ocj.oms.mobile.ui.personal.order.H5PayActivity;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by liuzhao on 2017/6/5.
 */

public final class PayCenterUtils {
    private String result;
    private Context mContext;
    private String orderId;
    private String type;

    public PayCenterUtils(Context mContext, String result, String orderId) {
        this.result = result;
        this.orderId = orderId;
        this.mContext = mContext;
    }

    public void pay(String type, String name) {
        this.type = type;
        switch (type) {
            case "35":
                Intent intent = new Intent();
                intent.setClass(mContext, H5PayActivity.class);
                intent.putExtra(IntentKeys.PAY_URL, result);
                intent.putExtra(IntentKeys.PAY_TITLE, name);
                mContext.startActivity(intent);
                break;
            case "38":
                aliPay();
                break;
            case "39":
                wxPay();
                break;
            case "45":
                unionPay();
                break;
            case "49":
                ToastUtils.showLongToast("不存在");
                break;
            default:
                otherPay(name);
                break;

        }
    }

    public void wxPay() {
        sendOrderId();
        WechatBean bean = new Gson().fromJson(result, WechatBean.class);
        WechatUtil.wxpay(mContext, bean);
    }

    public void aliPay() {
        AlipayUtils.alipayPay((Activity) mContext, result, orderId);
    }

    public void unionPay() {
        sendOrderId();
        result = result.substring(1, result.length() - 1);
        String[] list = result.split(",");
        String tn = "";
        for (String s : list) {
            if (s.indexOf("tn") > 0) {
                System.out.println(s.indexOf("tn=") + 3);
                tn = s.substring(4);
            }
        }

        Intent intent = new Intent();
        intent.setClass(mContext, UnionPayActivity.class);
        intent.putExtra("tn", tn);
        mContext.startActivity(intent);

    }


    public void otherPay(String name) {

        sendOrderId();

        try {
            JSONObject jsonObject = new JSONObject(result);

            String form = jsonObject.getString("form");
            String payReturnUrl = jsonObject.getString("payReturnUrl");
            if (TextUtils.equals("8", type)) {
                payReturnUrl = "http://m.ocj.com.cn/pay/ccb_pay_return.jhtml";
            }else if (TextUtils.equals("51", type)){
                payReturnUrl = "https://payment.bankcomm.com/mobilegateway/ShopService/paysucc.aspx";
            }
            Intent intent = new Intent();
            intent.setClass(mContext, H5PayActivity.class);
            intent.putExtra(IntentKeys.PAY_URL, form);
            intent.putExtra(IntentKeys.PAY_RETURN_URL, payReturnUrl);
            intent.putExtra(IntentKeys.PAY_TITLE, name);
            mContext.startActivity(intent);

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void sendOrderId() {
        Intent intent = new Intent();
        intent.setAction("wechat_orderId");
        intent.putExtra(IntentKeys.ORDER_NO, orderId);
        mContext.sendBroadcast(intent);
    }


}
