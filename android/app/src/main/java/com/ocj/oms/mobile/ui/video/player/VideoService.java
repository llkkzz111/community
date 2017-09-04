package com.ocj.oms.mobile.ui.video.player;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.ui.video.player.bean.BarrageUseableBean;

import java.util.Map;

import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 2017/6/9.
 */

public interface VideoService {

    /**
     * 检查红包倒计时
     *
     * @param
     * @return
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/restApi/checkTimes")
    Observable<ApiResult<BarrageTimeBean>> checkBarrageTime(@Body Map<String, Object> params);

    /**
     * 检查是否可以参加红包雨活动
     * @param params
     * @return
     */
    @GET("/eventbarragevideo/intf_check")
    Observable<BarrageUseableBean> checkBarrageUseable(@QueryMap Map<String, Object> params);

    /**
     *
     * @param params
     * @return
     */
    @GET("/eventbarragevideo/intf_main")
    Observable<LiveBasicInfoBean> getLiveBasicInfo(@QueryMap Map<String, Object> params);
}
