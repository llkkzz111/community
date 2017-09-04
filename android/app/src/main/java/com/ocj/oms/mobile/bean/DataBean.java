package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/9 21:57
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class DataBean {
    /**
     * order_no : 20170609172784
     * youhu_dcamt : 0
     * order_date : 2017-06-09 14:12:39.0
     * pay_amt : 0
     * receiver : {"hp_no":"15900400988","receiver_name":"ghkjgjkghkjgjkJddjjd","receiver_addr":"上海市闵行区Dnnjdjdjdj"}
     * cupon_dcamt : 0
     * items : [{"dt_info":"无","order_d_seq":"001","rsale_amt":135,"contentLink":"http://awww.ocj.com.cn/detail/2831282013","item_name":"统一冰红茶500ML*45瓶","order_w_seq":"001","order_qty":1,"saveamt":0}]
     */

    private String order_no;
    private String youhu_dcamt;
    private String order_date;
    private String pay_amt;
    private ReceiverBean receiver;
    private String cupon_dcamt;
    private List<ItemsBeanX> items;
    private String linePay_name;
    private String freight;
    private String saveamt;
    private String showCancelOrderButtonYn;
    private String proc_state_str;
    private String no_pay_amt;
    private String sum_amt;
    private String isShowFapiao;
    private String curr_time;
    private String isShowComment;
    private String giftcard;
    private String OnlineSub;
    private String end_time;
    private String isShowWuliu;
    private String cancleReason;
    private String isNoPayButton;
    private String postalTaxAmt;
    private String isShowReceiver;
    private String showAmtStr;
    private String isNoPay;
    private String deposit;
    private String order_close_date;
    private String showAmt;
    private String isAllReturn;
    private String payDate;


    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }


    public String getOrder_date() {
        return order_date;
    }

    public void setOrder_date(String order_date) {
        this.order_date = order_date;
    }

    public ReceiverBean getReceiver() {
        return receiver;
    }

    public void setReceiver(ReceiverBean receiver) {
        this.receiver = receiver;
    }


    public List<ItemsBeanX> getItems() {
        return items;
    }

    public void setItems(List<ItemsBeanX> items) {
        this.items = items;
    }

    public String getYouhu_dcamt() {
        return youhu_dcamt;
    }

    public void setYouhu_dcamt(String youhu_dcamt) {
        this.youhu_dcamt = youhu_dcamt;
    }

    public String getPay_amt() {
        return pay_amt;
    }

    public void setPay_amt(String pay_amt) {
        this.pay_amt = pay_amt;
    }

    public String getCupon_dcamt() {
        return cupon_dcamt;
    }

    public void setCupon_dcamt(String cupon_dcamt) {
        this.cupon_dcamt = cupon_dcamt;
    }

    public String getLinePay_name() {
        return linePay_name;
    }

    public void setLinePay_name(String linePay_name) {
        this.linePay_name = linePay_name;
    }

    public String getFreight() {
        return freight;
    }

    public void setFreight(String freight) {
        this.freight = freight;
    }

    public String getSaveamt() {
        return saveamt;
    }

    public void setSaveamt(String saveamt) {
        this.saveamt = saveamt;
    }

    public String getShowCancelOrderButtonYn() {
        return showCancelOrderButtonYn;
    }

    public void setShowCancelOrderButtonYn(String showCancelOrderButtonYn) {
        this.showCancelOrderButtonYn = showCancelOrderButtonYn;
    }

    public String getProc_state_str() {
        return proc_state_str;
    }

    public void setProc_state_str(String proc_state_str) {
        this.proc_state_str = proc_state_str;
    }

    public String getNo_pay_amt() {
        return no_pay_amt;
    }

    public void setNo_pay_amt(String no_pay_amt) {
        this.no_pay_amt = no_pay_amt;
    }

    public String getSum_amt() {
        return sum_amt;
    }

    public void setSum_amt(String sum_amt) {
        this.sum_amt = sum_amt;
    }

    public String getIsShowFapiao() {
        return isShowFapiao;
    }

    public void setIsShowFapiao(String isShowFapiao) {
        this.isShowFapiao = isShowFapiao;
    }

    public String getCurr_time() {
        return curr_time;
    }

    public void setCurr_time(String curr_time) {
        this.curr_time = curr_time;
    }

    public String getIsShowComment() {
        return isShowComment;
    }

    public void setIsShowComment(String isShowComment) {
        this.isShowComment = isShowComment;
    }

    public String getGiftcard() {
        return giftcard;
    }

    public void setGiftcard(String giftcard) {
        this.giftcard = giftcard;
    }

    public String getOnlineSub() {
        return OnlineSub;
    }

    public void setOnlineSub(String onlineSub) {
        OnlineSub = onlineSub;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public String getIsShowWuliu() {
        return isShowWuliu;
    }

    public void setIsShowWuliu(String isShowWuliu) {
        this.isShowWuliu = isShowWuliu;
    }

    public String getCancleReason() {
        return cancleReason;
    }

    public void setCancleReason(String cancleReason) {
        this.cancleReason = cancleReason;
    }

    public String getIsNoPayButton() {
        return isNoPayButton;
    }

    public void setIsNoPayButton(String isNoPayButton) {
        this.isNoPayButton = isNoPayButton;
    }

    public String getPostalTaxAmt() {
        return postalTaxAmt;
    }

    public void setPostalTaxAmt(String postalTaxAmt) {
        this.postalTaxAmt = postalTaxAmt;
    }

    public String getIsShowReceiver() {
        return isShowReceiver;
    }

    public void setIsShowReceiver(String isShowReceiver) {
        this.isShowReceiver = isShowReceiver;
    }

    public String getShowAmtStr() {
        return showAmtStr;
    }

    public void setShowAmtStr(String showAmtStr) {
        this.showAmtStr = showAmtStr;
    }

    public String getIsNoPay() {
        return isNoPay;
    }

    public void setIsNoPay(String isNoPay) {
        this.isNoPay = isNoPay;
    }

    public String getDeposit() {
        return deposit;
    }

    public void setDeposit(String deposit) {
        this.deposit = deposit;
    }

    public String getOrder_close_date() {
        return order_close_date;
    }

    public void setOrder_close_date(String order_close_date) {
        this.order_close_date = order_close_date;
    }

    public String getShowAmt() {
        return showAmt;
    }

    public void setShowAmt(String showAmt) {
        this.showAmt = showAmt;
    }

    public String getIsAllReturn() {
        return isAllReturn;
    }

    public void setIsAllReturn(String isAllReturn) {
        this.isAllReturn = isAllReturn;
    }

    public String getPayDate() {
        return payDate;
    }

    public void setPayDate(String payDate) {
        this.payDate = payDate;
    }

    @Override
    public String toString() {
        return "DataBean{" +
                "order_no='" + order_no + '\'' +
                ", youhu_dcamt=" + youhu_dcamt +
                ", order_date='" + order_date + '\'' +
                ", pay_amt=" + pay_amt +
                ", receiver=" + receiver +
                ", cupon_dcamt=" + cupon_dcamt +
                ", items=" + items +
                '}';
    }
}
