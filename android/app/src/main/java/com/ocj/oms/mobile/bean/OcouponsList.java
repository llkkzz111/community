package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/5/31.
 */

public class OcouponsList {

    /**
     * month : 3
     * totalPage : 4
     * opointList : [{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"},{"expire_date":null,"opoint_num":"-10","insert_date":"2017-05-24","event_name":"活动","item_name":"鸥点抽奖"}]
     * page : 1
     */

    private String month;
    private int totalPage;
    private int page;
    private List<OcouponsBean> opointList;

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public List<OcouponsBean> getOpointList() {
        return opointList;
    }

    public void setOpointList(List<OcouponsBean> opointList) {
        this.opointList = opointList;
    }
}
