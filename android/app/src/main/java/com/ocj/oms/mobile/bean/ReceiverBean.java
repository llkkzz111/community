package com.ocj.oms.mobile.bean;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/9 21:57
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

class ReceiverBean {
    /**
     * hp_no : 15900400988
     * receiver_name : ghkjgjkghkjgjkJddjjd
     * receiver_addr : 上海市闵行区Dnnjdjdjdj
     */

    private String hp_no;
    private String receiver_name;
    private String receiver_addr;
    private String receiver_seq;

    public String getReceiver_seq() {
        return receiver_seq;
    }

    public void setReceiver_seq(String receiver_seq) {
        this.receiver_seq = receiver_seq;
    }

    public String getHp_no() {
        return hp_no;
    }

    public void setHp_no(String hp_no) {
        this.hp_no = hp_no;
    }

    public String getReceiver_name() {
        return receiver_name;
    }

    public void setReceiver_name(String receiver_name) {
        this.receiver_name = receiver_name;
    }

    public String getReceiver_addr() {
        return receiver_addr;
    }

    public void setReceiver_addr(String receiver_addr) {
        this.receiver_addr = receiver_addr;
    }

    @Override
    public String toString() {
        return "ReceiverBean{" +
                "hp_no='" + hp_no + '\'' +
                ", receiver_name='" + receiver_name + '\'' +
                ", receiver_addr='" + receiver_addr + '\'' +
                '}';
    }
}
