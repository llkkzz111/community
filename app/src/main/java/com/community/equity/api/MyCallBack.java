package com.community.equity.api;


import com.community.equity.base.BaseApiResponse;

import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by liuzhao on 16/7/6.
 */

public abstract class MyCallBack<S> extends BaseCallBack<BaseApiResponse<S>> {

    @Override
    public void onResponse(Call<BaseApiResponse<S>> call, Response<BaseApiResponse<S>> response) {
        super.onResponse(call, response);
    }

    /**
     * UnknownHostException
     * ConnectException
     * socket time out
     *
     * @param call
     * @param t
     */
    @Override
    public void onFailure(Call<BaseApiResponse<S>> call, Throwable t) {
        super.onFailure(call, t);
    }

    @Override
    public void onSuccess(BaseApiResponse<S> response) {
        super.onSuccess(response);
    }

    @Override
    public void onFailure(int code, String msg) {
        super.onFailure(code, msg);
    }
}