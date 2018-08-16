package com.community.imsdk.dto.response;

/**
 * Created by dufeng on 16/9/27.<br/>
 * Description: GetFriendConfirmationResponse
 */

public class GetFriendConfirmationResponse extends BaseResponse {
    private boolean status;

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
