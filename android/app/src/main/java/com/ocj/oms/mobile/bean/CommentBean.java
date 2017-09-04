package com.ocj.oms.mobile.bean;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/13 16:55
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class CommentBean {


    /**
     * item_code : 2831282013
     * order_no : 20170606120370
     * evaluate : 这个商品牛牛牛
     * score1 : 5
     * score2 : 5
     * score3 : 5
     * score4 : 5
     */
//item_code 商品
// order_no 订单编号
// score1 商品质量
// score2 商品价格
// score3 配送速度
// score4 商品服务
// evaluate 评价内容
// item_price 商品价格
// item_name 商品名称
// src 图片地址
    private String item_code;
    private String order_no;
    private String score1;
    private String score2;
    private String score3;
    private String score4;
    private String evaluate;
    private String src;

    public String getSrc() {
        return src;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getItem_code() {
        return item_code;
    }

    public void setItem_code(String item_code) {
        this.item_code = item_code;
    }

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public String getEvaluate() {
        return evaluate;
    }

    public void setEvaluate(String evaluate) {
        this.evaluate = evaluate;
    }

    public String getScore1() {
        return score1;
    }

    public void setScore1(String score1) {
        this.score1 = score1;
    }

    public String getScore2() {
        return score2;
    }

    public void setScore2(String score2) {
        this.score2 = score2;
    }

    public String getScore3() {
        return score3;
    }

    public void setScore3(String score3) {
        this.score3 = score3;
    }

    public String getScore4() {
        return score4;
    }

    public void setScore4(String score4) {
        this.score4 = score4;
    }

    @Override
    public String toString() {
        return "CommentBean{" +
                "item_code='" + item_code + '\'' +
                ", order_no='" + order_no + '\'' +
                ", evaluate='" + evaluate + '\'' +
                ", score1='" + score1 + '\'' +
                ", score2='" + score2 + '\'' +
                ", score3='" + score3 + '\'' +
                ", score4='" + score4 + '\'' +
                '}';
    }
}
