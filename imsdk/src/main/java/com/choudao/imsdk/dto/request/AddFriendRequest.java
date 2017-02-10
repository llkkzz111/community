package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/8/25.<br/>
 * Description: AddFriendRequest
 */
public class AddFriendRequest extends BaseRequest {
    private long friendUserId;

    private String msg;

    public AddFriendRequest() {
    }

    public AddFriendRequest(long friendUserId, String msg) {
        this.friendUserId = friendUserId;
        this.msg = msg;
    }

    public long getFriendUserId() {
        return friendUserId;
    }

    public void setFriendUserId(long friendUserId) {
        this.friendUserId = friendUserId;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
