package com.ocj.store.OcjStoreDataAnalytics;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.store.OcjStoreDataAnalytics.base.OcjTrackData;
import com.ocj.store.OcjStoreDataAnalytics.db.DBTrackEventData;
import com.ocj.store.OcjStoreDataAnalytics.db.DBTrackPageData;
import com.ocj.store.OcjStoreDataAnalytics.db.DbFactory;
import com.ocj.store.OcjStoreDataAnalytics.db.DbOperator;
import com.ocj.store.OcjStoreDataAnalytics.net.OCJTrackEventData;
import com.ocj.store.OcjStoreDataAnalytics.net.OCJTrackPageData;
import com.ocj.store.OcjStoreDataAnalytics.net.PointMode;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;


/**
 * Created by apple on 2017/5/18.
 */

public class OcjStoreDataCenter {
    private static String TAG = "OcjStoreDataCenter";

    //定义达到多少条数据之后上传日志
    private final int MAX_CACHE_COUNT = 5;
    private final int MAX_COMMIT_COUNT = 10;
    //数据类型，分别对应着时间类型
    public static String OcjEventType_Event = "event";
    public static String OcjEventType_page = "page";
    //这个array用于存放将要存储到数据库中的数据，数据来源于trackDataArray
    private List<OcjTrackData> saveToDbTrackDataArray;
    private List<OcjTrackData> trackDataArray;
    //将数据从trackDataArray导入saveToDbTrackDataArray时使用的锁
    private Object objectTrackDataArray;
    //标识是否有上传任务，避免上传任务并发
    private boolean inProgress;
    private DbOperator dbOperator;
    private Context mContext = null;

    public void init(Context context) {
        this.mContext = context;
        if (trackDataArray == null) {
            trackDataArray = new ArrayList<>();
            saveToDbTrackDataArray = new ArrayList<>();
            objectTrackDataArray = new Object();
            inProgress = false;

            dbOperator = DbFactory.NewDbOperator(context);

        }
    }

    public void trackEvent(Context context, String eventId) {
        trackEvent(context, eventId, null);
    }

    public void trackEvent(Context context, String eventId, String eventLabel) {
        trackEvent(context, eventId, eventLabel, null);
    }

    public void trackEvent(Context context, String eventId, String eventLabel, Map<String, Object> parameters) {
        DBTrackEventData eventData = new DBTrackEventData();
        eventData.setSign(OcjEventType_Event);
        eventData.setEventId(eventId);
        eventData.setLabel(eventLabel);
        eventData.setParameters(parameters);
        eventData.setEventTime(current());
        Log.i(TAG, "trackEvent .");
        pushTrackData(eventData);
        trigerSaveDataToDb();
    }

    public void trackPageBegin(Context context, String pageName) {
        DBTrackPageData pageData = new DBTrackPageData();
        pageData.setSign(OcjEventType_page);
        pageData.setPageId(pageName);
        pageData.setStartTime(current());
        Log.i(TAG, "trackEvent page begin.");
        pushTrackData(pageData);
    }

    public void trackPageEnd(Context context, String pageName) {
        DBTrackPageData pageData = null;
        //在缓存中倒叙匹配进入页面的数据，匹配到之后这条页面记录就完整了，就可以进入数据库了
        for (int i = trackDataArray.size() - 1; i >= 0; i--) {
            OcjTrackData data = trackDataArray.get(i);
            if (TextUtils.equals(data.getSign(), OcjEventType_page) && ((DBTrackPageData) data).getPageId().equals(pageName) && ((DBTrackPageData) data).getEndTime() == 0) {
                ((DBTrackPageData) data).setEndTime(current());
                pageData = ((DBTrackPageData) data);
                Log.i(TAG, "trackEvent page end close.");
                break;
            }
        }
        Log.i(TAG, "trackEvent page end.");
        if (pageData != null) {
            trigerSaveDataToDb();
        }
    }

    //将数据存入array缓存
    private void pushTrackData(OcjTrackData data) {
        synchronized (objectTrackDataArray) {
            trackDataArray.add(data);
            Log.i(TAG, "sync pushTrackData ...");
        }
    }

    //开始向数据库中导入数据
    private void trigerSaveDataToDb() {
        Log.i(TAG, "start thread to trigerSaveDataToDb ...");
        //判断可以上传的数量
        int count = 0;
        for (OcjTrackData data : trackDataArray) {
            if (data.getSign() != OcjEventType_page) {
                count++;
            } else if (((DBTrackPageData) data).getEndTime() > 0) {
                count++;
            }
        }
        if (count >= MAX_CACHE_COUNT) {
            saveTrackDataToDb();
        }
    }

    //向数据库中导入数据
    private void saveTrackDataToDb() {
        long unsendTrackDataCount = 0;
        synchronized (objectTrackDataArray) {
            saveToDbTrackDataArray.clear();
            saveToDbTrackDataArray.addAll(trackDataArray);
            trackDataArray.clear();
            long timeOutValue = 30 * 60 * 1000;
            for (int i = saveToDbTrackDataArray.size() - 1; i >= 0; i--) {
                OcjTrackData data = saveToDbTrackDataArray.get(i);
                if (data.getSign() == OcjEventType_page) {
                    if (((DBTrackPageData) data).getEndTime() == 0) {
                        if (current() - ((DBTrackPageData) data).getStartTime() < timeOutValue) {
                            trackDataArray.add(0, data);
                        }
                        saveToDbTrackDataArray.remove(i);
                    }
                }
            }

            dbOperator.addTrackData(saveToDbTrackDataArray);
            Log.i(TAG, "saveTrackDataToDb ,then count=" + unsendTrackDataCount);
        }

        commitTrackData();
    }


    //同步数据到服务器
    private void commitTrackData() {
        if (!inProgress) {
            inProgress = true;
            List<OcjTrackData> DBTrackDataList = null;
            DBTrackDataList = dbOperator.getTrackDataToUpload();
            if (DBTrackDataList.size() < MAX_COMMIT_COUNT) {
                inProgress = false;
                return;
            }
            if (DBTrackDataList != null && DBTrackDataList.size() > 0) {

                List<OcjTrackData> OCJTrackDataList = new ArrayList<>();

                for (OcjTrackData ocjData : DBTrackDataList) {
                    if (TextUtils.equals("page", ocjData.getSign())) {
                        OCJTrackPageData data = new OCJTrackPageData();
                        data.setSign(ocjData.getSign());
                        data.setPageId(((DBTrackPageData) ocjData).getPageId());
                        data.setEndTime(((DBTrackPageData) ocjData).getEndTime() + "");
                        data.setStartTime(((DBTrackPageData) ocjData).getStartTime() + "");
                        OCJTrackDataList.add(data);
                    } else {
                        OCJTrackEventData data = new OCJTrackEventData();
                        data.setSign(ocjData.getSign());
                        data.setEventId(((DBTrackEventData) ocjData).getEventId());
                        data.setEventTime(((DBTrackEventData) ocjData).getEventTime() + "");
                        data.setLabel(((DBTrackEventData) ocjData).getLabel());
                        data.setParameters(((DBTrackEventData) ocjData).getParameters());
                        OCJTrackDataList.add(data);
                    }

                }

                new PointMode(mContext).analysisClick(OCJTrackDataList)
                        .subscribeOn(Schedulers.newThread())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new ApiObserver<ApiResult<String>>(mContext) {

                            @Override
                            public void onNext(ApiResult<String> apiResult) {
                                Log.e("analysisClick", apiResult.getMessage());
                                dbOperator.clearUploadTrackData();
                            }

                            @Override
                            public void onError(ApiException e) {
                                Log.e("analysisClick", e.getMessage());
                                dbOperator.resetUploadTrackData();
                            }

                        });


            }
            inProgress = false;
        }

    }


    //获取当前时间
    public long current() {
        return System.currentTimeMillis();
    }
}
