package com.ocj.oms.mobile.bean;

/**
 * Created by admin-ocj on 2017/7/10.
 */

public class RNParamBean {
    public String beforepage;
    public String fromPage;

    public String getBeforepage() {
        return beforepage;
    }

    public void setBeforepage(String beforepage) {
        this.beforepage = beforepage;
    }

    public String getFromPage() {
        return fromPage;
    }

    public void setFromPage(String fromPage) {
        this.fromPage = fromPage;
    }

    @Override
    public String toString() {
        return "{" +
                "beforepage='" + beforepage + '\'' +
                ", fromPage='" + fromPage + '\'' +
                '}';
    }
}
