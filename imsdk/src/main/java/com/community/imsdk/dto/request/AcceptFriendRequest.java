package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/8/25.<br/>
 * Description: AcceptFriendRequest
 */
public class AcceptFriendRequest extends BaseRequest {
    private long userId;
    private long id;

    public AcceptFriendRequest() {
    }

    public AcceptFriendRequest(long userId,long id) {
        this.userId = userId;
        this.id = id;
    }

    public long showUserId() {
        return userId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }
}
