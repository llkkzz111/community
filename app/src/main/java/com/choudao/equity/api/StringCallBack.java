package com.choudao.equity.api;

import retrofit2.Call;

/**
 * Created by liuzhao on 16/7/12.
 */

public class StringCallBack extends BaseCallBack<String> {
    @Override
    protected void onSuccess(String body) {

    }

    @Override
    protected void onFailure(int code, String msg) {

    }

    @Override
    public void onFailure(Call<String> call, Throwable t) {

    }
}
