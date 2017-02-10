package com.choudao.imsdk.http;

import com.choudao.imsdk.utils.ApiUtils;
import com.choudao.imsdk.utils.SharedPreferencesUtils;
import com.facebook.stetho.okhttp3.StethoInterceptor;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by liuzhao on 16/7/6.
 */

public class ServiceGenerator {

    private static Retrofit.Builder builder =
            new Retrofit.Builder()
                    .baseUrl(ApiUtils.BASE_HTTP_URL)
                    .addConverterFactory(GsonConverterFactory.create());

    public static <S> S createService(Class<S> serviceClass) {
        return createService(serviceClass, SharedPreferencesUtils.getTokenType() + " " + SharedPreferencesUtils.getAccessToken());
    }

    public static <S> S createService(Class<S> serviceClass, final String authToken) {
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        httpClient.interceptors().add(new Interceptor() {
            @Override
            public okhttp3.Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                Request.Builder requestBuilder = original.newBuilder()
                        .header("Authorization", authToken)
                        .addHeader("User-Agent", ApiUtils.USER_AGENT)
                        .method(original.method(), original.body());
                Request request = requestBuilder.build();
                return chain.proceed(request);
            }
        });
        httpClient.addNetworkInterceptor(new StethoInterceptor());
        builder.client(httpClient.build());
        return builder.build().create(serviceClass);
    }
}
