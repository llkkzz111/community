package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/5/2.
 */

public class VerifyBean {
    private String verify_code;
    private String internet_id;
    private String mobile;
    private String smspasswd;

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getSmspasswd() {
        return smspasswd;
    }

    public void setSmspasswd(String smspasswd) {
        this.smspasswd = smspasswd;
    }

    public String getInternetId() {
        return internet_id;
    }

    public void setInternetId(String internet_id) {
        this.internet_id = internet_id;
    }
    public String getVerifyode() {
        return verify_code;
    }

    public void setVerifyCode(String verify_code) {
        this.verify_code = verify_code;
    }
}
