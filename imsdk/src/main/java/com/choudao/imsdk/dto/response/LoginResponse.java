package com.choudao.imsdk.dto.response;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: SIRequest
 */
public class LoginResponse extends BaseResponse{

    private long timestamp;

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}
