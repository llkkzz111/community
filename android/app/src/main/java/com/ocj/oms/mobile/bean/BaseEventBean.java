package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/6/21.
 */

public class BaseEventBean {
    public String type;
    public Object data;

    public BaseEventBean(String type, Object data) {
        this.type = type;
        this.data = data;
    }
}
