package com.choudao.imsdk.dto.push;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: GroupMemberChangeLogContent
 */

public class ChangeLogContent {
    private int type;

    private String data;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
