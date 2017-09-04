package com.ocj.oms.mobile.http.service.address;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.ReceiverListBean;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.bean.Result;

import java.util.Map;

import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;

/**
 * Created by liu on 2017/5/26.
 */

public interface AddressService {


    /**
     * 2.16	API.02.01.016会员地址查询接口
     */
    @GET("/api/members/members/check_address")
    Observable<ApiResult<ReceiverListBean>> getReceiverList();

    /**
     * 2.10	API.02.01.010 添加地址接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/new_address")
    Observable<ApiResult<ReceiversBean>> addReceiver(@Body Map<String, String> params);

    /**
     * 2.12	API.02.01.012 修改地址接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_address")
    Observable<ApiResult<ReceiversBean>> editReceiver(@Body Map<String, String> params);

    /**
     * 2.13	API.02.01.013删除地址接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/delete_address")
    Observable<ApiResult<Result<String>>> deleteReceiver(@Body Map<String, String> params);

    /**
     * 2.11	API.02.01.011 设定默认地址接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/default_address")
    Observable<ApiResult<Result<String>>> defaultReceiver(@Body Map<String, String> params);

}
