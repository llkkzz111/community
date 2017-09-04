package com.ocj.oms.mobile.third.login.alipay;

import com.ocj.oms.mobile.third.login.alipay.entery.AuthResult;

/**
 * Created by admin-ocj on 2017/5/2.
 */

public interface AlipayBusinessContract {
    interface AlipayBusinessPresenter {
        void alipayLogin();
    }

    interface AlipayLoginView {
        void alipayLoginSuccess(AuthResult authResult);

        void alipayLoginFail(AuthResult authResult);

    }
}
