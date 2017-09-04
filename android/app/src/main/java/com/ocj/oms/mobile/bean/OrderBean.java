package com.ocj.oms.mobile.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by liu on 2017/6/2.
 */

public class OrderBean implements Serializable {

    /**
     * order_no : 20170602172339
     * c_code : 2000
     * imgUrlList : ["http://image1.ocj.com.cn/item_images/item/28/31/28/283128P.jpg"]
     * double_deposit : 1.000401107E7
     * double_cardamt : 1997863
     * double_saveamt : 150000
     * cust_no : 201112005589
     * realPayAmt : 135
     * useable_deposit : 10,004,011.07
     * lastPayment : [{"title":"浦发银行","id":"46"},{"title":"建设银行","id":"8"},{"title":"支付宝钱包","id":"38"},{"title":"微信支付","id":"39"},{"title":"货到刷银行卡","id":"2_1"},{"title":"积分付款","id":"4"},{"title":"预付款支付","id":"5"},{"title":"礼品卡支付","id":"3"},{"title":"银联在线支付","id":"45"},{"title":"苹果支付","id":"49"},{"title":"交行信用卡","id":"51"},{"title":"小浦支付","id":"53"}]
     * useable_cardamt : 1,997,863
     * useable_saveamt : 150,000
     */

    private String order_no;
    private String c_code;
    private String cust_no;
    private float realPayAmt;

    private float double_deposit;
    private float double_cardamt;
    private float double_saveamt;

    private String useable_deposit;
    private String useable_cardamt;
    private String useable_saveamt;

    private String payStyle;

    private String saveamt_yn;
    private String deposit_yn;
    private String cardamt_yn;


    private float online_redu_5;//是否是在线支付立减5元的商品

    private List<String> imgUrlList;
    private List<LastPaymentBean> lastPayment;

    public String getSaveamt_yn() {
        return saveamt_yn;
    }

    public void setSaveamt_yn(String saveamt_yn) {
        this.saveamt_yn = saveamt_yn;
    }

    public String getDeposit_yn() {
        return deposit_yn;
    }

    public void setDeposit_yn(String deposit_yn) {
        this.deposit_yn = deposit_yn;
    }

    public String getCardamt_yn() {
        return cardamt_yn;
    }

    public void setCardamt_yn(String cardamt_yn) {
        this.cardamt_yn = cardamt_yn;
    }

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public String getC_code() {
        return c_code;
    }

    public void setC_code(String c_code) {
        this.c_code = c_code;
    }

    public float getDouble_deposit() {
        return double_deposit;
    }

    public void setDouble_deposit(float double_deposit) {
        this.double_deposit = double_deposit;
    }

    public float getDouble_cardamt() {
        return double_cardamt;
    }

    public void setDouble_cardamt(float double_cardamt) {
        this.double_cardamt = double_cardamt;
    }

    public float getDouble_saveamt() {
        return double_saveamt;
    }

    public void setDouble_saveamt(int double_saveamt) {
        this.double_saveamt = double_saveamt;
    }

    public String getCust_no() {
        return cust_no;
    }

    public void setCust_no(String cust_no) {
        this.cust_no = cust_no;
    }

    public float getRealPayAmt() {
        return realPayAmt;
    }

    public void setRealPayAmt(int realPayAmt) {
        this.realPayAmt = realPayAmt;
    }

    public String getUseable_deposit() {
        return useable_deposit;
    }

    public void setUseable_deposit(String useable_deposit) {
        this.useable_deposit = useable_deposit;
    }

    public String getUseable_cardamt() {
        return useable_cardamt;
    }

    public void setUseable_cardamt(String useable_cardamt) {
        this.useable_cardamt = useable_cardamt;
    }

    public String getUseable_saveamt() {
        return useable_saveamt;
    }

    public void setUseable_saveamt(String useable_saveamt) {
        this.useable_saveamt = useable_saveamt;
    }

    public String getPayStyle() {
        return payStyle;
    }

    public void setPayStyle(String payStyle) {
        this.payStyle = payStyle;
    }

    public List<String> getImgUrlList() {
        return imgUrlList;
    }

    public void setImgUrlList(List<String> imgUrlList) {
        this.imgUrlList = imgUrlList;
    }

    public List<LastPaymentBean> getLastPayment() {
        return lastPayment;
    }

    public void setLastPayment(List<LastPaymentBean> lastPayment) {
        this.lastPayment = lastPayment;
    }

    public float isOnline_redu_5() {
        return online_redu_5;
    }

    public void setOnline_redu_5(float online_redu_5) {
        this.online_redu_5 = online_redu_5;
    }


    public static class LastPaymentBean implements Serializable {

        /**
         * title : 浦发银行
         * id : 46
         */
        private String title;
        private String id;
        private String iocnUrl;//银行的icon
        private boolean check;
        private String eventContent;

        public String getEventContent() {
            return eventContent;
        }

        public void setEventContent(String eventContent) {
            this.eventContent = eventContent;
        }

        public LastPaymentBean(String title, String id) {
            this.title = title;
            this.id = id;
        }


        public String getIocnUrl() {
            return iocnUrl;
        }

        public void setIocnUrl(String iocnUrl) {
            this.iocnUrl = iocnUrl;
        }


        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public boolean isCheck() {
            return check;
        }

        public void setCheck(boolean check) {
            this.check = check;
        }
    }
}
