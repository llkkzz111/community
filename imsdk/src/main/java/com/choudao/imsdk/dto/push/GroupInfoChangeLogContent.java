package com.choudao.imsdk.dto.push;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: GroupInfoChangeLogContent
 */

public class GroupInfoChangeLogContent {

    private String data;

    private int type;

    private int version;

    private long time;

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }
}
