package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/5/31.
 */

public class TaoVocherList {

    /**
     * taolist : [{"DCRATE":0,"DCCOUPONCONTENT":"随便鸥券B","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"随便鸥券B","MIN_ITEM_COUNT":0,"PAGE":1,"DCBDATE":"2016-05-31 17","COUPONNO":"2016053100000324","DCAMT":14,"TOTALSIZE":9,"DCEDATE":"2216-07-30 00","MIN_ORDER_AMT":10},{"DCRATE":0,"DCCOUPONCONTENT":"随便鸥券A333","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"结算变更欧券061403","MIN_ITEM_COUNT":10,"PAGE":1,"DCBDATE":"2016-06-14 14","COUPONNO":"2016061400000334","DCAMT":5,"TOTALSIZE":9,"DCEDATE":"2216-08-01 00","MIN_ORDER_AMT":1},{"DCRATE":0,"DCCOUPONCONTENT":"随便鸥券A","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"结算变更欧券061406","MIN_ITEM_COUNT":10,"PAGE":1,"DCBDATE":"2016-06-14 14","COUPONNO":"2016061400000337","DCAMT":5,"TOTALSIZE":9,"DCEDATE":"2216-08-01 00","MIN_ORDER_AMT":1},{"DCRATE":0,"DCCOUPONCONTENT":"[xml]跨境通一般鸥券0811","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"[xml]跨境通一般鸥券0811","MIN_ITEM_COUNT":0,"PAGE":1,"DCBDATE":"2016-08-11 00","COUPONNO":"2016081100000356","DCAMT":5,"TOTALSIZE":9,"DCEDATE":"2017-09-12 00","MIN_ORDER_AMT":5},{"DCRATE":0,"DCCOUPONCONTENT":"[xml]跨境通购物车定额券0815","DC_TYPE":"1","DCGB":"10","DCCOUPONNAME":"[xml]跨境通购物车定额券0815","MIN_ITEM_COUNT":2,"PAGE":1,"DCBDATE":"2016-08-15 00","COUPONNO":"2016081500000358","DCAMT":10,"TOTALSIZE":9,"DCEDATE":"2017-08-16 00","MIN_ORDER_AMT":10},{"DCRATE":0,"DCCOUPONCONTENT":"[xml]有效期改善/一般兑换券/不指定时间","DC_TYPE":"2","DCGB":"10","DCCOUPONNAME":"[xml]有效期改善/一般兑换券/不指定时间","MIN_ITEM_COUNT":0,"PAGE":1,"DCBDATE":"2016-10-21 18","COUPONNO":"2016102100000411","DCAMT":14,"TOTALSIZE":9,"DCEDATE":"2017-11-22 00","MIN_ORDER_AMT":10},{"DCRATE":0,"DCCOUPONCONTENT":"[xml]1110/一般/领取/不指定/0天后生效","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"[xml]1110/一般/领取/不指定/0天后生效","MIN_ITEM_COUNT":1,"PAGE":1,"DCBDATE":"2016-11-10 21","COUPONNO":"2016111000000445","DCAMT":20,"TOTALSIZE":9,"DCEDATE":"2017-12-11 00","MIN_ORDER_AMT":10},{"DCRATE":0,"DCCOUPONCONTENT":"[xml]1110/一般/领取/不指定/1天后生效","DC_TYPE":"0","DCGB":"10","DCCOUPONNAME":"[xml]1110/一般/领取/不指定/1天后生效","MIN_ITEM_COUNT":1,"PAGE":1,"DCBDATE":"2016-11-10 23","COUPONNO":"2016111000000446","DCAMT":21,"TOTALSIZE":9,"DCEDATE":"2017-12-11 00","MIN_ORDER_AMT":1},{"DCRATE":0,"DCCOUPONCONTENT":"服务类测试排外4444","DC_TYPE":"2","DCGB":"10","DCCOUPONNAME":"服务类测试排外4444","MIN_ITEM_COUNT":0,"PAGE":1,"DCBDATE":"2015-08-20 16","COUPONNO":"2015082000000238","DCAMT":20,"TOTALSIZE":9,"DCEDATE":"2017-10-22 00","MIN_ORDER_AMT":50}]
     * cust_no : 201111329931
     * type : no
     * maxPage : 1
     */

    private String cust_no;
    private String type;
    private int maxPage;
    private List<TaoVocherBean> taolist;

    public String getCust_no() {
        return cust_no;
    }

    public void setCust_no(String cust_no) {
        this.cust_no = cust_no;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getMaxPage() {
        return maxPage;
    }

    public void setMaxPage(int maxPage) {
        this.maxPage = maxPage;
    }

    public List<TaoVocherBean> getTaolist() {
        return taolist;
    }

    public void setTaolist(List<TaoVocherBean> taolist) {
        this.taolist = taolist;
    }

}
