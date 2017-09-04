package com.ocj.oms.mobile.third.login.wechat;

import android.app.Activity;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.third.Constants;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

/**
 * Created by admin-ocj on 2017/5/2.
 */

public class WechatBusinessPresenterImpl implements WechatBusinessContract.WechatBusinessPresenter {
    private Activity context;

    public WechatBusinessPresenterImpl(Activity context) {
        this.context = context;
    }

    /**
     * 微信三方授权登录
     * 目前移动应用上微信登录只提供原生的登录方式，需要用户安装微信客户端才能配合使用。
     */
    @Override
    public void wechatLogin() {
        IWXAPI wxapi = WXAPIFactory.createWXAPI(context, Constants.WEIXIN_APP_ID, true);
        wxapi.registerApp(Constants.WEIXIN_APP_ID);

        if (wxapi.isWXAppInstalled()) {
            //登陆
            SendAuth.Req req = new SendAuth.Req();
            req.scope = "snsapi_userinfo";
            req.state = "";
            wxapi.sendReq(req);
        } else {
            ToastUtils.showLongToast("你还没安装微信!");
        }


    }
}
