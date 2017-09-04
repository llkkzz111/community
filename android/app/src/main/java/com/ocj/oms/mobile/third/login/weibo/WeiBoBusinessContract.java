package com.ocj.oms.mobile.third.login.weibo;

import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.sso.SsoHandler;

/**
 * Created by admin-ocj on 2017/4/28.
 */

public interface WeiBoBusinessContract {
    interface WeiBoBusinessPresenter {
        SsoHandler weiboLogin();
    }

    interface WeiboLoginView {
        void weiboLoginSuccess(Oauth2AccessToken oauth2AccessToken);

        void weiboLoginFail(String msg);
    }

}
