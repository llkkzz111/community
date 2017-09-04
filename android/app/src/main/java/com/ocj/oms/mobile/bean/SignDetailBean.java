package com.ocj.oms.mobile.bean;

import android.text.TextUtils;

/**
 * Created by liutao on 2017/6/13.
 */

public class SignDetailBean {

    /**
     * fctYn : fctN  --当月是否领取彩票  --fctN表示未领取，fctY表示已领取
     * liBaoYn : liBaoN  --libaoN 表示未领取礼包 --libaoY表示已经领取礼包
     * signYn : todayY  --今天是否签到   todayY表示今天已签到，todayN表示没有签到
     * monthDay : 1  --签到天数
     * isApp : false   --是否是APP
     * fctG : fctN  --表示没有领取彩票 --fctY表示已经领取彩票
     * opoint_money : 50
     */

    private String fctYn;
    private String liBaoYn;
    private String signYn;
    private int monthDay;
    private boolean isApp;
    private String fctG;
    private int opoint_money;


    public String getFctYn() {
        return fctYn;
    }

    public void setFctYn(String fctYn) {
        this.fctYn = fctYn;
    }

    public String getLiBaoYn() {
        return TextUtils.isEmpty(liBaoYn) ? liBaoYn : liBaoYn.toLowerCase();
    }

    public void setLiBaoYn(String liBaoYn) {
        this.liBaoYn = liBaoYn;
    }

    public String getSignYn() {
        return TextUtils.isEmpty(signYn) ? signYn : signYn.toLowerCase();
    }

    public void setSignYn(String signYn) {
        this.signYn = signYn;
    }

    public int getMonthDay() {
        return monthDay;
    }

    public void setMonthDay(int monthDay) {
        this.monthDay = monthDay;
    }

    public boolean isIsApp() {
        return isApp;
    }

    public void setIsApp(boolean isApp) {
        this.isApp = isApp;
    }

    public String getFctG() {
        return TextUtils.isEmpty(fctG) ? fctG : fctG.toLowerCase();
    }

    public void setFctG(String fctG) {
        this.fctG = fctG;
    }

    public int getOpoint_money() {
        return opoint_money;
    }

    public void setOpoint_money(int opoint_money) {
        this.opoint_money = opoint_money;
    }
}
