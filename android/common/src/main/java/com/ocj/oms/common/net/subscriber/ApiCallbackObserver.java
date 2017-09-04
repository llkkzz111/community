package com.ocj.oms.common.net.subscriber;

import android.content.Context;

import com.ocj.oms.common.net.callback.ApiCallback;
import com.ocj.oms.common.net.exception.ApiException;

import io.reactivex.disposables.Disposable;


/**
 * @Description: 包含回调的订阅者，如果订阅这个，上层在不使用订阅者的情况下可获得回调
 * @author: jeasinlee
 * @date: 2017-01-05 09:35
 */
public class ApiCallbackObserver<T> extends ApiObserver<T> {

    protected ApiCallback<T> callBack;

    public ApiCallbackObserver(Context context, ApiCallback<T> callBack) {
        super(context);
        if (callBack == null) {
            throw new NullPointerException("this callback is null!");
        }
        this.callBack = callBack;
    }


    @Override
    public void onSubscribe(Disposable d) {
        callBack.onSubscribe();
    }

    @Override
    public void onError(ApiException e) {
        callBack.onError(e);
    }


    @Override
    public void onNext(T t) {
        callBack.onNext(t);
    }

    @Override
    public void onComplete() {
        callBack.onCompleted();
    }
}
