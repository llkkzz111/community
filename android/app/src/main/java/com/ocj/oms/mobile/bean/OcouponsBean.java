package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/5/31.
 */

public class OcouponsBean {

    /**
     * expire_date : null
     * opoint_num : -10
     * insert_date : 2017-05-24
     * event_name : 活动
     * item_name : 鸥点抽奖
     */

    private Object expire_date;
    private String opoint_num;
    private String insert_date;
    private String event_name;
    private String item_name;

    public Object getExpire_date() {
        return expire_date;
    }

    public void setExpire_date(Object expire_date) {
        this.expire_date = expire_date;
    }

    public String getOpoint_num() {
        return opoint_num;
    }

    public void setOpoint_num(String opoint_num) {
        this.opoint_num = opoint_num;
    }

    public String getInsert_date() {
        return insert_date;
    }

    public void setInsert_date(String insert_date) {
        this.insert_date = insert_date;
    }

    public String getEvent_name() {
        return event_name;
    }

    public void setEvent_name(String event_name) {
        this.event_name = event_name;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }
}
