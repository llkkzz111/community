package com.community.imsdk.db.bean;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
// KEEP INCLUDES END
/**
 * Entity mapped to table "PRIVATE_MESSAGE".
 */
public class PrivateMessage implements java.io.Serializable {

    private Long id;
    private long chatId;
    private int chatType;
    private Long sendUserId;
    private Integer sendUserType;
    private String content;
    private Integer contentType;
    private int sessionType;
    private Integer sendStatus;
    private long msgId;
    private Long timestamp;

    // KEEP FIELDS - put your custom fields here
    public static final int SEND_SUCCESS = 1;
    public static final int RECEVE_SUCCESS = 2;
    public static final int SEND_FAIL = 3;
    public static final int SENDING = 4;
    // KEEP FIELDS END

    public PrivateMessage() {
    }

    public PrivateMessage(Long id) {
        this.id = id;
    }

    public PrivateMessage(Long id, long chatId, int chatType, Long sendUserId, Integer sendUserType, String content, Integer contentType, int sessionType, Integer sendStatus, long msgId, Long timestamp) {
        this.id = id;
        this.chatId = chatId;
        this.chatType = chatType;
        this.sendUserId = sendUserId;
        this.sendUserType = sendUserType;
        this.content = content;
        this.contentType = contentType;
        this.sessionType = sessionType;
        this.sendStatus = sendStatus;
        this.msgId = msgId;
        this.timestamp = timestamp;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public long getChatId() {
        return chatId;
    }

    public void setChatId(long chatId) {
        this.chatId = chatId;
    }

    public int getChatType() {
        return chatType;
    }

    public void setChatType(int chatType) {
        this.chatType = chatType;
    }

    public Long getSendUserId() {
        return sendUserId;
    }

    public void setSendUserId(Long sendUserId) {
        this.sendUserId = sendUserId;
    }

    public Integer getSendUserType() {
        return sendUserType;
    }

    public void setSendUserType(Integer sendUserType) {
        this.sendUserType = sendUserType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getContentType() {
        return contentType;
    }

    public void setContentType(Integer contentType) {
        this.contentType = contentType;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }

    public Integer getSendStatus() {
        return sendStatus;
    }

    public void setSendStatus(Integer sendStatus) {
        this.sendStatus = sendStatus;
    }

    public long getMsgId() {
        return msgId;
    }

    public void setMsgId(long msgId) {
        this.msgId = msgId;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    // KEEP METHODS - put your custom methods here
    public String showTextContent() {
        String str;
        switch (contentType) {
            default:
                str = content;
                break;
        }
        return str;
    }
    // KEEP METHODS END

}
