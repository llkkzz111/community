package com.ocj.store.OcjStoreDataAnalytics.net;

import com.ocj.store.OcjStoreDataAnalytics.base.OcjTrackData;

import java.util.Map;

/**
 * Created by apple on 2017/5/18.
 */

//事件数据类，记录一、二、三个参数的事件对象
public class OCJTrackEventData extends OcjTrackData {
    //事件id
    private String eventId;
    //label，用于两个和三个参数的事件
    private String eventLabel;
    //参数容器，用于三个参数的事件，最多可放10个参数
    private Map<String, Object> eventParams;
    //记录日志的时间
    private String eventTime;

    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getLabel() {
        return eventLabel;
    }

    public void setLabel(String label) {
        this.eventLabel = label;
    }

    public Map<String, Object> getParameters() {
        return eventParams;
    }

    public void setParameters(Map<String, Object> parameters) {
        this.eventParams = parameters;
    }
}
