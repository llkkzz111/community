package com.ocj.oms.mobile.wxapi;

import android.content.Intent;

import com.bilibili.socialize.share.core.ui.BaseWXEntryActivity;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.third.Constants;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;


/**
 * Created by Administrator on 2017/4/21 0021.
 */

public class WXEntryActivity extends BaseWXEntryActivity implements IWXAPIEventHandler {

    @Override
    protected String getAppId() {
        return Constants.WEIXIN_APP_ID;
    }

    @Override
    protected void handleLoginSuccess(BaseResp resp) {
        String code = ((SendAuth.Resp) resp).code;
        Intent intent = new Intent();
        intent.setAction("wechat");
        intent.putExtra(IntentKeys.ASSOCIATE_STATE, code);
        sendBroadcast(intent);
    }

}
