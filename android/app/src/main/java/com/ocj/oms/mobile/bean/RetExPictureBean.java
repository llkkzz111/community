package com.ocj.oms.mobile.bean;

import java.util.ArrayList;

/**
 * Created by xiao on 2017/8/23.
 */

public class RetExPictureBean {
    private String result;
    private ArrayList<String> REPictureList;
    private String orderNo;
    private String retItemCode;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public ArrayList<String> getREPictureList() {
        return REPictureList;
    }

    public void setREPictureList(ArrayList<String> REPictureList) {
        this.REPictureList = REPictureList;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getRetItemCode() {
        return retItemCode;
    }

    public void setRetItemCode(String retItemCode) {
        this.retItemCode = retItemCode;
    }
}
