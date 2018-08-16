package com.community.imsdk.dto.response;

import java.util.List;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: CreateGroupResponse
 */

public class CreateGroupResponse extends BaseResponse {

    private long groupId;
    private List<Long> userIds;

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
