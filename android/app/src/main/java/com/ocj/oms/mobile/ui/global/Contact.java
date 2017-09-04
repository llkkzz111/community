package com.ocj.oms.mobile.ui.global;

/**
 * Created by shizhang.cai on 2017/6/7.
 */

public class Contact {
    private String index;
    private String name;
    private String code;

    public void setIndex(String index) {
        this.index = index;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Contact() {
    }

    public Contact(String index, String name, String code) {
        this.index = index;
        this.name = name;
        this.code = code;
    }


    public String getIndex() {
        return index;
    }

    public String getName() {
        return name;
    }


}