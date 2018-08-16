package com.community.imsdk.db.bean;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
// KEEP INCLUDES END
/**
 * Entity mapped to table "MESSAGE".
 */
public class Message implements java.io.Serializable {

    private Long id;
    private long chatId;
    private Integer chatType;
    private Long sendUserId;
    private Integer sendUserType;
    private String content;
    private Integer contentType;
    private int sessionType;
    private Integer sendStatus;
    private long msgId;
    private Long timestamp;
    private Integer showType;
    private Integer showSessionType;
    private String srcContent;

    // KEEP FIELDS - put your custom fields here
    public static final int SUCCESS = 1;
//    public static final int SUCCESS = 2;
    public static final int SEND_FAIL = 3;
    public static final int SENDING = 4;
    public static final int NEED_CONVERT = 5;
    private int messageIndex;
    // KEEP FIELDS END

    public Message() {
    }

    public Message(Long id) {
        this.id = id;
    }

    public Message(Long id, long chatId, Integer chatType, Long sendUserId, Integer sendUserType, String content, Integer contentType, int sessionType, Integer sendStatus, long msgId, Long timestamp, Integer showType, Integer showSessionType, String srcContent) {
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
        this.showType = showType;
        this.showSessionType = showSessionType;
        this.srcContent = srcContent;
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

    public Integer getChatType() {
        return chatType;
    }

    public void setChatType(Integer chatType) {
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

    public Integer getShowType() {
        return showType;
    }

    public void setShowType(Integer showType) {
        this.showType = showType;
    }

    public Integer getShowSessionType() {
        return showSessionType;
    }

    public void setShowSessionType(Integer showSessionType) {
        this.showSessionType = showSessionType;
    }

    public String getSrcContent() {
        return srcContent;
    }

    public void setSrcContent(String srcContent) {
        this.srcContent = srcContent;
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

    public int getMessageIndex() {
        return messageIndex;
    }

    public void setMessageIndex(int messageIndex) {
        this.messageIndex = messageIndex;
    }
    // KEEP METHODS END

}
