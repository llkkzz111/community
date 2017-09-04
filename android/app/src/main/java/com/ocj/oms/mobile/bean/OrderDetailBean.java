/**
 * Copyright 2017 bejson.com
 */
package com.ocj.oms.mobile.bean;

import java.util.ArrayList;

/**
 * Auto-generated: 2017-06-09 18:11:51
 *
 * @author bejson.com (i@bejson.com)
 * @website http://www.bejson.com/java2pojo/
 */
public class OrderDetailBean {


    private String order_no;
    private ArrayList<ItemBean> items;

    public static class ItemBean {
        private String dt_info;//": "白色小花/F(均码)",
        private String rsale_amt;//": 128,
        private String contentLink;//": "http://awww.ocj.com.cn/detail/15123572",
        private String item_name;//": "诗恺芙 印花时尚超薄雪纺外套6113188",
        private String order_d_seq;//": "001",
        private String order_w_seq;//": "001",
        private String order_g_seq;//": "001",
        private String order_qty;//": 1,
        private String saveamt;//": 0

        public String getOrder_g_seq() {
            return order_g_seq;
        }

        public void setOrder_g_seq(String order_g_seq) {
            this.order_g_seq = order_g_seq;
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

        public String getOrder_qty() {
            return order_qty;
        }

        public void setOrder_qty(String order_qty) {
            this.order_qty = order_qty;
        }

        public String getSaveamt() {
            return saveamt;
        }

        public void setSaveamt(String saveamt) {
            this.saveamt = saveamt;
        }
    }

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public ArrayList<ItemBean> getItems() {
        return items;
    }

    public void setItems(ArrayList<ItemBean> items) {
        this.items = items;
    }
}