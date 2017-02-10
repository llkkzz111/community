package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/8/1.<br/>
 * Description: CheckFriendListRequest
 */
public class CheckFriendsListRequest extends BaseRequest {
    private int version;

    public CheckFriendsListRequest() {
    }

    public CheckFriendsListRequest(int version) {
        this.version = version;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }
}
