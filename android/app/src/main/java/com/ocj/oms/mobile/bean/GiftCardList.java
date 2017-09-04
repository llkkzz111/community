package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by yy on 2017/5/20.
 */

public class GiftCardList {

    private int maxPage;
    private List<GiftCardBean> myEGiftCardList;

    public int getMaxPage() {
        return maxPage;
    }

    public void setMaxPage(int maxPage) {
        this.maxPage = maxPage;
    }

    public List<GiftCardBean> getMyEGiftCardList() {
        return myEGiftCardList;
    }

    public void setMyEGiftCardList(List<GiftCardBean> myEGiftCardList) {
        this.myEGiftCardList = myEGiftCardList;
    }
}
