package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/6/7.
 */

public class ReasonBean {

    private String CLAIMCODE;
    private String REASON;

    private String reason;
    private int reason_id;
    private boolean checked;

    public String getCLAIMCODE() {
        return CLAIMCODE;
    }

    public void setCLAIMCODE(String CLAIMCODE) {
        this.CLAIMCODE = CLAIMCODE;
    }

    public String getREASON() {
        return REASON;
    }

    public void setREASON(String REASON) {
        this.REASON = REASON;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public int getReason_id() {
        return reason_id;
    }

    public void setReason_id(int reason_id) {
        this.reason_id = reason_id;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
}
