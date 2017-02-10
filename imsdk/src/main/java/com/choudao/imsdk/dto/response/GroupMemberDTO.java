package com.choudao.imsdk.dto.response;

/**
 * Created by dufeng on 16/11/2.<br/>
 * Description: GroupMemberDTO
 */

public class GroupMemberDTO {
    private long id;
    private long userId;
    private String remark;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
