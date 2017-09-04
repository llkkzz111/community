package com.ocj.oms.mobile.bean.items;

import java.io.Serializable;

/**
 * Created by liu on 2017/6/12.
 * 颜色尺寸规格bean
 */

public class SpecItemBean implements Serializable{
    private String cs_off;//: "",
    private String cs_code;//: "1000000002",
    private String cs_img;//: "http://image1.ocj.com.cn/item_images/item/15/17/4707/15174707S.jpg",
    private String hidden_wu;//: "N",
    private String is_show;//: "Y",
    private String cs_name;//: "黑色"

    public String getCs_off() {
        return cs_off;
    }

    public void setCs_off(String cs_off) {
        this.cs_off = cs_off;
    }

    public String getCs_code() {
        return cs_code;
    }

    public void setCs_code(String cs_code) {
        this.cs_code = cs_code;
    }

    public String getCs_img() {
        return cs_img;
    }

    public void setCs_img(String cs_img) {
        this.cs_img = cs_img;
    }

    public String getHidden_wu() {
        return hidden_wu;
    }

    public void setHidden_wu(String hidden_wu) {
        this.hidden_wu = hidden_wu;
    }

    public String getIs_show() {
        return is_show;
    }

    public void setIs_show(String is_show) {
        this.is_show = is_show;
    }

    public String getCs_name() {
        return cs_name;
    }

    public void setCs_name(String cs_name) {
        this.cs_name = cs_name;
    }
}
