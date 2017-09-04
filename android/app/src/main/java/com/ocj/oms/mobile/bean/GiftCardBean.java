package com.ocj.oms.mobile.bean;

/**
 * Created by yy on 2017/5/20.
 */

public class GiftCardBean {


    /**
     * DEPOSIT_GB : 2
     * STATUS : 支付结束
     * DEPOSIT_NOTE_APP : 礼品卡充值
     * DEPOSIT_GB_APP : 充值
     * REFUND_YN : 1
     * USE_AMT_APP : +500.00
     * DEPOSIT_NOTE : 500元
     * CNT : 0
     * PROC_DATE : 2017-05-03
     * PAGE : 1
     * DEPOSIT_AMT : 500.00元
     * TOTAL_CNT : 92
     */

    private String DEPOSIT_GB;
    private String STATUS;
    private String DEPOSIT_NOTE_APP;
    private String DEPOSIT_GB_APP;
    private String REFUND_YN;
    private String USE_AMT_APP;
    private String DEPOSIT_NOTE;
    private int CNT;
    private String PROC_DATE;
    private int PAGE;
    private String DEPOSIT_AMT;
    private String TOTAL_CNT;

    public String getDEPOSIT_GB() {
        return DEPOSIT_GB;
    }

    public void setDEPOSIT_GB(String DEPOSIT_GB) {
        this.DEPOSIT_GB = DEPOSIT_GB;
    }

    public String getSTATUS() {
        return STATUS;
    }

    public void setSTATUS(String STATUS) {
        this.STATUS = STATUS;
    }

    public String getDEPOSIT_NOTE_APP() {
        return DEPOSIT_NOTE_APP;
    }

    public void setDEPOSIT_NOTE_APP(String DEPOSIT_NOTE_APP) {
        this.DEPOSIT_NOTE_APP = DEPOSIT_NOTE_APP;
    }

    public String getDEPOSIT_GB_APP() {
        return DEPOSIT_GB_APP;
    }

    public void setDEPOSIT_GB_APP(String DEPOSIT_GB_APP) {
        this.DEPOSIT_GB_APP = DEPOSIT_GB_APP;
    }

    public String getREFUND_YN() {
        return REFUND_YN;
    }

    public void setREFUND_YN(String REFUND_YN) {
        this.REFUND_YN = REFUND_YN;
    }

    public String getUSE_AMT_APP() {
        return USE_AMT_APP;
    }

    public void setUSE_AMT_APP(String USE_AMT_APP) {
        this.USE_AMT_APP = USE_AMT_APP;
    }

    public String getDEPOSIT_NOTE() {
        return DEPOSIT_NOTE;
    }

    public void setDEPOSIT_NOTE(String DEPOSIT_NOTE) {
        this.DEPOSIT_NOTE = DEPOSIT_NOTE;
    }

    public int getCNT() {
        return CNT;
    }

    public void setCNT(int CNT) {
        this.CNT = CNT;
    }

    public String getPROC_DATE() {
        return PROC_DATE;
    }

    public void setPROC_DATE(String PROC_DATE) {
        this.PROC_DATE = PROC_DATE;
    }

    public int getPAGE() {
        return PAGE;
    }

    public void setPAGE(int PAGE) {
        this.PAGE = PAGE;
    }

    public String getDEPOSIT_AMT() {
        return DEPOSIT_AMT;
    }

    public void setDEPOSIT_AMT(String DEPOSIT_AMT) {
        this.DEPOSIT_AMT = DEPOSIT_AMT;
    }

    public String getTOTAL_CNT() {
        return TOTAL_CNT;
    }

    public void setTOTAL_CNT(String TOTAL_CNT) {
        this.TOTAL_CNT = TOTAL_CNT;
    }
}
