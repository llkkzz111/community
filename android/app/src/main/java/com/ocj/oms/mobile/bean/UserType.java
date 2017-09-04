package com.ocj.oms.mobile.bean;

/**
 * Created by liuzhao on 2017/4/13.
 */

public class UserType {
    /**
     * 0: 不能识别
     */
    public static final int TYPE_UNKNOWN = 0;
    /**
     * * 1: 已注册过用户名
     */
    public static final int TYPE_USER_NAME = 1;
    /**
     * * 2: 邮箱的用户
     */
    public static final int TYPE_MAIL = 2;
    /**
     * * 3: 已注册过的手机用户
     */
    public static final int TYPE_MOBILE = 3;
    /**
     * * 4: 添加过手机的电视用户
     */
    public static final int TYPE_MOBILE_TV = 4;
    /**
     * * 5: 未添加过手机的电视用户
     */
    public static final int TYPE_TV = 5;

    private int user_type;
    private String cust_name;

    public String getCust_name() {
        return cust_name;
    }

    public void setCust_name(String cust_name) {
        this.cust_name = cust_name;
    }

    public int getUserType() {
        return user_type;
    }

    public void setUserType(int user_type) {
        this.user_type = user_type;
    }
}
