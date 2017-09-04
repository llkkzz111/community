package com.ocj.oms.mobile.bean;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/9 21:57
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class ItemsBeanX {
    /**
     * dt_info : 无
     * order_d_seq : 001
     * rsale_amt : 135
     * contentLink : http://awww.ocj.com.cn/detail/2831282013
     * item_name : 统一冰红茶500ML*45瓶
     * order_w_seq : 001
     * order_qty : 1
     * saveamt : 0
     */
    private ArrayList<String> listUri;//评论图片集合
    private String comment;//评论内容
    private ArrayList<String> urllist;//图片回传集合
    private HashMap<Integer, Float> stars = new HashMap<>();//评论星级

    private String dt_info;
    private String item_code;
    private String order_d_seq;
    private String rsale_amt;
    private String contentLink;
    private String unit_code;
    private String item_name;
    private String order_w_seq;
//    private String order_qty;
//    private String saveamt;
    private String receiver_seq;
    private String order_g_seq;
    /**
     * isShowReturn : false
     * isShowSend : false
     * isShowReturnDetails : false
     * isShowInstall : false
     * itemSaveamt : 14.49
     * order_amt : 488
     * isShowExchange : false
     * item_qty : 1
     */

    private String isShowReturn;
    private String isShowSend;
    private String isShowReturnDetails;
    private String isShowInstall;
    private String itemSaveamt;
    private String order_amt;
    private String isShowExchange;
    private String item_qty;


    public ArrayList<String> getUrllist() {
        return urllist;
    }

    public void setUrllist(ArrayList<String> urllist) {
        this.urllist = urllist;
    }

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

    public String getReceiver_seq() {
        return receiver_seq;
    }

    public void setReceiver_seq(String receiver_seq) {
        this.receiver_seq = receiver_seq;
    }

    public String getOrder_g_seq() {
        return order_g_seq;
    }

    public void setOrder_g_seq(String order_g_seq) {
        this.order_g_seq = order_g_seq;
    }

    public ArrayList<String> getListUri() {
        return listUri;
    }

    public void setListUri(ArrayList<String> listUri) {
        this.listUri = listUri;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public HashMap<Integer, Float> getStars() {
        return stars;
    }

    public void setStars(HashMap<Integer, Float> stars) {
        this.stars = stars;
    }

    public String getDt_info() {
        return dt_info;
    }

    public void setDt_info(String dt_info) {
        this.dt_info = dt_info;
    }

    public String getOrder_d_seq() {
        return order_d_seq;
    }

    public void setOrder_d_seq(String order_d_seq) {
        this.order_d_seq = order_d_seq;
    }

    public String getRsale_amt() {
        return rsale_amt;
    }

    public void setRsale_amt(String rsale_amt) {
        this.rsale_amt = rsale_amt;
    }

    public String getContentLink() {
        return contentLink;
    }

    public void setContentLink(String contentLink) {
        this.contentLink = contentLink;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }

    public String getOrder_w_seq() {
        return order_w_seq;
    }

    public void setOrder_w_seq(String order_w_seq) {
        this.order_w_seq = order_w_seq;
    }


    @Override
    public String toString() {
        return "ItemsBeanX{" +
                "listUri=" + listUri +
                ", comment='" + comment + '\'' +
                ", stars=" + stars +
                ", dt_info='" + dt_info + '\'' +
                ", item_code='" + item_code + '\'' +
                ", order_d_seq='" + order_d_seq + '\'' +
                ", rsale_amt=" + rsale_amt +
                ", contentLink='" + contentLink + '\'' +
                ", unit_code='" + unit_code + '\'' +
                ", item_name='" + item_name + '\'' +
                ", order_w_seq='" + order_w_seq + '\'' +
                ", receiver_seq='" + receiver_seq + '\'' +
                ", order_g_seq='" + order_g_seq + '\'' +
                '}';
    }

    public String getIsShowReturn() {
        return isShowReturn;
    }

    public void setIsShowReturn(String isShowReturn) {
        this.isShowReturn = isShowReturn;
    }

    public String getIsShowSend() {
        return isShowSend;
    }

    public void setIsShowSend(String isShowSend) {
        this.isShowSend = isShowSend;
    }

    public String getIsShowReturnDetails() {
        return isShowReturnDetails;
    }

    public void setIsShowReturnDetails(String isShowReturnDetails) {
        this.isShowReturnDetails = isShowReturnDetails;
    }

    public String getIsShowInstall() {
        return isShowInstall;
    }

    public void setIsShowInstall(String isShowInstall) {
        this.isShowInstall = isShowInstall;
    }

    public String getItemSaveamt() {
        return itemSaveamt;
    }

    public void setItemSaveamt(String itemSaveamt) {
        this.itemSaveamt = itemSaveamt;
    }

    public String getOrder_amt() {
        return order_amt;
    }

    public void setOrder_amt(String order_amt) {
        this.order_amt = order_amt;
    }

    public String getIsShowExchange() {
        return isShowExchange;
    }

    public void setIsShowExchange(String isShowExchange) {
        this.isShowExchange = isShowExchange;
    }

    public String getItem_qty() {
        return item_qty;
    }

    public void setItem_qty(String item_qty) {
        this.item_qty = item_qty;
    }
}
