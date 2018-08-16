package com.community.imsdk.dto.push;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: PPResponse
 */
public class MessagesBean {

    private String content;
    private int contentType;
    private int sessionType;
    private long msgId;
    private long from;
    private long to;
    private long timestamp;

    public String getContent() {
        return content;
    }


    public void setContent(String content) {
        this.content = content;
    }

    public int getContentType() {
        return contentType;
    }

    public void setContentType(int contentType) {
        this.contentType = contentType;
    }

    public long getMsgId() {
        return msgId;
    }

    public void setMsgId(long msgId) {
        this.msgId = msgId;
    }

    public long getFrom() {
        return from;
    }


    public void setFrom(long userId) {
        this.from = userId;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public long getTo() {
        return to;
    }

    public void setTo(long to) {
        this.to = to;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }
}
