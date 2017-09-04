package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/8/4.
 */

public class NoticeExtraBean {


    private String toPage;
    private ParamKey params;

    public String getToPage() {
        return toPage;
    }

    public void setToPage(String toPage) {
        this.toPage = toPage;
    }

    public ParamKey getParams() {
        return params;
    }

    public void setParams(ParamKey params) {
        this.params = params;
    }

    public class ParamKey {
        private String id;
        private String url;
        private String orderNo;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getOrderNo() {
            return orderNo;
        }

        public void setOrderNo(String orderNo) {
            this.orderNo = orderNo;
        }
    }


}
