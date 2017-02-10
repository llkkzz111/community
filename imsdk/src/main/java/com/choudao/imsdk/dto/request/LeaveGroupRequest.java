package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/11/9.<br/>
 * Description: LeaveGroupRequest
 */

public class LeaveGroupRequest extends BaseRequest {
    private long id;

    public LeaveGroupRequest() {
    }

    public LeaveGroupRequest(long id) {
        this.id = id;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}
