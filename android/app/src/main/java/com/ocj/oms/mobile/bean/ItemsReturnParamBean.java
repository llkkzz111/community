package com.ocj.oms.mobile.bean;

/**
 * Created by liu on 2017/6/12.
 */

public class ItemsReturnParamBean {
    public String orderGSeq;//	订单商品序号1
    public String orderDSeq;//	赠品序号1
    public String orderWSeq;//	操作序号1
    public String retExchQty;//	退货/交换数量1
    public String retItemCode;//	回收商品编号1
    public String retUnitCode;//	回收商品单件号1
    public String exchItemCode;//	新商品编号（换货）1
    public String exchUnitCode;//	新单件编号（换货）1

    public String getOrderGSeq() {
        return orderGSeq;
    }

    public void setOrderGSeq(String orderGSeq) {
        this.orderGSeq = orderGSeq;
    }

    public String getOrderDSeq() {
        return orderDSeq;
    }

    public void setOrderDSeq(String orderDSeq) {
        this.orderDSeq = orderDSeq;
    }

    public String getOrderWSeq() {
        return orderWSeq;
    }

    public void setOrderWSeq(String orderWSeq) {
        this.orderWSeq = orderWSeq;
    }

    public String getRetExchQty() {
        return retExchQty;
    }

    public void setRetExchQty(String retExchQty) {
        this.retExchQty = retExchQty;
    }

    public String getRetItemCode() {
        return retItemCode;
    }

    public void setRetItemCode(String retItemCode) {
        this.retItemCode = retItemCode;
    }

    public String getRetUnitCode() {
        return retUnitCode;
    }

    public void setRetUnitCode(String retUnitCode) {
        this.retUnitCode = retUnitCode;
    }

    public String getExchItemCode() {
        return exchItemCode;
    }

    public void setExchItemCode(String exchItemCode) {
        this.exchItemCode = exchItemCode;
    }

    public String getExchUnitCode() {
        return exchUnitCode;
    }

    public void setExchUnitCode(String exchUnitCode) {
        this.exchUnitCode = exchUnitCode;
    }
}
