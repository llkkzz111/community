package com.ocj.oms.mobile.third.pay.wechat;

import android.content.Context;

import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import static com.ocj.oms.mobile.third.Constants.WEIXIN_APP_ID;

/**
 * Created by yy on 2017/5/9.
 */

public class WechatUtil {

    public static void wxpay(Context mContext, WechatBean bean) {
        final IWXAPI mWxApi = WXAPIFactory.createWXAPI(mContext, WEIXIN_APP_ID, true);//测试用的
        mWxApi.registerApp(WEIXIN_APP_ID);

        PayReq req = new PayReq();
        req.appId = WEIXIN_APP_ID;
        req.partnerId = bean.getPartnerid();
        req.prepayId = bean.getPrepayid();
        req.nonceStr =bean.getNoncestr();//
        req.timeStamp = bean.getTimestamp();// 时间戳，app服务器小哥给出
        req.packageValue = bean.getPackageValue();
        req.sign = bean.getPaySign();// 签名
        mWxApi.sendReq(req);
    }
}



