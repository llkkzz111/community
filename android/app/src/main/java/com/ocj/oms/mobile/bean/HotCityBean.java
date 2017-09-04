package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 20:21
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class HotCityBean {

    private List<ResultBean> result;

    public List<ResultBean> getResult() {
        return result;
    }

    public void setResult(List<ResultBean> result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "HotCityBean{" +
                "result=" + result +
                '}';
    }
}
