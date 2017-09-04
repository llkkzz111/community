package com.ocj.oms.common.net;

import android.text.TextUtils;

import com.facebook.stetho.okhttp3.StethoInterceptor;
import com.ocj.oms.common.net.convert.GsonConverterFactory;
import com.ocj.oms.common.net.mode.ApiHost;
import com.ocj.oms.utils.OCJPreferencesUtils;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;

/**
 * Created by liuzhao on 16/7/6.
 */

public class ServiceGenerator {
    static HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
    private static Retrofit.Builder builder =
            new Retrofit.Builder()
                    .baseUrl(ApiHost.API_HOST)
                    .addConverterFactory(GsonConverterFactory.create())
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create());

    public static <S> S createService(Class<S> serviceClass) {
        return createService(serviceClass, OCJPreferencesUtils.getAccessToken(),null);
    }

    public static <S> S createService(Class<S> serviceClass, final String baseUrl) {
        return createService(serviceClass, OCJPreferencesUtils.getAccessToken(), baseUrl);
    }

    public static <S> S createService(Class<S> serviceClass, final String authToken, String baseUrl) {
        OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        httpClient.interceptors().add(new Interceptor() {
            @Override
            public okhttp3.Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                Request.Builder requestBuilder = addHeader(original, authToken);
                Request request = requestBuilder.build();
                return chain.proceed(request);
            }
        });
        httpClient.connectTimeout(20, TimeUnit.SECONDS);
        httpClient.writeTimeout(20, TimeUnit.SECONDS);
        httpClient.readTimeout(20, TimeUnit.SECONDS);
        httpClient.addNetworkInterceptor(new StethoInterceptor());
        httpClient.addInterceptor(interceptor.setLevel(HttpLoggingInterceptor.Level.BODY));
        if (baseUrl == null || TextUtils.isEmpty(baseUrl)) {
            builder.baseUrl(ApiHost.API_HOST).client(httpClient.build());
        } else {
            builder.baseUrl(baseUrl).client(httpClient.build());
        }
        return builder.build().create(serviceClass);
    }

    private static Request.Builder addHeader(Request original, String authToken) {
        return original.newBuilder()
                .header("x-access-token", authToken)
                .header("X-device-id", HeaderUtils.getDeviceId())
                .header("X-msale-way", HeaderUtils.getMsaleWay())
                .header("X-msale-code", HeaderUtils.getMsaleCode())
                .header("X-net-type", HeaderUtils.getNetWorkTypeName())
                .header("X-version-info", HeaderUtils.getVersionInfo())
                .header("X-region-cd", HeaderUtils.getRegionCd())
                .header("X-sel-region-cd", HeaderUtils.getSelReginCd())
                .header("X-substation-code", HeaderUtils.getSubstationCode())
                .header("X-jiguang-id", HeaderUtils.getJpushCode())
                .addHeader("Accept", HeaderUtils.getAccept())
                .addHeader("Content-type", HeaderUtils.getContentType())
                .method(original.method(), original.body());
    }
}
