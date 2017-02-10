package com.choudao.equity.entity;

/**
 * Created by liuzhao on 16/9/22.
 */

public class ContactInfo {
    private String phone;
    private String mobName;

    private String mobEmail;

    public String getEmail() {
        return mobEmail;
    }

    public void setEmail(String email) {
        this.mobEmail = email;
    }

    public String getName() {
        return mobName;
    }

    public void setName(String name) {
        this.mobName = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone.replaceAll(" ", "");
    }
}
