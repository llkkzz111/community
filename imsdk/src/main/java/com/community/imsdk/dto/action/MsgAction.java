package com.community.imsdk.dto.action;

/**
 * Created by dufeng on 16/6/20.<br/>
 * Description: MsgAction
 */
public class MsgAction {
    public MsgAction() {
    }

    private long targetId;
    private int targetType;
    private int sessionType;

    public long getTargetId() {
        return targetId;
    }

    public void setTargetId(long targetId) {
        this.targetId = targetId;
    }

    public int getTargetType() {
        return targetType;
    }

    public void setTargetType(int targetType) {
        this.targetType = targetType;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }
}
