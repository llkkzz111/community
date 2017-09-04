package com.ocj.oms.mobile.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/12 14:07
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:修改后vip页面bean
 */

public class VipNewBean implements Serializable{


    private List<ResultBeanX> result;

    public List<ResultBeanX> getResult() {
        return result;
    }

    public void setResult(List<ResultBeanX> result) {
        this.result = result;
    }
}
