package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/5/31.
 */

public class TaoVocherBean {

    /**
     * DCRATE : 0
     * DCCOUPONCONTENT : [xml]1110/一般/领取/不指定/1天后生效
     * DC_TYPE : 0
     * DCGB : 10
     * DCCOUPONNAME : [xml]1110/一般/领取/不指定/1天后生效
     * MIN_ITEM_COUNT : 1
     * PAGE : 1
     * DCBDATE : 2016-11-10 23
     * COUPONNO : 2016111000000446
     * DCAMT : 21
     * TOTALSIZE : 9
     * DCEDATE : 2017-12-11 00
     * MIN_ORDER_AMT : 1
     */

    private int DCRATE;
    private String DCCOUPONCONTENT;
    private String DC_TYPE;
    private String DCGB;
    private String DCCOUPONNAME;
    private int MIN_ITEM_COUNT;
    private int PAGE;
    private String DCBDATE;
    private String COUPONNO;
    private int DCAMT;
    private int TOTALSIZE;
    private String DCEDATE;
    private int MIN_ORDER_AMT;

    public int getDCRATE() {
        return DCRATE;
    }

    public void setDCRATE(int DCRATE) {
        this.DCRATE = DCRATE;
    }

    public String getDCCOUPONCONTENT() {
        return DCCOUPONCONTENT;
    }

    public void setDCCOUPONCONTENT(String DCCOUPONCONTENT) {
        this.DCCOUPONCONTENT = DCCOUPONCONTENT;
    }

    public String getDC_TYPE() {
        return DC_TYPE;
    }

    public void setDC_TYPE(String DC_TYPE) {
        this.DC_TYPE = DC_TYPE;
    }

    public String getDCGB() {
        return DCGB;
    }

    public void setDCGB(String DCGB) {
        this.DCGB = DCGB;
    }

    public String getDCCOUPONNAME() {
        return DCCOUPONNAME;
    }

    public void setDCCOUPONNAME(String DCCOUPONNAME) {
        this.DCCOUPONNAME = DCCOUPONNAME;
    }

    public int getMIN_ITEM_COUNT() {
        return MIN_ITEM_COUNT;
    }

    public void setMIN_ITEM_COUNT(int MIN_ITEM_COUNT) {
        this.MIN_ITEM_COUNT = MIN_ITEM_COUNT;
    }

    public int getPAGE() {
        return PAGE;
    }

    public void setPAGE(int PAGE) {
        this.PAGE = PAGE;
    }

    public String getDCBDATE() {
        return DCBDATE;
    }

    public void setDCBDATE(String DCBDATE) {
        this.DCBDATE = DCBDATE;
    }

    public String getCOUPONNO() {
        return COUPONNO;
    }

    public void setCOUPONNO(String COUPONNO) {
        this.COUPONNO = COUPONNO;
    }

    public int getDCAMT() {
        return DCAMT;
    }

    public void setDCAMT(int DCAMT) {
        this.DCAMT = DCAMT;
    }

    public int getTOTALSIZE() {
        return TOTALSIZE;
    }

    public void setTOTALSIZE(int TOTALSIZE) {
        this.TOTALSIZE = TOTALSIZE;
    }

    public String getDCEDATE() {
        return DCEDATE;
    }

    public void setDCEDATE(String DCEDATE) {
        this.DCEDATE = DCEDATE;
    }

    public int getMIN_ORDER_AMT() {
        return MIN_ORDER_AMT;
    }

    public void setMIN_ORDER_AMT(int MIN_ORDER_AMT) {
        this.MIN_ORDER_AMT = MIN_ORDER_AMT;
    }
}
