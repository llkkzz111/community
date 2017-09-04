package com.ocj.store.OcjStoreDataAnalytics;


/**
 * Created by apple on 2017/5/18.
 */
//页面数据类，记录页面日志
public class OcjTrackPageData extends OcjTrackData {
    //页面id，start和end传递的pageName需要相同
    private String pageId;
    //页面进入时间
    private long pageStartTime;
    //离开页面时间
    private long pageEndTime;

    public String getPageId() {
        return pageId;
    }

    public void setPageId(String pageId) {
        this.pageId = pageId;
    }

    public long getStartTime() {
        return pageStartTime;
    }

    public void setStartTime(long startTime) {
        this.pageStartTime = startTime;
    }

    public long getEndTime() {
        return pageEndTime;
    }

    public void setEndTime(long endTime) {
        this.pageEndTime = endTime;
    }
}
