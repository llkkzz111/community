package com.ocj.oms.mobile.bean;

import java.io.Serializable;

/**
 * Created by liutao on 2017/6/22.
 */

public class CouponListBean implements Serializable {
    /**
     * coupon_no : 0
     * coupon_note : A券
     * real_coupon_amt : 10
     * dc_gb : 10
     * coupon_seq : 000000003
     * dc_endDate :
     */

    private String coupon_no;
    private String coupon_note;
    private int real_coupon_amt;
    private String dc_gb;
    private String coupon_seq;
    private String dc_endDate;

    public String getCoupon_no() {
        return coupon_no;
    }

    public void setCoupon_no(String coupon_no) {
        this.coupon_no = coupon_no;
    }

    public String getCoupon_note() {
        return coupon_note;
    }

    public void setCoupon_note(String coupon_note) {
        this.coupon_note = coupon_note;
    }

    public int getReal_coupon_amt() {
        return real_coupon_amt;
    }

    public void setReal_coupon_amt(int real_coupon_amt) {
        this.real_coupon_amt = real_coupon_amt;
    }

    public String getDc_gb() {
        return dc_gb;
    }

    public void setDc_gb(String dc_gb) {
        this.dc_gb = dc_gb;
    }

    public String getCoupon_seq() {
        return coupon_seq;
    }

    public void setCoupon_seq(String coupon_seq) {
        this.coupon_seq = coupon_seq;
    }

    public String getDc_endDate() {
        return dc_endDate;
    }

    public void setDc_endDate(String dc_endDate) {
        this.dc_endDate = dc_endDate;
    }
}
