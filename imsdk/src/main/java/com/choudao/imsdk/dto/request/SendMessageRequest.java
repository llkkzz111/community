package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16-4-14.<br/>
 * Description: SPMsgDTO
 */
public class SendMessageRequest extends BaseRequest {
    public SendMessageRequest() {
    }

    public SendMessageRequest(long targetId, String content, int contentType, int sessionType, String extra) {
        this.targetId = targetId;
        this.content = content;
        this.contentType = contentType;
        this.sessionType = sessionType;
        this.extra = extra;
    }

    private long targetId;
    private String content;
    private int contentType;
    private int sessionType;
    private String extra;

    public long getTargetId() {
        return targetId;
    }

    public void setTargetId(long toUserId) {
        this.targetId = toUserId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    public int getContentType() {
        return contentType;
    }

    public void setContentType(int contentType) {
        this.contentType = contentType;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }

    //    public UserType getToUserTypeEnum() {
//        return UserType.of(toUserType);
//    }
//
//    public void setToUserTypeEnum(UserType toUserType) {
//        this.toUserType = toUserType.code;
//    }
}
