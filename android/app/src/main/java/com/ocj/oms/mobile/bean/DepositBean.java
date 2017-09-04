package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/5/24.
 */

public class DepositBean {

    /**
     * order_no : 20170425180026
     * deposit_note : [今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]
     * totalcnt : 592
     * depositamt_gb : 订购使用
     * proc_date : 2017-04-25
     * depositamt : -20
     */

    private String order_no;
    private String deposit_note;
    private String totalcnt;
    private String depositamt_gb;
    private String proc_date;
    private String depositamt;

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public String getDeposit_note() {
        return deposit_note;
    }

    public void setDeposit_note(String deposit_note) {
        this.deposit_note = deposit_note;
    }

    public String getTotalcnt() {
        return totalcnt;
    }

    public void setTotalcnt(String totalcnt) {
        this.totalcnt = totalcnt;
    }

    public String getDepositamt_gb() {
        return depositamt_gb;
    }

    public void setDepositamt_gb(String depositamt_gb) {
        this.depositamt_gb = depositamt_gb;
    }

    public String getProc_date() {
        return proc_date;
    }

    public void setProc_date(String proc_date) {
        this.proc_date = proc_date;
    }

    public String getDepositamt() {
        return depositamt;
    }

    public void setDepositamt(String depositamt) {
        this.depositamt = depositamt;
    }
}
