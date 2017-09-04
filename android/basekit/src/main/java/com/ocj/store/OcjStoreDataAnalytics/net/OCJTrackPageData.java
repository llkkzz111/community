package com.ocj.store.OcjStoreDataAnalytics.net;


import com.ocj.store.OcjStoreDataAnalytics.base.OcjTrackData;

/**
 * Created by apple on 2017/5/18.
 */
//页面数据类，记录页面日志
public class OCJTrackPageData extends OcjTrackData {
    //页面id，start和end传递的pageName需要相同
    private String pageId;
    //页面进入时间
    private String pageStartTime;
    //离开页面时间
    private String pageEndTime;

    public String getPageId() {
        return pageId;
    }

    public void setPageId(String pageId) {
        this.pageId = pageId;
    }

    public String getStartTime() {
        return pageStartTime;
    }

    public void setStartTime(String startTime) {
        this.pageStartTime = startTime;
    }

    public String getEndTime() {
        return pageEndTime;
    }

    public void setEndTime(String endTime) {
        this.pageEndTime = endTime;
    }
}
