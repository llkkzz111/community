package com.ocj.oms.mobile.bean;

import java.io.Serializable;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/11 16:30
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class VipSelectedBean implements Serializable{
    private String contentImage;//小图片url
    private String  item_image ;//大图片url
    private String conts_title_nm;//标题
    private String item_name;
    // 三个价格
    private String cust_price;
    private String item_price;
    private String sale_price;

    private String save_amt;//积分

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public String getItem_image() {
        return item_image;
    }

    public void setItem_image(String item_image) {
        this.item_image = item_image;
    }

    public String getConts_title_nm() {
        return conts_title_nm;
    }

    public void setConts_title_nm(String conts_title_nm) {
        this.conts_title_nm = conts_title_nm;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }

    public String getCust_price() {
        return cust_price;
    }

    public void setCust_price(String cust_price) {
        this.cust_price = cust_price;
    }

    public String getItem_price() {
        return item_price;
    }

    public void setItem_price(String item_price) {
        this.item_price = item_price;
    }

    public String getSale_price() {
        return sale_price;
    }

    public void setSale_price(String sale_price) {
        this.sale_price = sale_price;
    }

    public String getSave_amt() {
        return save_amt;
    }

    public void setSave_amt(String save_amt) {
        this.save_amt = save_amt;
    }

    @Override
    public String toString() {
        return "VipSelectedBean{" +
                "contentImage='" + contentImage + '\'' +
                ", item_image='" + item_image + '\'' +
                ", conts_title_nm='" + conts_title_nm + '\'' +
                ", item_name='" + item_name + '\'' +
                ", cust_price='" + cust_price + '\'' +
                ", item_price='" + item_price + '\'' +
                ", sale_price='" + sale_price + '\'' +
                ", save_amt='" + save_amt + '\'' +
                '}';
    }
}
