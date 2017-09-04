package com.ocj.oms.mobile.bean.items;

import java.io.Serializable;
import java.util.List;

/**
 * Created by liuzhao on 2017/6/10.
 */

public class CmsItemsBean implements Serializable {
    /**
     * 视频url
     */
    protected String videoPlayBackUrl;


    protected String firstImgUrl;

    protected int isNew;
    private String lgroup;
    private String videoStatus;


    /**
     * 赠品
     */
    protected List<String> gifts;

    public CmsItemsBean(String salePrice, String title, String inStock, String subtitle, String description) {
        this.salePrice = salePrice;
        this.title = title;
        this.inStock = inStock;
        this.subtitle = subtitle;
        this.description = description;
    }

    public CmsItemsBean() {
    }


    /**
     * 积分
     */
    protected String integral;

    /**
     * 销售量
     */
    protected String salesVolume;
    /**
     * 原价
     */
    protected String originalPrice;
    /**
     * 销售价
     */
    protected String salePrice;

    protected String id;

    protected String title;
    protected long componentId;

    protected long codeId;
    protected int isComponents;
    protected int shortNumber;

    protected String codeValue;
    protected String contentCode;
    protected String contentType;

    private String destinationUrl;

    private String graphicText;

    private short destinationUrlType;

    protected String curruntDateLong;

    protected String countryImgUrl; //国家url
    protected String countryName; //国家名称
    protected String countryCode; //国家code

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getCountryImgUrl() {
        return countryImgUrl;
    }

    public void setCountryImgUrl(String countryImgUrl) {
        this.countryImgUrl = countryImgUrl;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCurruntDateLong() {
        return curruntDateLong;
    }

    public void setCurruntDateLong(String curruntDateLong) {
        this.curruntDateLong = curruntDateLong;
    }

    public String getPlayDateLong() {
        return playDateLong;
    }

    public void setPlayDateLong(String playDateLong) {
        this.playDateLong = playDateLong;
    }

    protected String playDateLong;

    /**
     * 特殊字段，今日团用
     * 1：上新商品
     * 2：人气推荐
     * 3：超低折扣
     * 4：品牌
     */
    private int groupBuyType;

    /**
     * 折扣
     */
    private String discount;

    /**
     * 剩余时间
     */
    private String remainingTime;
    /**
     * 库存
     */
    private String inStock;
    /**
     * 赠品
     */
    /**
     * 团购开始的时间-HH24
     */
    private String groupBuyTime;
    /**
     * 副标题
     */
    private String subtitle;
    private String subTitle;

    private String secondImgUrl;
    private String thirdImgUrl;
    private String watchNumber;
    /**
     * 作者
     */
    private String author;
    /**
     * 直播时间
     */
    private String videoDate;

    /**
     * 描述
     */
    private String description;

    public int getIsNew() {
        return isNew;
    }

    public void setIsNew(int isNew) {
        this.isNew = isNew;
    }

    public String getLgroup() {
        return lgroup;
    }

    public void setLgroup(String lgroup) {
        this.lgroup = lgroup;
    }

    /**
     * 标签名
     */
    private List<String> labelName;

    protected List<CmsItemsBean> componentList;

    public String getDestinationUrl() {
        return destinationUrl;
    }

    public void setDestinationUrl(String destinationUrl) {
        this.destinationUrl = destinationUrl;
    }

    public String getGraphicText() {
        return graphicText;
    }

    public void setGraphicText(String graphicText) {
        this.graphicText = graphicText;
    }

    public short getDestinationUrlType() {
        return destinationUrlType;
    }

    public void setDestinationUrlType(short destinationUrlType) {
        this.destinationUrlType = destinationUrlType;
    }

    public int getGroupBuyType() {
        return groupBuyType;
    }

    public void setGroupBuyType(int groupBuyType) {
        this.groupBuyType = groupBuyType;
    }

    public String getDiscount() {
        return discount;
    }

    public void setDiscount(String discount) {
        this.discount = discount;
    }

    public String getRemainingTime() {
        return remainingTime;
    }

    public void setRemainingTime(String remainingTime) {
        this.remainingTime = remainingTime;
    }

    public String getInStock() {
        return inStock;
    }

    public void setInStock(String inStock) {
        this.inStock = inStock;
    }

    public String getGroupBuyTime() {
        return groupBuyTime;
    }

    public void setGroupBuyTime(String groupBuyTime) {
        this.groupBuyTime = groupBuyTime;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
    }

    public String getSecondImgUrl() {
        return secondImgUrl;
    }

    public void setSecondImgUrl(String secondImgUrl) {
        this.secondImgUrl = secondImgUrl;
    }

    public String getThirdImgUrl() {
        return thirdImgUrl;
    }

    public void setThirdImgUrl(String thirdImgUrl) {
        this.thirdImgUrl = thirdImgUrl;
    }

    public String getWatchNumber() {
        return watchNumber;
    }

    public void setWatchNumber(String watchNumber) {
        this.watchNumber = watchNumber;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getVideoDate() {
        return videoDate;
    }

    public void setVideoDate(String videoDate) {
        this.videoDate = videoDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<String> getLabelName() {
        return labelName;
    }

    public void setLabelName(List<String> labelName) {
        this.labelName = labelName;
    }

    public String getVideoPlayBackUrl() {
        return videoPlayBackUrl;
    }

    public void setVideoPlayBackUrl(String videoPlayBackUrl) {
        this.videoPlayBackUrl = videoPlayBackUrl;
    }

    public String getFirstImgUrl() {
        return firstImgUrl;
    }

    public void setFirstImgUrl(String firstImgUrl) {
        this.firstImgUrl = firstImgUrl;
    }

    public List<String> getGifts() {
        return gifts;
    }

    public void setGifts(List<String> gifts) {
        this.gifts = gifts;
    }

    public String getIntegral() {
        return integral;
    }

    public void setIntegral(String integral) {
        this.integral = integral;
    }

    public String getSalesVolume() {
        return salesVolume;
    }

    public void setSalesVolume(String salesVolume) {
        this.salesVolume = salesVolume;
    }

    public String getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(String originalPrice) {
        this.originalPrice = originalPrice;
    }

    public String getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(String salePrice) {
        this.salePrice = salePrice;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public long getComponentId() {
        return componentId;
    }

    public void setComponentId(long componentId) {
        this.componentId = componentId;
    }

    public long getCodeId() {
        return codeId;
    }

    public void setCodeId(long codeId) {
        this.codeId = codeId;
    }

    public int getIsComponents() {
        return isComponents;
    }

    public void setIsComponents(int isComponents) {
        this.isComponents = isComponents;
    }

    public int getShortNumber() {
        return shortNumber;
    }

    public void setShortNumber(int shortNumber) {
        this.shortNumber = shortNumber;
    }

    public String getCodeValue() {
        return codeValue;
    }

    public void setCodeValue(String codeValue) {
        this.codeValue = codeValue;
    }

    public String getContentCode() {
        return contentCode;
    }

    public void setContentCode(String contentCode) {
        this.contentCode = contentCode;
    }

    public List<CmsItemsBean> getComponentList() {
        return componentList;
    }

    public void setComponentList(List<CmsItemsBean> componentList) {
        this.componentList = componentList;
    }

    public String getVideoStatus() {
        return videoStatus;
    }

    public void setVideoStatus(String videoStatus) {
        this.videoStatus = videoStatus;
    }

}
