package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/6/22.
 */

public class SubmitReserveOrderBean {


    /**
     * order_no : 20170618119220
     * msg :
     * remainAmt : 298
     * hp_no : 13511183211
     * tel_no : 135111832
     * success : OK
     * receiver_addr : 上海市普陀区长阳路7777号
     * rc_name : 刘仪伟
     * pay_flg : 1
     */

    private String order_no;
    private String msg;
    private int remainAmt;
    private String hp_no;
    private String tel_no;
    private String success;
    private String receiver_addr;
    private String rc_name;
    private String pay_flg;

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getRemainAmt() {
        return remainAmt;
    }

    public void setRemainAmt(int remainAmt) {
        this.remainAmt = remainAmt;
    }

    public String getHp_no() {
        return hp_no;
    }

    public void setHp_no(String hp_no) {
        this.hp_no = hp_no;
    }

    public String getTel_no() {
        return tel_no;
    }

    public void setTel_no(String tel_no) {
        this.tel_no = tel_no;
    }

    public String getSuccess() {
        return success;
    }

    public void setSuccess(String success) {
        this.success = success;
    }

    public String getReceiver_addr() {
        return receiver_addr;
    }

    public void setReceiver_addr(String receiver_addr) {
        this.receiver_addr = receiver_addr;
    }

    public String getRc_name() {
        return rc_name;
    }

    public void setRc_name(String rc_name) {
        this.rc_name = rc_name;
    }

    public String getPay_flg() {
        return pay_flg;
    }

    public void setPay_flg(String pay_flg) {
        this.pay_flg = pay_flg;
    }
}
