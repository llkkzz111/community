package com.ocj.oms.mobile.bean;

import java.util.ArrayList;

/**
 * Created by liu on 2017/6/12.
 */

public class ItemReturnBody {
    public String retExchYn;

     public String orderNo;//":"20170606120360",
     public String receiverSeq;//":"0000001531",
     public String claimCode;//":"C02",
     public String claimDesc;//":"XXXXX",
     public String usedYn;//":"2",
     public String entiretyYn;//":"1",
     public String presentYn;//":"1",
     public String packageYn;//":"1",
     public String imgUrl;//":"https://111,https://222,https://333",
     public String refundSource;//":"1",

    public ArrayList<ItemsReturnParamBean> theList;

    public String getRetExchYn() {
        return retExchYn;
    }

    public void setRetExchYn(String retExchYn) {
        this.retExchYn = retExchYn;
    }

    public ArrayList<ItemsReturnParamBean> getTheList() {
        return theList;
    }

    public void setTheList(ArrayList<ItemsReturnParamBean> theList) {
        this.theList = theList;
    }
}
