package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/11/2.<br/>
 * Description: GetGroupInfoAndMemberRequest
 */

public class GetGroupInfoAndMemberRequest extends BaseRequest {

    private long groupId;
    private int count;

    public GetGroupInfoAndMemberRequest() {
    }

    public GetGroupInfoAndMemberRequest(long groupId, int count) {
        this.groupId = groupId;
        this.count = count;
    }

    public GetGroupInfoAndMemberRequest(long groupId) {
        this.groupId = groupId;
        this.count = 500;
    }

    public long getGroupId() {
        return groupId;
    }

    public void setGroupId(long groupId) {
        this.groupId = groupId;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }


}
