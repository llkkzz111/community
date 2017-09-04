package com.ocj.oms.mobile.bean;

/**
 * 支付状态bean
 * Created by shizhang.cai on 2017/8/22.
 */

public class OrderStatusBean {

    private String responseResult;

    private String promotion;

    private String promotionUrl;


    public String getResponseResult() {
        return responseResult;
    }

    public void setResponseResult(String responseResult) {
        this.responseResult = responseResult;
    }

    public String getPromotion() {
        return promotion;
    }

    public void setPromotion(String promotion) {
        this.promotion = promotion;
    }

    public String getPromotionUrl() {
        return promotionUrl;
    }

    public void setPromotionUrl(String promotionUrl) {
        this.promotionUrl = promotionUrl;
    }
}
