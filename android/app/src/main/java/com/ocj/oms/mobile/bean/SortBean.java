package com.ocj.oms.mobile.bean;

/**
 * Created by yy on 2017/6/8.
 * 商品分类
 */

public class SortBean {


    String promotionType;// 促销标识(促，新)
    String productKind;//商户类别
    String kindUrl;//类别图片

    public SortBean(String promotionType, String productKind, String kindUrl) {
        this.promotionType = promotionType;
        this.productKind = productKind;
        this.kindUrl = kindUrl;
    }

    public SortBean() {
    }


    public String getPromotionType() {
        return promotionType;
    }

    public String getProductKind() {
        return productKind;
    }

    public String getKindUrl() {
        return kindUrl;
    }

    public void setPromotionType(String promotionType) {
        this.promotionType = promotionType;
    }

    public void setProductKind(String productKind) {
        this.productKind = productKind;
    }

    public void setKindUrl(String kindUrl) {
        this.kindUrl = kindUrl;
    }
}
