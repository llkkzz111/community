package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/7/29.<br/>
 * Description: GetFriendRemarkRequest
 */
public class GetFriendRemarkRequest extends BaseRequest{
    private long friendUserId;

    public GetFriendRemarkRequest() {
    }

    public GetFriendRemarkRequest(long friendUserId) {
        this.friendUserId = friendUserId;
    }

    public long getFriendUserId() {
        return friendUserId;
    }

    public void setFriendUserId(long friendUserId) {
        this.friendUserId = friendUserId;
    }
}
