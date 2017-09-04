package com.ocj.oms.mobile.http.service.wallet;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.DepositList;
import com.ocj.oms.mobile.bean.ElectronBean;
import com.ocj.oms.mobile.bean.GiftCardList;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.bean.OcouponsList;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.ResultStr;
import com.ocj.oms.mobile.bean.SaveamtList;
import com.ocj.oms.mobile.bean.TaoVocherList;
import com.ocj.oms.mobile.bean.VocherList;

import java.util.List;
import java.util.Map;

import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * Created by liu on 2017/5/19.
 */

public interface WalletService {


    /**
     * API.02.06.002 鸥点明细查询接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/opoints/details")
    Observable<ApiResult<OcouponsList>> getOpointsDetails(@Body Map<String, String> params);


    /**
     * API.02.06.005鸥点余额查询接口
     */
    @GET("/api/members/opoints/leftsaveamt")
    Observable<ApiResult<Num>> getOpointsLeftSaveamt();


    /**
     * API.07.01.002积分余额查询接口
     */
    @GET("/api/finances/saveamts/leftsaveamt")
    Observable<ApiResult<Num>> getSaveamtsLeftSaveamt();

    /**
     * API.07.01.002 积分详情列表
     */
    @GET("/api/finances/saveamts/details")
    Observable<ApiResult<SaveamtList>> getSaveamtsDetails(@Query(value = "page") int page, @Query(value = "type") int type);

    /**
     * API.07.10.001礼券兑换积分接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/finances/gifttickets/exchange")
    Observable<ApiResult<Object>> voucherExchange(@Body Map<String, String> params);

    /**
     * API.07.05.001预付款明细查询接口
     */
    @GET("/api/finances/deposits/details")
    Observable<ApiResult<DepositList>> getDepositsDetails(@Query(value = "page") int page, @Query(value = "type") String type);

    /**
     * 2.4	API.07.05.002预付款余额查询接口
     */
    @GET("/api/finances/deposits/leftdeposit")
    Observable<ApiResult<Num>> getLeftDeposit();


    /**
     * API.07.08.001 查询抵用券明细
     */
    @GET("/api/finances/coupons/details")
    Observable<ApiResult<Object>> getVocherDetail(@QueryMap Map<String, String> params);


    /**
     * API.07.09.001礼包明细查询接口
     */
    @GET("/api/finances/giftcards/details")
    Observable<ApiResult<GiftCardList>> getGiftcardsDetail(@QueryMap Map<String, String> params);


    /**
     * API.07.09.004 礼包充值
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/finances/giftcards/exchange")
    Observable<ApiResult<ResultStr>> giftcardsRecharge(@Body Map<String, String> params);


    /**
     * API.07.09.003  礼包余额查询
     */
    @GET("/api/finances/giftcards/leftgiftcard")
    Observable<ApiResult<Num>> qurreBallance(@QueryMap Map<String, String> params);


    /**
     * API.07.09.002 余额查询
     */
    @GET("/api/finances/giftcards/left_exchange_amt")
    Observable<ApiResult<Num>> qurreGiftCardBallance(@QueryMap Map<String, String> params);


    /**
     * API.07.08.002 抵用券计数查询接口
     */
    @GET("/api/finances/coupons/leftCustCoupon")
    Observable<ApiResult<Num>> getVocherCount(@QueryMap Map<String, String> params);

    /**
     * API.07.08.001 抵用券明细查询
     */
    @GET("/api/finances/coupons/details")
    Observable<ApiResult<VocherList>> getVocherList(@QueryMap Map<String, Object> params);

    /**
     * API.07.08.003 抵用券领取
     */

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/finances/coupons/drawcoupon")
    Observable<ApiResult<Result<String>>> drawcoupon(@Body Map<String, String> params);

    /**
     * 2.13	API.07.11.001淘券明细查询接口
     */
    @GET("/api/finances/taocoupons/details")
    Observable<ApiResult<TaoVocherList>> getTaoVocherList(@Query(value = "page") int page);


    /**
     * 2.15	API.07.11.004淘券领取接口
     */

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/finances/taocoupons/drawcoupon")
    Observable<ApiResult<Result<String>>> taoDrawcoupon(@Body Map<String, String> params);


    /**
     * 2.15	API.07.11.003 淘券兑换接口
     */

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/finances/taocoupons/exchange")
    Observable<ApiResult<Result<String>>> taoExchange(@Body Map<String, String> params);


    /**
     * 礼包列表
     */
    @Headers({
            "Content-type: application/json"
    })
    @GET("/api/finances/electroncards/getelectronlist")
    Observable<ApiResult<Result<List<ElectronBean>>>> getElectronList();


}
