package com.ocj.oms.mobile.http.service.wallet;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.ParamKeys;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.reactivex.Observable;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liu on 2017/5/8.
 */

public class WalletMode extends BaseModel {

    public WalletMode(Context context) {
        super(context);
    }

    /**
     * API.02.06.002 鸥点明细查询接口
     *
     * @param params
     * @param mObservable
     */
    public void getOpointsDetails(Map<String, String> params, ApiResultObserver<OcouponsList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<OcouponsList>> observable = apiService.getOpointsDetails(params);
        subscribe(observable, mObservable);
    }


    /**
     * API.02.06.005鸥点余额查询接口
     *
     * @param mObservable
     */
    public void getOpointsLeftSaveamt(ApiResultObserver<Num> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.getOpointsLeftSaveamt();
        subscribe(observable, mObservable);
    }


    /**
     * API.07.01.001积分明细查询接口
     *
     * @param mObservable
     */
    public void getSaveamtsDetails(int page, int type, ApiResultObserver<SaveamtList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<SaveamtList>> observable = apiService.getSaveamtsDetails(page, type);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.01.002积分余额查询接口
     *
     * @param mObservable
     */
    public void getSaveamtsLeftSaveamt(ApiResultObserver<Num> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.getSaveamtsLeftSaveamt();
        subscribe(observable, mObservable);
    }

    /**
     * API.07.10.001礼券兑换积分接口
     *
     * @param mObservable
     */
    public void voucherExchange(Map<String, String> params, ApiResultObserver<Object> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Object>> observable = apiService.voucherExchange(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.05.001预付款明细查询接口
     *
     * @param mObservable
     */
    public void getDepositsDetails(int page, String type, ApiResultObserver<DepositList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<DepositList>> observable = apiService.getDepositsDetails(page, type);
        subscribe(observable, mObservable);
    }

    /**
     * * 2.4	API.07.05.002预付款余额查询接口
     *
     * @param mObservable
     */
    public void getLeftDeposit(ApiResultObserver<Num> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.getLeftDeposit();
        subscribe(observable, mObservable);
    }


    /**
     * API.07.09.001礼包明细查询接口
     *
     * @param mObservable
     */
    public void getGiftCardDetail(String type, int page, ApiResultObserver<GiftCardList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.TYPE, type);
        params.put(ParamKeys.PAGE, page + "");
        Observable<ApiResult<GiftCardList>> observable = apiService.getGiftcardsDetail(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.09.004礼包 充值（兑换）接口
     *
     * @param mObservable
     */
    public void giftCardRecharge(Map<String, String> params, ApiResultObserver<ResultStr> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<ResultStr>> observable = apiService.giftcardsRecharge(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.09.002 余额查询接口
     *
     * @param mObservable
     */
    public void querryBalance(ApiResultObserver<Num> mObservable) {
        Map<String, String> params = new HashMap<>();
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.qurreBallance(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.09.002 余额查询接口
     */
    public Observable<ApiResult<Num>> querryBalance(Map<String, String> params) {
        WalletService apiService = createService(WalletService.class);
        return apiService.qurreBallance(params);
    }

    /**
     * API.07.09.004礼包 充值（兑换）接口
     */
    public Observable<ApiResult<ResultStr>> giftCardRecharge(Map<String, String> params) {
        WalletService apiService = createService(WalletService.class);
        return apiService.giftcardsRecharge(params);
    }

    /**
     * API.07.09.003  礼包余额查询接口
     *
     * @param mObservable
     */
    public void querryGiftCardBalance(Map<String, String> params, ApiResultObserver<Num> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.qurreGiftCardBallance(params);
        subscribe(observable, mObservable);
    }


    /**
     * API.07.08.002  礼包余额查询接口
     *
     * @param mObservable
     */
    public void getVocherCount(Map<String, String> params, ApiResultObserver<Num> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Num>> observable = apiService.getVocherCount(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.08.001 抵用券明细列表查询
     */
    public void getVocherList(Map<String, Object> params, ApiResultObserver<VocherList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<VocherList>> observable = apiService.getVocherList(params);
        subscribe(observable, mObservable);
    }

    /**
     * API.07.08.003 抵用券领取
     */
    public void drawCoupon(Map<String, String> params, ApiResultObserver<Result<String>> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Result<String>>> observable = apiService.drawcoupon(params);
        subscribe(observable, mObservable);
    }

    /**
     * 2.13	API.07.11.001淘券明细查询接口
     */
    public void getTaoVocherList(int page, ApiResultObserver<TaoVocherList> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<TaoVocherList>> observable = apiService.getTaoVocherList(page);
        subscribe(observable, mObservable);
    }


    /**
     * 2.15	API.07.11.004淘券领取接口
     */
    public void taoDrawcoupon(Map<String, String> params, ApiResultObserver<Result<String>> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Result<String>>> observable = apiService.taoDrawcoupon(params);
        subscribe(observable, mObservable);
    }
    /**
     * 2.15	API.07.11.003 淘券兑换接口
     */
    public void taoExchange(Map<String, String> params, ApiResultObserver<Result<String>> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Result<String>>> observable = apiService.taoExchange(params);
        subscribe(observable, mObservable);
    }

    /**
     * 2.15	API.07.11.004淘券领取接口
     */
    public Observable<ApiResult<Result<String>>> taoDrawcoupon(Map<String, String> params) {
        WalletService apiService = createService(WalletService.class);
        return apiService.taoDrawcoupon(params);
    }


    /**
     * 2.13	API.07.11.001淘券明细查询接口
     */
    public Observable<ApiResult<TaoVocherList>> getTaoVocherList(int page) {
        WalletService apiService = createService(WalletService.class);
        return apiService.getTaoVocherList(page);
    }

    /**
     * 获取充值卡列表
     */
    public void getElectronList(ApiResultObserver<Result<List<ElectronBean>>> mObservable) {
        WalletService apiService = createService(WalletService.class);
        Observable<ApiResult<Result<List<ElectronBean>>>> observable = apiService.getElectronList();
        subscribe(observable, mObservable);
    }


}
