package com.choudao.imsdk.db.bean;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
// KEEP INCLUDES END

import android.text.TextUtils;

/**
 * Entity mapped to table "MOBILE_USER_INFO".
 */
public class MobileUserInfo implements java.io.Serializable {

    private Long id;
    private long userId;
    private String name;
    private String namePinYin;
    /** Not-null value. */
    private String phone;
    private String headImgUrl;
    private String mobName;
    private String mobEmail;
    private Boolean state;

    // KEEP FIELDS - put your custom fields here

    private String img;

    // KEEP FIELDS END

    public MobileUserInfo() {
    }

    public MobileUserInfo(Long id) {
        this.id = id;
    }

    public MobileUserInfo(Long id, long userId, String name, String namePinYin, String phone, String headImgUrl, String mobName, String mobEmail, Boolean state) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.namePinYin = namePinYin;
        this.phone = phone;
        this.headImgUrl = headImgUrl;
        this.mobName = mobName;
        this.mobEmail = mobEmail;
        this.state = state;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNamePinYin() {
        return namePinYin;
    }

    public void setNamePinYin(String namePinYin) {
        this.namePinYin = namePinYin;
    }

    /** Not-null value. */
    public String getPhone() {
        return phone;
    }

    /** Not-null value; ensure this value is available before it is saved to the database. */
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMobName() {
        return mobName;
    }

    public void setMobName(String mobName) {
        this.mobName = mobName;
    }

    public String getMobEmail() {
        return mobEmail;
    }

    public void setMobEmail(String mobEmail) {
        this.mobEmail = mobEmail;
    }

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    // KEEP METHODS - put your custom methods here
    public void setImg(String img) {
        this.img = img;
    }

    public String getHeadImgUrl() {
        return TextUtils.isEmpty(headImgUrl) ? img : headImgUrl;
    }

    public void setHeadImgUrl(String headImgUrl) {
        this.headImgUrl = headImgUrl;
    }
    // KEEP METHODS END

}
