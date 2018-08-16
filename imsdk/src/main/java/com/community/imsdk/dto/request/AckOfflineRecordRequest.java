package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/5/19.<br/>
 * Description: ROMsgRequest
 */
public class AckOfflineRecordRequest extends BaseRequest {
    private long id;
    private long count;
    private long lastMsgId;

    public AckOfflineRecordRequest(long id, long count, long lastMsgId) {
        this.id = id;
        this.count = count;
        this.lastMsgId = lastMsgId;
    }

    public AckOfflineRecordRequest() {
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        this.count = count;
    }

    public long getLastMsgId() {
        return lastMsgId;
    }

    public void setLastMsgId(long lastMsgId) {
        this.lastMsgId = lastMsgId;
    }
}
