package com.ocj.oms.common.net.callback;

import android.content.Context;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;

/**
 * Created by liu on 2017/5/5.
 */

public abstract class ApiResultObserver<T> extends ApiObserver<ApiResult<T>> {

    public ApiResultObserver(Context context) {
        super(context);
    }

    @Override
    public void onNext(ApiResult<T> apiResult) {
        onSuccess(apiResult.getData());
    }

    public abstract void onSuccess(T apiResult);

}

