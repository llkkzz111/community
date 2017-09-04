package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/5/24.
 */

public class SaveamtList {
    private String usable_saveamt;
    private List<SaveamtBean> amtList;
    private int maxPage;

    public String getUsable_saveamt() {
        return usable_saveamt;
    }

    public void setUsable_saveamt(String usable_saveamt) {
        this.usable_saveamt = usable_saveamt;
    }

    public List<SaveamtBean> getAmtList() {

        return amtList;
    }

    public void setAmtList(List<SaveamtBean> amtList) {
        this.amtList = amtList;
    }

    public int getMaxPage() {
        return maxPage;
    }

    public void setMaxPage(int maxPage) {
        this.maxPage = maxPage;
    }
}
