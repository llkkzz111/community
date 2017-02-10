package com.choudao.imsdk.imutils.callback;


import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.request.BaseRequest;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: 消息状态分发用
 */
public class RequestInfo {

    private long createTime;
    private long timeOut;
    private BaseRequest request;
    private MessageType messageType;

    public RequestInfo(BaseRequest request, MessageType messageType) {
        createTime = System.currentTimeMillis();
        this.timeOut = 30 * 1000;
        this.request = request;
        this.messageType = messageType;
    }


    public long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(long createTime) {
        this.createTime = createTime;
    }

    public long getTimeOut() {
        return timeOut;
    }

    public void setTimeOut(long timeOut) {
        this.timeOut = timeOut;
    }

    public BaseRequest getRequest() {
        return request;
    }

    public void setRequest(BaseRequest request) {
        this.request = request;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public void setMessageType(MessageType messageType) {
        this.messageType = messageType;
    }
}
