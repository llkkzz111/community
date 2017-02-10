package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/7/19.<br/>
 * Description: SetSessionConfigRequest
 */
public class SetSessionConfigRequest extends BaseRequest {
    private long targetId;

    private int sessionType;

    private boolean mute;

    private boolean top;

    public SetSessionConfigRequest() {
    }

    public SetSessionConfigRequest(long targetId, int sessionType, boolean mute, boolean top) {
        this.targetId = targetId;
        this.sessionType = sessionType;
        this.mute = mute;
        this.top = top;
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

    public boolean isMute() {
        return mute;
    }

    public void setMute(boolean mute) {
        this.mute = mute;
    }

    public boolean isTop() {
        return top;
    }

    public void setTop(boolean top) {
        this.top = top;
    }
}
