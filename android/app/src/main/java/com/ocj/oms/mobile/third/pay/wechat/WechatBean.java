package com.ocj.oms.mobile.third.pay.wechat;

/**
 * Created by liuzhao on 2017/6/5.
 */

public class WechatBean {

    String appid;
    String timestamp;
    String payseq;
    String partnerid;
    String prepayid;
    String noncestr;
    String packageValue;
    String sign;
    String order_no;

    public String getPayseq() {
        return payseq;
    }

    public void setPayseq(String payseq) {
        this.payseq = payseq;
    }

    public String getPartnerid() {
        return partnerid;
    }

    public void setPartnerid(String partnerid) {
        this.partnerid = partnerid;
    }

    public String getPrepayid() {
        return prepayid;
    }

    public void setPrepayid(String prepayid) {
        this.prepayid = prepayid;
    }

    public String getNoncestr() {
        return noncestr;
    }

    public void setNoncestr(String noncestr) {
        this.noncestr = noncestr;
    }

    public String getAppid() {
        return appid;
    }

    public void setAppid(String appid) {
        this.appid = appid;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }


    public String getPackageValue() {
        return packageValue;
    }

    public void setPackageValue(String packageValue) {
        this.packageValue = packageValue;
    }

    public String getPaySign() {
        return sign;
    }

    public void setPaySign(String paySign) {
        this.sign = paySign;
    }

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }


}
