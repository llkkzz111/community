package com.ocj.store.OcjStoreDataAnalytics.net;

import com.ocj.oms.common.net.mode.ApiResult;

import java.util.List;

import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

/**
 * Created by ocj on 2017/8/21.
 */

public interface PointService {

    /**
     * 提交退换货表单
     *
     * @return
     */
    @Headers({"Content-Type: application/json"})
    @POST("/analysis/click")
    Observable<ApiResult<String>> analysisClick(@Body List body);

}
