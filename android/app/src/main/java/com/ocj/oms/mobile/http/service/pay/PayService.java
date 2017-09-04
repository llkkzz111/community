package com.ocj.oms.mobile.http.service.pay;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.OrderBean;
import com.ocj.oms.mobile.bean.OrderStatusBean;
import com.ocj.oms.mobile.bean.Result;

import java.util.Map;

import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.QueryMap;

/**
 * Created by liu on 2017/5/8.
 */

public interface PayService {

    /**
     * 银联支付获取tn
     */
    @GET("http://101.231.204.84:8091/sim/getacptn")
    Observable<String> getUnionPayTN();

    /**
     * 获取微信支付订单号
     */
    @Headers({
            "Content-type: application/json",
            "Accept: application/json"
    })
    @POST("https://api.mch.weixin.qq.com/pay/unifiedorder")
    Observable<String> getWXunifiedorder(@Body String params);


    /**
     * 获取微信支付订单号
     */
    @Headers({
            "Content-type: application/json",
            "Accept: application/json"
    })
    @POST("https://api.mch.weixin.qq.com/pay/unifiedorder")
    Observable<String> getWXPayCommit(@Body String params);


    /**
     * 3.16	API 03.06.008订单写入成功之后、立即支付
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/orders/orders/ordersuccess")
    Observable<ApiResult<OrderBean>> getOrderDetail(@Body Map<String, String> params);

    /**
     * 2.1	API.04.01.001 支付中心接口
     */
    @GET("/api/pay/pay_center")
    Observable<ApiResult<Result<String>>> payCenter(@QueryMap Map<String, String> params);
    /**
     * 2.1	API.04.01.001 支付中心接口
     */
    @GET("{url}")
    Observable<String> otherPayResult(@Path(value = "url", encoded = true) String url);

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/pay/check_orderpaystatus")
    Observable<ApiResult<OrderStatusBean>> orderPayStatus(@Body Map<String, String> params);


}
