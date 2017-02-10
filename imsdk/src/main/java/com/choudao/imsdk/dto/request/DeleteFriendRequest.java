package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/7/29.<br/>
 * Description: DeleteFriendRequest
 */
public class DeleteFriendRequest extends BaseRequest {
    private long friendUserId;

    public DeleteFriendRequest() {
    }

    public DeleteFriendRequest(long friendUserId) {
        this.friendUserId = friendUserId;
    }

    public long getFriendUserId() {
        return friendUserId;
    }

    public void setFriendUserId(long friendUserId) {
        this.friendUserId = friendUserId;
    }
}
