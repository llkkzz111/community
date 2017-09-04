package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/5/24.
 */

public class DepositList {
    private String use_pb_deposit;
    private List<DepositBean> myPrepayList;
    private int maxPage;


    public String getUse_pb_deposit() {
        return use_pb_deposit;
    }

    public void setUse_pb_deposit(String use_pb_deposit) {
        this.use_pb_deposit = use_pb_deposit;
    }

    public List<DepositBean> getMyPrepayList() {
        return myPrepayList;
    }

    public void setMyPrepayList(List<DepositBean> myPrepayList) {
        this.myPrepayList = myPrepayList;
    }

    public int getMaxPage() {
        return maxPage;
    }

    public void setMaxPage(int maxPage) {
        this.maxPage = maxPage;
    }


}
