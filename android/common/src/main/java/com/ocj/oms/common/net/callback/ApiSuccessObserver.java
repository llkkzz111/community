package com.ocj.oms.common.net.callback;

import android.content.Context;

import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;

/**
 * Created by liu on 2017/5/5.
 */

public abstract class ApiSuccessObserver<T> extends ApiResultObserver<T> {

    public ApiSuccessObserver(Context context) {
        super(context);
    }

    @Override
    public void onNext(ApiResult<T> apiResult) {
        onSuccess(apiResult.getData());
    }

    @Override
    public void onError(ApiException e) {

    }

    public abstract void onSuccess(T apiResult);

    @Override
    public void onComplete() {

    }
}

