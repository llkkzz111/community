package com.ocj.oms.mobile.bean;

/**
 * Created by liuzhao on 2017/6/21.
 */

public class CheckToken {

    /**
     * isVisitor : false
     * expiresTime : 1500554196000
     * isLogin : true
     */

    private boolean isVisitor;
    private long expiresTime;
    private boolean isLogin;
    private String cust_no;

    public String getCust_no() {
        return cust_no;
    }

    public void setCust_no(String cust_no) {
        this.cust_no = cust_no;
    }

    public boolean isIsVisitor() {
        return isVisitor;
    }

    public void setIsVisitor(boolean isVisitor) {
        this.isVisitor = isVisitor;
    }

    public long getExpiresTime() {
        return expiresTime;
    }

    public void setExpiresTime(long expiresTime) {
        this.expiresTime = expiresTime;
    }

    public boolean isIsLogin() {
        return isLogin;
    }

    public void setIsLogin(boolean isLogin) {
        this.isLogin = isLogin;
    }

}
