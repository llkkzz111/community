package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/6/14.
 */

public class OcustBean {
    /**
     * coupon_note : 单笔订单满200元减20元
     * use_yn : 0
     * coupon_no : 2017010400027159
     * insert_dat : 1497492110000
     */

    private String coupon_note;
    private String use_yn;
    private String coupon_no;
    private long insert_dat;

    public String getCoupon_note() {
        return coupon_note;
    }

    public void setCoupon_note(String coupon_note) {
        this.coupon_note = coupon_note;
    }

    public String getUse_yn() {
        return use_yn;
    }

    public void setUse_yn(String use_yn) {
        this.use_yn = use_yn;
    }

    public String getCoupon_no() {
        return coupon_no;
    }

    public void setCoupon_no(String coupon_no) {
        this.coupon_no = coupon_no;
    }

    public long getInsert_dat() {
        return insert_dat;
    }

    public void setInsert_dat(long insert_dat) {
        this.insert_dat = insert_dat;
    }
}
