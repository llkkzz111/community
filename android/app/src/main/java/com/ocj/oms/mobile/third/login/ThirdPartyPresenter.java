package com.ocj.oms.mobile.third.login;

import android.app.Activity;

import com.ocj.oms.mobile.third.login.alipay.AlipayBusinessContract;
import com.ocj.oms.mobile.third.login.alipay.AlipayBusinessPresenterImpl;
import com.ocj.oms.mobile.third.login.qq.QQBusinessContract.QQBusinessPresenter;
import com.ocj.oms.mobile.third.login.qq.QQBusinessPresenterImpl;
import com.ocj.oms.mobile.third.login.wechat.WechatBusinessContract;
import com.ocj.oms.mobile.third.login.wechat.WechatBusinessPresenterImpl;
import com.ocj.oms.mobile.third.login.weibo.WeiBoBusinessContract;
import com.ocj.oms.mobile.third.login.weibo.WeiBoBusinessPresenterImpl;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.tencent.tauth.IUiListener;

/**
 * Created by admin-ocj on 2017/4/28.
 */

public class ThirdPartyPresenter implements QQBusinessPresenter, WeiBoBusinessContract.WeiBoBusinessPresenter, WechatBusinessContract.WechatBusinessPresenter, AlipayBusinessContract.AlipayBusinessPresenter {
    private QQBusinessPresenterImpl qqBusinessPresenter;
    private WeiBoBusinessPresenterImpl weiBoBusinessPresenter;
    private WechatBusinessPresenterImpl wechatBusinessPresenter;
    private AlipayBusinessPresenterImpl alipayBusinessPresenter;

    public ThirdPartyPresenter(Activity context, ThirdPartyView thirdPartyView) {
        this(new QQBusinessPresenterImpl(context, thirdPartyView), new WeiBoBusinessPresenterImpl(context, thirdPartyView), new WechatBusinessPresenterImpl(context), new AlipayBusinessPresenterImpl(context, thirdPartyView));
    }

    public ThirdPartyPresenter(QQBusinessPresenterImpl qqBusinessPresenter, WeiBoBusinessPresenterImpl weiBoBusinessPresenter, WechatBusinessPresenterImpl wechatBusinessPresenter, AlipayBusinessPresenterImpl alipayBusinessPresenter) {
        this.qqBusinessPresenter = qqBusinessPresenter;
        this.weiBoBusinessPresenter = weiBoBusinessPresenter;
        this.wechatBusinessPresenter = wechatBusinessPresenter;
        this.alipayBusinessPresenter = alipayBusinessPresenter;
    }

    @Override
    public IUiListener qqLogin() {
        if (qqBusinessPresenter != null) {
            return qqBusinessPresenter.qqLogin();
        }
        return null;
    }

    @Override
    public SsoHandler weiboLogin() {
        if (weiBoBusinessPresenter != null) {
            return weiBoBusinessPresenter.weiboLogin();
        }
        return null;
    }



    @Override
    public void wechatLogin() {
        if (wechatBusinessPresenter != null) {
            wechatBusinessPresenter.wechatLogin();
        }
    }

    @Override
    public void alipayLogin() {
        if (alipayBusinessPresenter != null) {
            alipayBusinessPresenter.alipayLogin();
        }
    }
}
