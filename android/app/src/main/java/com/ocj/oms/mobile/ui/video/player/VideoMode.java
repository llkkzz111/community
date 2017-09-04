package com.ocj.oms.mobile.ui.video.player;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ui.video.player.bean.BarrageUseableBean;

import java.util.Map;

import io.reactivex.Observable;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liuzhao on 2017/6/9.
 */

public class VideoMode extends BaseModel {

    private static final String TEST4SERVERADDRESS = "http://rm.ocj.com.cn";
    private static final String SERVERADDRESS = "http://m.ocj.com.cn";


    public static final String serverAddress = Constants.isDebug ? TEST4SERVERADDRESS : SERVERADDRESS;

    public static final String CHECKBARRAGETIME = serverAddress + "/restApi/checkTimes";//返回红包雨活动进行状态、倒计时等信息
    public static final String BARRAGERULEURL = serverAddress + "/eventbarragevideo/intf_rule?event_no=";//红包活动规则
    public static final String BARRAGEPRODUCTSURL = serverAddress + "/eventbarragevideo/intf_pdt?shop_no=";//红包推广商品链接
    public static final String BARRAGEURL = serverAddress + "/eventbarragevideo/intf_game?shop_no=%s&event_no=%s";//红包活动抽奖地址


    public VideoMode(Context context) {
        super(context);
    }


    /**
     * 检查红包倒计时
     *
     * @param mObservable
     */
    public void checkBarrageTime(Map<String,Object> params,ApiObserver<ApiResult<BarrageTimeBean>> mObservable) {
        VideoService apiService = createService(VideoService.class,serverAddress);
        Observable<ApiResult<BarrageTimeBean>> observable = apiService.checkBarrageTime(params);
        subscribe(observable, mObservable);
    }

    /**
     * 检查是否可以参加红包雨活动
     *
     * @param mObservable
     */
    public void checkBarrageUseable(Map<String,Object> params,ApiObserver<BarrageUseableBean> mObservable) {
        VideoService apiService = createService(VideoService.class,serverAddress);
        Observable<BarrageUseableBean> observable = apiService.checkBarrageUseable(params);
        subscribe(observable, mObservable);
    }



    /**
     * 获取直播信息列表
     *
     * @param mObservable
     */
    public void getLiveBasicInfo(Map<String,Object> params,ApiObserver<LiveBasicInfoBean> mObservable) {
        VideoService apiService = createService(VideoService.class,serverAddress);
        Observable<LiveBasicInfoBean> observable = apiService.getLiveBasicInfo(params);
        subscribe(observable, mObservable);
    }

}
