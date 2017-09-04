package com.ocj.oms.common.net;


import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by liuzhao on 16/7/12.
 */

public abstract class BaseCallBack<T> implements Callback<T> {
    @Override
    public void onResponse(Call<T> call, Response<T> response) {
        if (response.code() != 200) {
            String msg = "";

            onFailure(response.code(), msg);
        } else {
            onSuccess(response.body());
        }
        onFinish();
    }

    protected void onSuccess(T body) {
    }


    protected void onFailure(int code, String msg) {
    }

    /**
     * UnknownHostException
     * ConnectException
     *
     * @param call
     * @param t
     */
    @Override
    public void onFailure(Call<T> call, Throwable t) {
        if (t.toString().startsWith("java.net.UnknownHostException")) {
            onFailure(99, "操作失败，请重试或检查网络设置");
        } else if (t.toString().startsWith("java.net.SocketTimeoutException")) {
            onFailure(99, "请求超时，请重试或检查网络设置");
        } else if (t.toString().startsWith("java.net.ConnectException")) {
            onFailure(99, "网络连接异常，请检查网络设置");
        } else if (t.toString().startsWith("java.io.IOException")) {
            onFailure(999, "取消操作");
        } else if (t.toString().startsWith("com.google.gson.JsonSyntaxException")) {
            onFailure(998, "数据解析异常" + t.getMessage());
        } else if (t.toString().startsWith("java.lang.IllegalStateException")) {
            onFailure(997, "数据解析异常" + t.getMessage());
        } else {
            onFailure(99, "未知异常" + t.getMessage());
        }
        onFinish();
    }

    protected void onFinish() {

    }
}
