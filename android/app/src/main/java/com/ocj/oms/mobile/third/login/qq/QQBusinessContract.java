package com.ocj.oms.mobile.third.login.qq;

import com.tencent.tauth.IUiListener;

import org.json.JSONObject;

/**
 * qq三方登录相关
 */

public interface QQBusinessContract {
    interface QQBusinessPresenter {
        IUiListener qqLogin();
    }

    interface QQLoginView {
        void qqLoginSuccess(JSONObject jsonObject);

        void qqLoginFail(String msg);
    }
}
