package com.choudao.imsdk.db.bean;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
// KEEP INCLUDES END
/**
 * Entity mapped to table "SESSION_INFO".
 */
public class SessionInfo implements java.io.Serializable {

    private Long id;
    private long targetId;
    private Integer targetType;
    private int sessionType;
    private Integer count;
    private String lastMessage;
    private Long lastMessageId;
    private Long lastTime;

    // KEEP FIELDS - put your custom fields here
    /** 私聊 */
    public static final int PRIVATE_SESSION = 1;
    /** 群聊 */
    public static final int GROUP_SESSION = 2;
    // KEEP FIELDS END

    public SessionInfo() {
    }

    public SessionInfo(Long id) {
        this.id = id;
    }

    public SessionInfo(Long id, long targetId, Integer targetType, int sessionType, Integer count, String lastMessage, Long lastMessageId, Long lastTime) {
        this.id = id;
        this.targetId = targetId;
        this.targetType = targetType;
        this.sessionType = sessionType;
        this.count = count;
        this.lastMessage = lastMessage;
        this.lastMessageId = lastMessageId;
        this.lastTime = lastTime;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public long getTargetId() {
        return targetId;
    }

    public void setTargetId(long targetId) {
        this.targetId = targetId;
    }

    public Integer getTargetType() {
        return targetType;
    }

    public void setTargetType(Integer targetType) {
        this.targetType = targetType;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public Long getLastMessageId() {
        return lastMessageId;
    }

    public void setLastMessageId(Long lastMessageId) {
        this.lastMessageId = lastMessageId;
    }

    public Long getLastTime() {
        return lastTime;
    }

    public void setLastTime(Long lastTime) {
        this.lastTime = lastTime;
    }

    // KEEP METHODS - put your custom methods here
    // KEEP METHODS END

}
