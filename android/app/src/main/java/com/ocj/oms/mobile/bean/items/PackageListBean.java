package com.ocj.oms.mobile.bean.items;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by liuzhao on 2017/6/9.
 */

public class PackageListBean implements Serializable {
    /**
     * packageId : 42
     * id : 6277879541130067968
     * codeId : null
     * codeValue : AP1706A012B14001
     * isPackages : 0
     * shortNumber : 2
     * componentList : [{"id":"6277879541146845184","title":null,"componentId":"30","codeId":"404","destinationUrl":null,"isComponents":1,"shortNumber":0,"codeValue":"AP1706A012B14001D09001","destinationUrlType":null,"contentCode":null,"componentList":[{"id":"6277879541146845184","title":"德国进口可爱儿童","componentId":null,"codeId":"404","destinationUrl":null,"isComponents":0,"shortNumber":0,"codeValue":"AP1706A012B14001D09001","destinationUrlType":null,"contentCode":"15102398","componentList":null,"groupBuyType":1,"salesVolume":"90","originalPrice":"344","salePrice":"244","discount":"4.5","integral":"0","remainingTime":null,"inStock":"100","gifts":"超级赠品 XXXXXXXXXXXXXXXXX","groupBuyTime":null,"firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/2017060105.jpg"},{"id":"6277879541146845184","title":"富士通(Fujitsu)将军空调挂机组合","componentId":null,"codeId":"404","destinationUrl":null,"isComponents":0,"shortNumber":1,"codeValue":"AP1706A012B14001D09001","destinationUrlType":null,"contentCode":"15100949","componentList":null,"groupBuyType":1,"salesVolume":"7","originalPrice":"1156","salePrice":"1069","discount":"9.2","integral":"0","remainingTime":null,"inStock":null,"gifts":null,"groupBuyTime":"100","firstImgUrl":"http://image1.ocj.com.cn/item_images/item/15/10/0949/15100949L.jpg"},{"id":"6277879541146845184","title":"德国进口可爱儿童水电费第三方第三方第三方第三方","componentId":null,"codeId":"404","destinationUrl":null,"isComponents":0,"shortNumber":2,"codeValue":"AP1706A012B14001D09001","destinationUrlType":null,"contentCode":"15174707","componentList":null,"groupBuyType":1,"salesVolume":"90","originalPrice":"544","salePrice":"243","discount":"4.4","integral":"10","remainingTime":null,"inStock":"库存紧张","gifts":null,"groupBuyTime":null,"firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/2017060109.jpg"},{"id":"6277879541146845184","title":"德国进口可爱儿童水电费第三方第三方第三方第三方","componentId":null,"codeId":"404","destinationUrl":null,"isComponents":0,"shortNumber":3,"codeValue":"AP1706A012B14001D09001","destinationUrlType":null,"contentCode":"15072557","componentList":null,"groupBuyType":1,"salesVolume":"90","originalPrice":"445","salePrice":"243","discount":"4.4","integral":"0","remainingTime":null,"inStock":"库存紧张","gifts":null,"groupBuyTime":null,"firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/2017060110.jpg"}],"groupBuyType":0,"salesVolume":null,"originalPrice":null,"salePrice":null,"discount":null,"integral":null,"remainingTime":"01:12:23","inStock":null,"gifts":null,"groupBuyTime":"14","firstImgUrl":null}]
     * packageList : null
     * styleMap : null
     */


    private String packageId;
    private String id;
    private Object codeId;
    private String codeValue;
    private int isPackages;
    private int shortNumber;
    private List<PackageListBean> packageList;
    private Map styleMap;
    private List<CmsItemsBean> componentList;

    public List<CmsItemsBean> getComponentList() {
        return componentList;
    }

    public void setComponentList(List<CmsItemsBean> componentList) {
        this.componentList = componentList;
    }

    public String getPackageId() {
        return packageId;
    }

    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Object getCodeId() {
        return codeId;
    }

    public void setCodeId(Object codeId) {
        this.codeId = codeId;
    }

    public String getCodeValue() {
        return codeValue;
    }

    public void setCodeValue(String codeValue) {
        this.codeValue = codeValue;
    }

    public int getIsPackages() {
        return isPackages;
    }

    public void setIsPackages(int isPackages) {
        this.isPackages = isPackages;
    }

    public int getShortNumber() {
        return shortNumber;
    }

    public void setShortNumber(int shortNumber) {
        this.shortNumber = shortNumber;
    }

    public List<PackageListBean> getPackageList() {
        return packageList;
    }

    public void setPackageList(List<PackageListBean> packageList) {
        this.packageList = packageList;
    }

    public Map getStyleMap() {
        return styleMap;
    }

    public void setStyleMap(Map styleMap) {
        this.styleMap = styleMap;
    }

}
