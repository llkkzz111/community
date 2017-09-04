package com.ocj.oms.mobile.bean;

import java.util.ArrayList;

/**
 * Created by liu on 2017/6/14.
 */

public class RetExJson {
    public String orderNo;
    public String retExchYn;
    public ArrayList<RetExJsonItem> items;

    public static class RetExJsonItem {
        public String saveamt;// = 0,
        public String item_code;//  = 15176663,
        public String item_name;//  = 雪佛兰 科帕奇 东方专享版,
        public String contentLink;//  = http://awww.ocj.com.cn/detail/15176663,
        public String receiver_seq;//  = 0000000004,
        public String rsale_amt;//  = 5000,
        public String order_g_seq;//  = 001,
        public String order_w_seq;//  = 001,
        public String order_d_seq;//  = 001,
        public String unit_code;//  = 001,
        public String item_qty;//  = 1,
        public String dt_info;//  = 无
        public String orderType;

        public String getSaveamt() {
            return saveamt;
        }

        public void setSaveamt(String saveamt) {
            this.saveamt = saveamt;
        }

        public String getItem_code() {
            return item_code;
        }

        public void setItem_code(String item_code) {
            this.item_code = item_code;
        }

        public String getItem_name() {
            return item_name;
        }

        public void setItem_name(String item_name) {
            this.item_name = item_name;
        }

        public String getContentLink() {
            return contentLink;
        }

        public void setContentLink(String contentLink) {
            this.contentLink = contentLink;
        }

        public String getReceiver_seq() {
            return receiver_seq;
        }

        public void setReceiver_seq(String receiver_seq) {
            this.receiver_seq = receiver_seq;
        }

        public String getRsale_amt() {
            return rsale_amt;
        }

        public void setRsale_amt(String rsale_amt) {
            this.rsale_amt = rsale_amt;
        }

        public String getOrder_g_seq() {
            return order_g_seq;
        }

        public void setOrder_g_seq(String order_g_seq) {
            this.order_g_seq = order_g_seq;
        }

        public String getOrder_w_seq() {
            return order_w_seq;
        }

        public void setOrder_w_seq(String order_w_seq) {
            this.order_w_seq = order_w_seq;
        }

        public String getOrder_d_seq() {
            return order_d_seq;
        }

        public void setOrder_d_seq(String order_d_seq) {
            this.order_d_seq = order_d_seq;
        }

        public String getUnit_code() {
            return unit_code;
        }

        public void setUnit_code(String unit_code) {
            this.unit_code = unit_code;
        }

        public String getItem_qty() {
            return item_qty;
        }

        public void setItem_qty(String item_qty) {
            this.item_qty = item_qty;
        }

        public String getDt_info() {
            return dt_info;
        }

        public void setDt_info(String dt_info) {
            this.dt_info = dt_info;
        }

        public String getOrderType() {
            return orderType;
        }

        public void setOrderType(String orderType) {
            this.orderType = orderType;
        }
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getRetExchYn() {
        return retExchYn;
    }

    public void setRetExchYn(String retExchYn) {
        this.retExchYn = retExchYn;
    }

    public ArrayList<RetExJsonItem> getItems() {
        return items;
    }

    public void setItems(ArrayList<RetExJsonItem> items) {
        this.items = items;
    }
}
