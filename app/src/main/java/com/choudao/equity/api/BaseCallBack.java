package com.choudao.equity.api;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Iterator;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by liuzhao on 16/7/12.
 */

public abstract class BaseCallBack<T> implements Callback<T> {
    @Override
    public void onResponse(Call<T> call, Response<T> response) {
        try {
            if (response.code() != 200) {
                String msg = "";
                if (response.code() == 401) {
                    msg = "当前未登录,点击跳转登陆界面";
                } else if (response.code() == 500) {
                    msg = "服务器异常";
                } else if (response.code() == 492) {
                    try {
                        JSONObject msgObject = new JSONObject(response.errorBody().string());
                        JSONObject jsonObject = new JSONObject(msgObject.getString("message"));
                        Iterator<String> iterator = jsonObject.keys();
                        msg = jsonObject.getString(iterator.next());
                    } catch (JSONException e) {
                        e.printStackTrace();
                        msg = "未知错误!";
                    }
                } else if (response.code() == 404) {
                    msg = "获取数据失败,请稍后重试";
                } else if (response.code() == 304) {
                    onSuccess(response.body());
                    return;
                } else {
                    msg = "未知错误,请稍后重试";
                }
                onFailure(response.code(), msg);
            } else {
                onSuccess(response.body());
            }
        } catch (IOException e) {
            onFailure(99, "未知异常");
        } finally {
            onFinish();
        }
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
