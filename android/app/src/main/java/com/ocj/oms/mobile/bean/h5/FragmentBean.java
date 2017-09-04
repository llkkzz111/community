package com.ocj.oms.mobile.bean.h5;

/**
 * Created by liuzhao on 2017/6/30.
 */

public class FragmentBean {

    /**
     * action : share
     * param : {"image_url":"http://cdnimg.ocj.com.cn/item_images/item/B1/31/41/B13141S.jpg","title":"东方购物鸥家俱乐部一款商品：惠人原汁机置物架，鸥点数仅需：10，大家快来抢吧！","target_url":"http://rm.ocj.com.cn/oclub/tryout/O131412017"}
     */

    private String action;
    private H5ParamsBean param;
    private String url;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public H5ParamsBean getParam() {
        return param;
    }

    public void setParam(H5ParamsBean param) {
        this.param = param;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
