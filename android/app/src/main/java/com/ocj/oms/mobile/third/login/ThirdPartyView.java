package com.ocj.oms.mobile.third.login;

import android.app.Activity;
import android.content.Intent;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.bean.ThirdBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.third.login.alipay.AlipayBusinessContract;
import com.ocj.oms.mobile.third.login.alipay.entery.AuthResult;
import com.ocj.oms.mobile.third.login.qq.QQBusinessContract;
import com.ocj.oms.mobile.third.login.weibo.WeiBoBusinessContract;
import com.ocj.oms.mobile.ui.login.association.AccountAssociationActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.DeviceUtils;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.tencent.connect.common.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * 三方登录所有回调界面处理
 * 如果不使用，请自己实现对应的view接口
 * wechat在WXEntryActivity中实现
 */

public class ThirdPartyView implements QQBusinessContract.QQLoginView, WeiBoBusinessContract.WeiboLoginView, AlipayBusinessContract.AlipayLoginView {
    private Activity context;

    public ThirdPartyView(Activity context) {
        this.context = context;
    }

    @Override
    public void qqLoginSuccess(JSONObject jsonObject) {
        try {
            final String code = jsonObject.getString(Constants.PARAM_ACCESS_TOKEN);//有可能是 拿openId
            new AccountMode(context).qqLogin(code, DeviceUtils.getIMEI(context), new ApiResultObserver<ThirdBean>(context) {
                @Override
                public void onError(ApiException e) {
                    ToastUtils.showLongToast(e.getMessage());
                }

                @Override
                public void onSuccess(ThirdBean apiResult) {
                    if (apiResult.getAssociateState().equals("0")) {//没有关联
                        Intent intent = new Intent(context, AccountAssociationActivity.class);
                        intent.putExtra(IntentKeys.ASSOCIATE_STATE, apiResult.getAssociateState());
                        intent.putExtra(IntentKeys.RESULT, apiResult.getResult());
                        context.startActivity(intent);
                    } else {
                        OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                        if ("WebView".equals(context.getIntent().getStringExtra("fromPage"))) {
                            RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                        } else {
                            RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                            RouterModule.sendEvent("EventReminder", "self", OCJPreferencesUtils.getAccessToken(), "");
                        }

                    }
                }

                @Override
                public void onComplete() {

                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void qqLoginFail(String msg) {
        loginFail(msg);
    }

    @Override
    public void weiboLoginSuccess(final Oauth2AccessToken oauth2AccessToken) {

        final String token = oauth2AccessToken.getToken();//请求需要的 token

        new AccountMode(context).weiboLogin(token, DeviceUtils.getIMEI(context), new ApiResultObserver<ThirdBean>(context) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(ThirdBean apiResult) {
                if (apiResult.getAssociateState().equals("0")) {//没有关联
                    Intent intent = new Intent(context, AccountAssociationActivity.class);
                    intent.putExtra(IntentKeys.ASSOCIATE_STATE, apiResult.getAssociateState());
                    intent.putExtra(IntentKeys.RESULT, apiResult.getResult());
                    context.startActivity(intent);
                } else {
                    OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                    if ("WebView".equals(context.getIntent().getStringExtra("fromPage"))) {
                        RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                    } else {
                        RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                        RouterModule.sendEvent("EventReminder", "self", OCJPreferencesUtils.getAccessToken(), "");
                    }

                }
            }

            @Override
            public void onComplete() {
            }
        });


    }

    @Override
    public void weiboLoginFail(String msg) {
        loginFail(msg);
    }


    @Override
    public void alipayLoginSuccess(AuthResult authResult) {
        final String aliOpenId = authResult.getAuthCode();
        new AccountMode(context).aliPayLogin(aliOpenId, "", new ApiResultObserver<ThirdBean>(context) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(ThirdBean apiResult) {
                if (apiResult.getAssociateState().equals("0")) {//没有关联
                    Intent intent = context.getIntent();
                    intent.setClass(context, AccountAssociationActivity.class);
                    intent.putExtra(IntentKeys.ASSOCIATE_STATE, apiResult.getAssociateState());
                    intent.putExtra(IntentKeys.RESULT, apiResult.getResult());
                    context.startActivity(intent);
                } else {
                    OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                    if ("WebView".equals(context.getIntent().getStringExtra("fromPage"))) {
                        RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                    } else {
                        RouterModule.invokeTokenCallback(null, apiResult.getAccessToken(), "self", false);
                        RouterModule.sendEvent("EventReminder", "self", OCJPreferencesUtils.getAccessToken(), "");
                    }

                }
            }

            @Override
            public void onComplete() {

            }
        });

    }

    @Override
    public void alipayLoginFail(AuthResult authResult) {
        ToastUtils.showShortToast("授权失败");
    }


    public void loginFail(String msg) {
        if (msg.equals("onCancel")) {
        } else {
            ToastUtils.showShortToast(msg);
        }
    }

}
