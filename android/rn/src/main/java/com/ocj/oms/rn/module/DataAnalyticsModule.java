package com.ocj.oms.rn.module;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by apple on 2017/5/22.
 */

public class DataAnalyticsModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext mContext;
    public DataAnalyticsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
    }

    @Override
    public String getName() {
        return "DataAnalyticsModule";
    }

    @ReactMethod
    public void trackEvent(String eventId){
        OcjStoreDataAnalytics.trackEvent(mContext,eventId);
    }

    @ReactMethod
    public void trackEvent2(String eventId, String eventLabel){
        OcjStoreDataAnalytics.trackEvent(mContext,eventId,eventLabel);
    }

    @ReactMethod
    public void trackEvent3(String eventId, String eventLabel, ReadableMap parameters){
        Map<String, Object> mapParams = null;
        if (parameters != null) {
            mapParams = new HashMap<String,Object>();
            ReadableMapKeySetIterator iterator = parameters.keySetIterator();

            while (iterator.hasNextKey()) {
                String key = iterator.nextKey();
                String value = parameters.getString(key);
                mapParams.put(key,value);
            }
        }

        OcjStoreDataAnalytics.trackEvent(mContext,eventId,eventLabel, mapParams);
    }

    @ReactMethod
    public void trackPageBegin(String pageName){
        OcjStoreDataAnalytics.trackPageBegin(mContext,pageName);
    }

    @ReactMethod
    public void trackPageEnd(String pageName){
        OcjStoreDataAnalytics.trackPageEnd(mContext,pageName);
    }
}
