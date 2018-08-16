package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/7/29.<br/>
 * Description: GetFriendRemarkRequest
 */
public class SetFriendRemarkRequest extends BaseRequest{
    private long friendUserId;
    private String remark;

    public SetFriendRemarkRequest() {
    }

    public SetFriendRemarkRequest(long friendUserId, String remark) {
        this.friendUserId = friendUserId;
        this.remark = remark;
    }

    public long getFriendUserId() {
        return friendUserId;
    }

    public void setFriendUserId(long friendUserId) {
        this.friendUserId = friendUserId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
}
