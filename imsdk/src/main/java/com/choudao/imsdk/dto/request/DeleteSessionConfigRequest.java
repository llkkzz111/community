package com.choudao.imsdk.dto.request;

/**
 * Created by liuzhao on 16/8/4.
 */

public class DeleteSessionConfigRequest extends BaseRequest {

    private long targetId;
    private int sessionType;

    public long getTargetId() {
        return targetId;
    }

    public DeleteSessionConfigRequest(long targetId, int sessionType) {
        this.targetId = targetId;
        this.sessionType = sessionType;
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
}
