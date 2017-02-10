package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/6/17.<br/>
 * Description: MessageAckRequest
 */
public class MessageAckRequest extends BaseRequest {

    private long targetId;

    private int sessionType;

    private long msgId;

    public MessageAckRequest() {
    }

    public MessageAckRequest(long targetId, int sessionType, long msgId) {
        this.targetId = targetId;
        this.sessionType = sessionType;
        this.msgId = msgId;
    }

    public long getTargetId() {
        return targetId;
    }

    public void setTargetId(long targetId) {
        this.targetId = targetId;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }

    public long getMsgId() {
        return msgId;
    }

    public void setMsgId(long msgId) {
        this.msgId = msgId;
    }
}
