package com.ocj.oms.common.net.callback;

import com.ocj.oms.common.net.mode.ApiResult;

import io.reactivex.Observable;

/**
 * Created by liu on 2017/5/5.
 */

public abstract class ApiObservable<T> extends Observable<ApiResult<T>> {
}
