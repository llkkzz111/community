package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/6/14.
 */

public class LotteryListDataBean {

    /**
     * drawN  表示未中奖， drawY 表示中奖 drawF 表示失败 drawW 表示等待  drawYN  表示未开奖
     */
    private String drawYN;
    private String ball;
    private String drawNo;

    public String getDrawYN() {
        return drawYN;
    }

    public void setDrawYN(String drawYN) {
        this.drawYN = drawYN;
    }

    public String getBall() {
        return ball;
    }

    public void setBall(String ball) {
        this.ball = ball;
    }

    public String getDrawNo() {
        return drawNo;
    }

    public void setDrawNo(String drawNo) {
        this.drawNo = drawNo;
    }
}
