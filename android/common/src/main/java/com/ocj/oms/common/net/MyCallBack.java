package com.ocj.oms.common.net;




import com.ocj.oms.common.net.mode.ApiResult;

import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by liuzhao on 16/7/6.
 */

public abstract class MyCallBack<S> extends BaseCallBack<ApiResult<S>> {

    @Override
    public void onResponse(Call<ApiResult<S>> call, Response<ApiResult<S>> response) {
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
    public void onFailure(Call<ApiResult<S>> call, Throwable t) {
        super.onFailure(call, t);
    }

    @Override
    public void onSuccess(ApiResult<S> response) {
        super.onSuccess(response);
    }

    @Override
    public void onFailure(int code, String msg) {
        super.onFailure(code, msg);
    }
}