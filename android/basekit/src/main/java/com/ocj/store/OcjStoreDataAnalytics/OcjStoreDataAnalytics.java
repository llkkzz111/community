package com.ocj.store.OcjStoreDataAnalytics;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.ocj.oms.utils.OCJPreferencesUtils;
import com.tendcloud.tenddata.TCAgent;


import java.util.HashMap;
import java.util.Map;

/**
 * Created by apple on 2017/5/16.
 */

public class OcjStoreDataAnalytics {
    private static String TAG = "OcjStoreDataAnalytics";
    public static final int DataAnalyticsTalkingdata = 1;
    public static final int DataAnalyticsOcj = 4;

    //Talkingdata appKey，这个在正式版本中需要替换成真实的数据
    private static String SDK_APP_KEY_Talkingdata = "C613ACBF3972802A2000152A7AAAAAAA";

    //当前使用的sdk类型，可传入多个按位与操作的值
    private int sdkType = 0;
    //ocj数据处理对象，初始化时创建
    private static OcjStoreDataAnalytics mInstance;
    //ocj数据处理类
    private OcjStoreDataCenter ocjStoreDataCenter;

    /*
    初始化数据分析平台
    application：传入app的application对象
    sdkType：传入所要使用的数据分析平台，按位判断
     */
    public static void init(Application application, int sdkType, String channleId) {
        if (!checkNotNull()) return;
        mInstance = new OcjStoreDataAnalytics();
        mInstance.sdkType = sdkType;
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            TCAgent.LOG_ON = true;
            TCAgent.init(application, SDK_APP_KEY_Talkingdata, channleId);
            TCAgent.setReportUncaughtExceptions(true);

        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter = new OcjStoreDataCenter();
            mInstance.ocjStoreDataCenter.init(application.getApplicationContext());
        }

        Log.i(TAG, "OcjStoreDataAnalytics init complete...");
    }

    //********************重要：在RN中似乎不支持多态，所以封装RN接口时将两个参数的接口封装成了trackEvent2，将三个参数的接口封装成了trackEvent3
    public static void trackEvent(Context context, String eventId) {
        if (checkNotNull()) return;
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            Map<String, String> map = new HashMap<>();
            map.put("accessToken", OCJPreferencesUtils.getAccessToken());
            map.put("custNo", OCJPreferencesUtils.getCustNo());
            TCAgent.onEvent(context, eventId, "", map);
        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter.trackEvent(context, eventId);
        }
    }


    public static void trackEvent(Context context, String eventId, String eventLabel) {
        if (checkNotNull()) return;
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            Map<String, String> map = new HashMap<>();
            map.put("accessToken", OCJPreferencesUtils.getAccessToken());
            map.put("custNo", OCJPreferencesUtils.getCustNo());
            TCAgent.onEvent(context, eventId, eventLabel);
        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter.trackEvent(context, eventId, eventLabel);
        }
    }

    //记录自定义统计信息，单次调用的参数数量不能超过10个，key、value只支持NSString，在TalkingData中，label字段也传入eventId
    //********************重要：在RN中似乎不支持多态，所以封装RN接口时将两个参数的接口封装成了trackEvent2，将三个参数的接口封装成了trackEvent3
    public static void trackEvent(Context context, String eventId, String eventLabel, Map<String, Object> parameters) {
        if (checkNotNull()) return;
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            parameters.put("accessToken", OCJPreferencesUtils.getAccessToken());
            parameters.put("custNo", OCJPreferencesUtils.getCustNo());
            TCAgent.onEvent(context, eventId, eventLabel, parameters);
        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter.trackEvent(context, eventId, eventLabel, parameters);
        }
    }

    //开始跟踪某一页面（可选），记录页面打开时间，建议在viewWillAppear或者viewDidAppear方法里调用
    public static void trackPageBegin(Context context, String pageName) {
        if (checkNotNull()) return;
        trackEvent(context, pageName);
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            TCAgent.onPageStart(context, pageName);
        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter.trackPageBegin(context, pageName);
        }
    }


    //结束某一页面的跟踪（可选），记录页面的关闭时间
    //此方法与trackPageBegin方法结对使用，
    //跟trackPageBegin方法的页面名称保持一致
    public static void trackPageEnd(Context context, String pageName) {
        if (checkNotNull()) return;
        if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata) {
            TCAgent.onPageEnd(context, pageName);
        }

        if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj) {
            mInstance.ocjStoreDataCenter.trackPageEnd(context, pageName);
        }
    }

    private static boolean checkNotNull() {
        if (mInstance == null) {
            Log.e(TAG, "OcjStoreDataAnalytics init have not been called...");
            return true;
        }
        return false;
    }
}
