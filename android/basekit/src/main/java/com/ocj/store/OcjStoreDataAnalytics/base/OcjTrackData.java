package com.ocj.store.OcjStoreDataAnalytics.base;

import java.util.Date;

/**
 * Created by apple on 2017/5/18.
 */
//基础数据类，如果新扩展埋点接口，数据对象可从该类继承
public class OcjTrackData {
    //数据类型，标识是哪种类型的数据：页面日志，一个参数的事件，两个参数的事件，三个参数的事件
    private String sign;

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }
}
