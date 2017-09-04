package com.ocj.oms.mobile.bean.h5;

/**
 * Created by liuzhao on 2017/6/30.
 */

public class H5ParamsBean {
    /**
     * image_url : http://cdnimg.ocj.com.cn/item_images/item/B1/31/41/B13141S.jpg
     * title : 东方购物鸥家俱乐部一款商品：惠人原汁机置物架，鸥点数仅需：10，大家快来抢吧！
     * target_url : http://rm.ocj.com.cn/oclub/tryout/O131412017
     */

    private String image_url;
    private String title;
    private String content;
    private String target_url;
    private String itemCode;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTarget_url() {
        return target_url;
    }

    public void setTarget_url(String target_url) {
        this.target_url = target_url;
    }

    private String order_no;

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }
}
