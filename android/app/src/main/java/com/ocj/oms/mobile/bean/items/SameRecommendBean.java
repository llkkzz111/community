package com.ocj.oms.mobile.bean.items;

/**
 * Created by yy on 2017/6/13.
 */

public class SameRecommendBean {

    private String SALE_PRICE;
    private String CUST_PRICE;
    private String SALES_VOLUME;
    private String ITEM_CODE;
    private String url;
    private String ITEM_NAME;
    private String dc;

    public String getSALE_PRICE() {
        return SALE_PRICE;
    }

    public void setSALE_PRICE(String SALE_PRICE) {
        this.SALE_PRICE = SALE_PRICE;
    }

    public String getCUST_PRICE() {
        return CUST_PRICE;
    }

    public void setCUST_PRICE(String CUST_PRICE) {
        this.CUST_PRICE = CUST_PRICE;
    }

    public String getSALES_VOLUME() {
        return SALES_VOLUME;
    }

    public void setSALES_VOLUME(String SALES_VOLUME) {
        this.SALES_VOLUME = SALES_VOLUME;
    }

    public String getITEM_CODE() {
        return ITEM_CODE;
    }

    public void setITEM_CODE(String ITEM_CODE) {
        this.ITEM_CODE = ITEM_CODE;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getITEM_NAME() {
        return ITEM_NAME;
    }

    public void setITEM_NAME(String ITEM_NAME) {
        this.ITEM_NAME = ITEM_NAME;
    }

    public String getDc() {
        return dc;
    }

    public void setDc(String dc) {
        this.dc = dc;
    }
}
