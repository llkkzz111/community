package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: PullGroupMemberRequest
 */

public class PullGroupMemberRequest extends BaseRequest {

    private long groupId;

    private long index;

    private int count;

    public PullGroupMemberRequest() {
    }

    public PullGroupMemberRequest(long groupId, long index, int count) {
        this.groupId = groupId;
        this.index = index;
        this.count = count;
    }

    public long getGroupId() {
        return groupId;
    }

    public void setGroupId(long groupId) {
        this.groupId = groupId;
    }

    public long getIndex() {
        return index;
    }

    public void setIndex(long index) {
        this.index = index;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
