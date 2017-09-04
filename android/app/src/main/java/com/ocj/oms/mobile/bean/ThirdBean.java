package com.ocj.oms.mobile.bean;

/**
 * Created by yy on 2017/5/13.
 * <p>
 * 授权后请求本地服务返回
 */

public class ThirdBean extends UserInfo {

    private String result;
    private String associate_state;


    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getAssociateState() {
        return associate_state;
    }

    public void setAssociate_state(String associate_state) {
        this.associate_state = associate_state;
    }


}
