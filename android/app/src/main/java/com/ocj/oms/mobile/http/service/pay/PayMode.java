package com.ocj.oms.mobile.http.service.pay;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.ServiceGenerator;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.bean.OrderBean;
import com.ocj.oms.mobile.bean.OrderStatusBean;
import com.ocj.oms.mobile.bean.Result;

import java.util.HashMap;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liu on 2017/5/8.
 */

public class PayMode extends BaseModel {

    public PayMode(Context context) {
        super(context);
    }


    /**
     * 获取银联支付PN
     *
     * @param mObservable
     */
    public void getUnionPayTN(ApiObserver<String> mObservable) {
        PayService apiService = createService(PayService.class);
        Observable<String> observable = apiService.getUnionPayTN();
        subscribe(observable, mObservable);
    }


    public void getWexinPreId(String params, ApiObserver<String> mObservable) {
        PayService apiService = createService(PayService.class);
        Observable<String> observable = apiService.getWXunifiedorder(params);
        subscribe(observable, mObservable);
    }

    /**
     * 3.16	API 03.06.008订单写入成功之后、立即支付
     *
     * @param orderNo
     * @param mObservable
     */
    public void getOrderDetail(String orderNo, ApiResultObserver<OrderBean> mObservable) {
        Map<String, String> params = new HashMap<>();
        params.put("order_no", orderNo);
        Observable observable = ServiceGenerator.createService(PayService.class).getOrderDetail(params);
        subscribe(observable, mObservable);
    }

    /**
     * 2.1	API.04.01.001 支付中心接口
     *
     * @param params
     * @param mObservable
     */
    public void payCenter(Map<String, String> params, ApiResultObserver<Result<String>> mObservable) {
        Observable observable = ServiceGenerator.createService(PayService.class).payCenter(params);
        subscribe(observable, mObservable);
    }

    /**
     * 2.1	API.04.01.001 支付中心接口
     *  @param url
     * @param mObservable
     */
    public void payCenter(String url, Observer<String> mObservable) {
        Observable observable = ServiceGenerator.createService(PayService.class).otherPayResult(url);
        subscribe(observable, mObservable);
    }

    /**
     * 3.2API.04.01.002 支付状态判断接口
     * @param params
     */
    public void orderPayStatus(Map<String, String> params,ApiResultObserver<OrderStatusBean> mObservable){
        Observable observable = ServiceGenerator.createService(PayService.class).orderPayStatus(params);
        subscribe(observable, mObservable);
    }

}
