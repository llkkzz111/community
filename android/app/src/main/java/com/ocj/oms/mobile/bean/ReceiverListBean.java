package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/5/26.
 */

public class ReceiverListBean {

    private String receiverType;
    private String cust_no;
    private List<ReceiversBean> receivers;

    public String getReceiverType() {
        return receiverType;
    }

    public void setReceiverType(String receiverType) {
        this.receiverType = receiverType;
    }

    public String getCust_no() {
        return cust_no;
    }

    public void setCust_no(String cust_no) {
        this.cust_no = cust_no;
    }

    public List<ReceiversBean> getReceivers() {
        return receivers;
    }

    public void setReceivers(List<ReceiversBean> receivers) {
        this.receivers = receivers;
    }
}
