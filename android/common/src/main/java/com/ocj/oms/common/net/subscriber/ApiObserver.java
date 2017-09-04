package com.ocj.oms.common.net.subscriber;

import android.accounts.NetworkErrorException;
import android.content.Context;

import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiCode;
import com.ocj.oms.utils.assist.Network;

import java.lang.ref.WeakReference;

import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;


/**
 * @Description: API统一订阅者，采用弱引用管理上下文，防止内存泄漏
 * @author: jeasinlee
 * @date: 2017-01-03 14:07
 */
public abstract class ApiObserver<T> implements Observer<T> {
    public WeakReference<Context> contextWeakReference;

    public ApiObserver(Context context) {
        contextWeakReference = new WeakReference<Context>(context);
    }

    @Override
    public void onError(Throwable e) {
        if (e instanceof ApiException) {
            onError((ApiException) e);
        } else {
            onError(ApiException.handleException(e));
        }
    }


    @Override
    public void onSubscribe(Disposable d) {
        if (!Network.isConnected(contextWeakReference.get())) {
            onError(new ApiException(new NetworkErrorException(), ApiCode.Request.NETWORK_ERROR));
        }
    }


    @Override
    public void onComplete() {

    }
    public abstract void onError(ApiException e);
}
