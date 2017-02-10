package com.choudao.equity.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.choudao.equity.R;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXEntryActivity extends BaseActivity implements IWXAPIEventHandler {

    Activity mActivity;
    // IWXAPI 是第三方 app 和微信通信的openapi接口
    private IWXAPI api;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, ConstantUtils.WEIXIN_APPID, true);
        api.handleIntent(getIntent(), this);
        mActivity = this;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }

    private void closeActivity() {
        this.finish();
    }

    @Override
    public void onResp(final BaseResp resp) {
        String content = null;
        if (resp.getType() == ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX) {
            closeActivity();
        } else {
            SendAuth.Resp sendResp = (SendAuth.Resp) resp;
            Intent intent = new Intent(ConstantUtils.WX_LOG_ACTION);
            intent.putExtra(IntentKeys.KEY_WX_ERR_CODE, resp.errCode);
            switch (resp.errCode) {
                case BaseResp.ErrCode.ERR_OK:
                    content = getResources().getString(R.string.login_wx_ok);
                    if (sendResp.state != null && ConstantUtils.WX_RESP_STATE.equals(sendResp.state)) {
                        intent.putExtra(IntentKeys.KEY_WX_LOGIN_CODE, sendResp.code);
                        sendBroadcast(intent);
                        closeActivity();
                    }
                    break;
                case BaseResp.ErrCode.ERR_USER_CANCEL:
                    content = getResources().getString(R.string.login_wx_cancle);

                    intent.putExtra(IntentKeys.KEY_WX_CONTENT, content);
                    sendBroadcast(intent);
                    closeActivity();

                    break;
                case BaseResp.ErrCode.ERR_AUTH_DENIED:
                case BaseResp.ErrCode.ERR_COMM:
                case BaseResp.ErrCode.ERR_SENT_FAILED:
                case BaseResp.ErrCode.ERR_UNSUPPORT:
                    content = getResources().getString(R.string.login_wx_err);
                    intent.putExtra(IntentKeys.KEY_WX_CONTENT, content);
                    sendBroadcast(intent);
                    closeActivity();
                    break;
                default:
                    break;
            }
        }

    }

    @Override
    public void onReq(BaseReq arg0) {

    }

}
