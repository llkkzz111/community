package com.ocj.oms.mobile.http.service.address;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.ReceiverListBean;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.bean.Result;

import java.util.Map;

import io.reactivex.Observable;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liu on 2017/5/26.
 */

public class AddressModel extends BaseModel {

    public AddressModel(Context context) {
        super(context);
    }

    /**
     * 2.16	API.02.01.016会员地址查询接口
     *
     * @param apiResultObserver
     */
    public void getReceiverList(ApiResultObserver<ReceiverListBean> apiResultObserver) {
        AddressService apiService = createService(AddressService.class);
        Observable<ApiResult<ReceiverListBean>> observable = apiService.getReceiverList();
        subscribe(observable, apiResultObserver);
    }

    /**
     * 2.10	API.02.01.010 添加地址接口
     *
     * @param params
     * @param apiResultObserver
     */
    public void addReceiver(Map<String, String> params, ApiResultObserver<ReceiversBean> apiResultObserver) {
        AddressService apiService = createService(AddressService.class);
        Observable<ApiResult<ReceiversBean>> observable = apiService.addReceiver(params);
        subscribe(observable, apiResultObserver);
    }

    /**
     * 2.12	API.02.01.012 修改地址接口
     *
     * @param params
     * @param apiResultObserver
     */
    public void editReceiver(Map<String, String> params, ApiResultObserver<ReceiversBean> apiResultObserver) {
        AddressService apiService = createService(AddressService.class);
        Observable<ApiResult<ReceiversBean>> observable = apiService.editReceiver(params);
        subscribe(observable, apiResultObserver);
    }

    /**
     * 2.12	API.02.01.013 删除地址接口
     *
     * @param params
     * @param apiResultObserver
     */
    public void deleteReceiver(Map<String, String> params, ApiResultObserver<Result<String>> apiResultObserver) {
        AddressService apiService = createService(AddressService.class);
        Observable<ApiResult<Result<String>>> observable = apiService.deleteReceiver(params);
        subscribe(observable, apiResultObserver);
    }

    /**
     * 2.11	API.02.01.011 设定默认地址接口
     *
     * @param params
     * @param apiResultObserver
     */
    public void defaultReceiver(Map<String, String> params, ApiResultObserver<Result<String>> apiResultObserver) {
        AddressService apiService = createService(AddressService.class);
        Observable<ApiResult<Result<String>>> observable = apiService.defaultReceiver(params);
        subscribe(observable, apiResultObserver);
    }


}
