package com.ocj.oms.mobile.bean;

/**
 * Created by yy on 2017/6/8.
 */

public class GlobalHotBean {

    String nationFlag;// 国家标志
    String shopTag;//商户描述
    String productMark;//商品描述
    String producctUrl;//商品图片


    public GlobalHotBean(String nationFlag, String shopTag, String productMark, String producctUrl) {
        this.nationFlag = nationFlag;
        this.shopTag = shopTag;
        this.productMark = productMark;
        this.producctUrl = producctUrl;
    }

    public String getNationFlag() {
        return nationFlag;
    }

    public void setNationFlag(String nationFlag) {
        this.nationFlag = nationFlag;
    }

    public String getShopTag() {
        return shopTag;
    }

    public void setShopTag(String shopTag) {
        this.shopTag = shopTag;
    }

    public String getProductMark() {
        return productMark;
    }

    public void setProductMark(String productMark) {
        this.productMark = productMark;
    }

    public String getProducctUrl() {
        return producctUrl;
    }

    public void setProducctUrl(String producctUrl) {
        this.producctUrl = producctUrl;
    }


}
