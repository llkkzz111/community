package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/9/26.<br/>
 * Description: GetFriendConfirmationRequest
 */

public class GetFriendConfirmationRequest extends BaseRequest {

    private long friendUserId;

    public GetFriendConfirmationRequest() {
    }

    public GetFriendConfirmationRequest(long friendUserId) {
        this.friendUserId = friendUserId;
    }

    public long getFriendUserId() {
        return friendUserId;
    }

    public void setFriendUserId(long friendUserId) {
        this.friendUserId = friendUserId;
    }
}
