package com.ocj.oms.mobile.wxapi;


/*import net.sourceforge.simcpux.Constants;
import net.sourceforge.simcpux.R;*/

import android.content.Intent;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.third.Constants;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;


public class WXPayEntryActivity extends BaseActivity implements IWXAPIEventHandler {

    private IWXAPI api;


    @Override
    protected int getLayoutId() {
        return 0;
    }

    @Override
    protected void initEventAndData() {
        api = WXAPIFactory.createWXAPI(this, Constants.WEIXIN_APP_ID);//先用测试的
        api.handleIntent(getIntent(), this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }


    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp resp) {
        //支付结果返回参数封装在这里，但是不能以这个为最后的结果，应该以公司app 服务器返回结果为准
        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            if (resp.errCode == 0) {
                ToastUtils.showLongToast("支付成功");
                Intent intent = new Intent();
                intent.setAction("com.ocj.oms.pay");
                sendBroadcast(intent);
            } else if (resp.errCode == -1) {
                ToastUtils.showLongToast("支付失败!");//可能原因:签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。

            } else if (resp.errCode == -2) {
                ToastUtils.showLongToast("取消支付");
            }
            finish();

        }
    }
}