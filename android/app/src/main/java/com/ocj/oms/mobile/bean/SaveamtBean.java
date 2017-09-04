package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/5/24.
 */

public class SaveamtBean {

    private String saveAmtExpireDate;
    private boolean sub;
    private String saveAmtType;
    private String saveAmtGetDate;
    private String saveAmtName;
    private String saveAmt;
    private int TOTALCNT;

    public String getSaveAmtExpireDate() {
        return saveAmtExpireDate;
    }

    public void setSaveAmtExpireDate(String saveAmtExpireDate) {
        this.saveAmtExpireDate = saveAmtExpireDate;
    }

    public boolean isSub() {
        return sub;
    }

    public void setSub(boolean sub) {
        this.sub = sub;
    }

    public String getSaveAmtType() {
        return saveAmtType;
    }

    public void setSaveAmtType(String saveAmtType) {
        this.saveAmtType = saveAmtType;
    }

    public String getSaveAmtGetDate() {
        return saveAmtGetDate;
    }

    public void setSaveAmtGetDate(String saveAmtGetDate) {
        this.saveAmtGetDate = saveAmtGetDate;
    }

    public String getSaveAmtName() {
        return saveAmtName;
    }

    public void setSaveAmtName(String saveAmtName) {
        this.saveAmtName = saveAmtName;
    }

    public String getSaveAmt() {
        return saveAmt;
    }

    public void setSaveAmt(String saveAmt) {
        this.saveAmt = saveAmt;
    }

    public int getTOTALCNT() {
        return TOTALCNT;
    }

    public void setTOTALCNT(int TOTALCNT) {
        this.TOTALCNT = TOTALCNT;
    }
}
