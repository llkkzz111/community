package com.community.imsdk.dto.request;

import java.util.List;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: AddGroupMemberRequest
 */

public class AddGroupMemberRequest extends BaseRequest {

    private long groupId;

    private List<Long> userIds;

    public AddGroupMemberRequest() {
    }

    public AddGroupMemberRequest(long groupId, List<Long> userIds) {
        this.groupId = groupId;
        this.userIds = userIds;
    }

    public long getGroupId() {
        return groupId;
    }

    public void setGroupId(long groupId) {
        this.groupId = groupId;
    }

    public List<Long> getUserIds() {
        return userIds;
    }

    public void setUserIds(List<Long> userIds) {
        this.userIds = userIds;
    }
}
