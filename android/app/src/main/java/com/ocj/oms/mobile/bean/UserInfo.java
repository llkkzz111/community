package com.ocj.oms.mobile.bean;

/**
 * Created by admin-ocj on 2017/5/3.
 */

public class UserInfo {
    private String access_token;
    private String cust_no;
    private String cust_name;
    private String mobile;
    private String internet_id;
    private boolean isMobile;
    private MemberBean member_info;

    public String getInternet_id() {
        return internet_id;
    }

    public void setInternet_id(String internet_id) {
        this.internet_id = internet_id;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public boolean isMobile() {
        return isMobile;
    }

    public void setMobile(boolean mobile) {
        isMobile = mobile;
    }

    public String getAccessToken() {
        return access_token;
    }

    public void setAccess_token(String access_token) {
        this.access_token = access_token;
    }

    public String getCust_no() {
        return cust_no;
    }

    public void setCust_no(String cust_no) {
        this.cust_no = cust_no;
    }

    public String getCust_name() {
        return cust_name;
    }

    public void setCust_name(String cust_name) {
        this.cust_name = cust_name;
    }

    public MemberBean getMember_info() {
        return member_info;
    }

    public void setMember_info(MemberBean member_info) {
        this.member_info = member_info;
    }

    @Override
    public String toString() {
        return "UserInfo{" +
                "access_token='" + access_token + '\'' +
                ", cust_no='" + cust_no + '\'' +
                ", cust_name='" + cust_name + '\'' +
                '}';
    }
}
