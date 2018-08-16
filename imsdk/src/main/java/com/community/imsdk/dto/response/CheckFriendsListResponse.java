package com.community.imsdk.dto.response;

/**
 * Created by dufeng on 16/8/1.<br/>
 * Description: CheckFriendsListResponse
 */
public class CheckFriendsListResponse extends BaseResponse {
    private boolean status;

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
