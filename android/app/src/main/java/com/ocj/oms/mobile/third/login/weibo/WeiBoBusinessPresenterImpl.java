package com.ocj.oms.mobile.third.login.weibo;

import android.app.Activity;

import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.third.login.ThirdPartyView;
import com.ocj.oms.mobile.third.login.weibo.WeiBoBusinessContract.WeiBoBusinessPresenter;
import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.auth.AccessTokenKeeper;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.WbAuthListener;
import com.sina.weibo.sdk.auth.WbConnectErrorMessage;
import com.sina.weibo.sdk.auth.sso.SsoHandler;

/**
 * Created by admin-ocj on 2017/4/28.
 */

public class WeiBoBusinessPresenterImpl implements WeiBoBusinessPresenter {
    private Activity context;
    private ThirdPartyView thirdPartyView;

    public WeiBoBusinessPresenterImpl(Activity context, ThirdPartyView thirdPartyView) {
        this.context = context;
        this.thirdPartyView = thirdPartyView;
    }


    /**
     * 微博三方授权登录
     *
     * @return SsoHandler
     * 重要：发起SSO登录的Activity,必须重写onActivityResult并在其中调用authorizeCallBack方法
     * <pre>
     * protected void onActivityResult(int requestCode, int resultCode, Intent data) {
     *  super.onActivityResult(requestCode, resultCode, data);
     *  if (ssoHandler != null) {
     *      ssoHandler.authorizeCallBack(requestCode, resultCode, data);
     *  }
     * }
     * </pre>
     */
    @Override
    public SsoHandler weiboLogin() {
        WbSdk.install(context, new AuthInfo(context, Constants.WEIBO_APP_KEY, Constants.WEIBO_REDIRECT_URL, Constants.WEIBO_SCOPE));
        SsoHandler ssoHandler = new SsoHandler(context);
        ssoHandler.authorize(new WeiboLoginListener());
        return ssoHandler;
    }


    public class WeiboLoginListener implements WbAuthListener {
        @Override
        public void onSuccess(Oauth2AccessToken oauth2AccessToken) {
            AccessTokenKeeper.writeAccessToken(context, oauth2AccessToken);
            if (thirdPartyView != null) {
                thirdPartyView.weiboLoginSuccess(oauth2AccessToken);
            }
        }

        @Override
        public void cancel() {
            if (thirdPartyView != null) {
                thirdPartyView.weiboLoginFail("onCancel");
            }
        }

        @Override
        public void onFailure(WbConnectErrorMessage wbConnectErrorMessage) {
            if (thirdPartyView != null) {
                thirdPartyView.weiboLoginFail(wbConnectErrorMessage.getErrorCode() + " : " + wbConnectErrorMessage.getErrorMessage());
            }
        }
    }
}
