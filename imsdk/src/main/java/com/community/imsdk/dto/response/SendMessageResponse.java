package com.community.imsdk.dto.response;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: SPResponse
 */
public class SendMessageResponse extends BaseResponse {

    private long msgId;

    public long getMsgId() {
        return msgId;
    }

    public void setMsgId(long msgId) {
        this.msgId = msgId;
    }
}
