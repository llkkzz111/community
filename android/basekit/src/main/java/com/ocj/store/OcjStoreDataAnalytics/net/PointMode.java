package com.ocj.store.OcjStoreDataAnalytics.net;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.mode.ApiResult;

import java.util.List;

import io.reactivex.Observable;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by ocj on 2017/8/21.
 */

public class PointMode extends BaseModel {
    public PointMode(Context context) {
        super(context);
    }

    /**
     * 埋点上报
     */
    public Observable<ApiResult<String>> analysisClick(List body) {
        PointService apiService = createService(PointService.class);
        return apiService.analysisClick(body);
    }


}
