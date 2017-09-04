package com.ocj.oms.mobile.third.login.alipay;

import android.app.Activity;
import android.support.annotation.NonNull;
import android.text.TextUtils;

import com.alipay.sdk.app.AuthTask;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.AlipayAuth;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.third.login.ThirdPartyView;
import com.ocj.oms.mobile.third.login.alipay.entery.AuthResult;

import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * Created by admin-ocj on 2017/5/2.
 */

public class AlipayBusinessPresenterImpl implements AlipayBusinessContract.AlipayBusinessPresenter {
    private Activity mContext;
    private AlipayBusinessContract.AlipayLoginView alipayLoginView;
    private ThirdPartyView thirdPartyView;

    public AlipayBusinessPresenterImpl(Activity context, AlipayBusinessContract.AlipayLoginView alipayLoginView) {
        this(context, alipayLoginView, null);
    }


    public AlipayBusinessPresenterImpl(Activity context, ThirdPartyView thirdPartyView) {
        this(context, null, thirdPartyView);
    }

    public AlipayBusinessPresenterImpl(Activity context, AlipayBusinessContract.AlipayLoginView alipayLoginView, ThirdPartyView thirdPartyView) {
        this.mContext = context;
        this.alipayLoginView = alipayLoginView;
        this.thirdPartyView = thirdPartyView;
    }

    @Override
    public void alipayLogin() {
        new AccountMode(mContext).alipayLoginSecret()
                .subscribeOn(Schedulers.newThread())
                .map(new Function<ApiResult<AlipayAuth>, String>() {
                    @Override
                    public String apply(@io.reactivex.annotations.NonNull ApiResult<AlipayAuth> alipayAuthApiResult) throws Exception {
                        return alipayAuthApiResult.getData().getRedirectURL();
                    }
                })
                .map(new Function<String, AuthResult>() {
                    @Override
                    public AuthResult apply(@NonNull String authInfo) throws Exception {
                        AuthTask authTask = new AuthTask(mContext);
                        return new AuthResult(authTask.authV2(authInfo, true), true);
                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<AuthResult>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                    }

                    @Override
                    public void onError(Throwable e) {
                        if (thirdPartyView != null) {
                            thirdPartyView.alipayLoginFail(null);
                        } else if (alipayLoginView != null) {
                            alipayLoginView.alipayLoginFail(null);
                        }
                    }

                    @Override
                    public void onNext(AuthResult authResult) {
                        // 判断resultStatus 为“9000”且result_code
                        // 为“200”则代表授权成功，具体状态码代表含义可参考授权接口文档
                        if (authResult != null) {

                        }
                        if (TextUtils.equals(authResult.getResultStatus(), "9000") && TextUtils.equals(authResult.getResultCode(), "200")) {
                            if (thirdPartyView != null) {
                                thirdPartyView.alipayLoginSuccess(authResult);
                            } else if (alipayLoginView != null) {
                                alipayLoginView.alipayLoginSuccess(authResult);
                            }
                        } else {
                            // 其他状态值则为授权失败
                            if (thirdPartyView != null) {
                                thirdPartyView.alipayLoginFail(authResult);
                            } else if (alipayLoginView != null) {
                                alipayLoginView.alipayLoginFail(authResult);
                            }
                        }

                    }


                    @Override
                    public void onComplete() {
                    }
                });
    }
}
