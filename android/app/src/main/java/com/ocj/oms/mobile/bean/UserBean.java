package com.ocj.oms.mobile.bean;

/**
 * Created by liuzhao on 2017/4/13.
 */

public class UserBean {
    /**
     * 0: 不能识别
     * 1: 已注册过用户名
     * 2: 邮箱的用户
     * 3: 已注册过的手机用户
     * 4: 添加过手机的电视用户
     * 5: 未添加过手机的电视用户
     */
    public static final int TYPE_0 = 0;
    public static final int TYPE_1 = 1;
    public static final int TYPE_2 = 2;
    public static final int TYPE_3 = 3;
    public static final int TYPE_4 = 4;
    public static final int TYPE_5 = 5;

    private String username;
    private String password;
    private int user_type;
    private boolean isfirst;

    public boolean isfirst() {
        return isfirst;
    }

    public void setIsfirst(boolean isfirst) {
        this.isfirst = isfirst;
    }

    public int getUserType() {
        return user_type;
    }

    public void setUserType(int user_type) {
        this.user_type = user_type;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
