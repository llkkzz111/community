package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/6/25.
 */

public class RequestReserveBean {
    private String item_code = "";
    private String unit_code = "";
    private String qty = "";
    private String shop_no = "";
    private String memberPromo = "";
    private String gift_item_code = "";
    private String gift_unit_code = "";
    private String giftPromo_no = "";
    private String giftPromo_seq = "";
    private String receiver_seq="";

    public String getItem_code() {
        return item_code;
    }

    public void setItem_code(String item_code) {
        this.item_code = item_code;
    }

    public String getUnit_code() {
        return unit_code;
    }

    public void setUnit_code(String unit_code) {
        this.unit_code = unit_code;
    }

    public String getQty() {
        return qty;
    }

    public void setQty(String qty) {
        this.qty = qty;
    }

    public String getShop_no() {
        return shop_no;
    }

    public void setShop_no(String shop_no) {
        this.shop_no = shop_no;
    }

    public String getMemberPromo() {
        return memberPromo;
    }

    public void setMemberPromo(String memberPromo) {
        this.memberPromo = memberPromo;
    }

    public String getGift_item_code() {
        return gift_item_code;
    }

    public void setGift_item_code(String gift_item_code) {
        this.gift_item_code = gift_item_code;
    }

    public String getGift_unit_code() {
        return gift_unit_code;
    }

    public void setGift_unit_code(String gift_unit_code) {
        this.gift_unit_code = gift_unit_code;
    }

    public String getGiftPromo_no() {
        return giftPromo_no;
    }

    public void setGiftPromo_no(String giftPromo_no) {
        this.giftPromo_no = giftPromo_no;
    }

    public String getGiftPromo_seq() {
        return giftPromo_seq;
    }

    public void setGiftPromo_seq(String giftPromo_seq) {
        this.giftPromo_seq = giftPromo_seq;
    }

    public String getReceiver_seq() {
        return receiver_seq;
    }

    public void setReceiver_seq(String receiver_seq) {
        this.receiver_seq = receiver_seq;
    }
}
