package com.community.imsdk.dto.response;

import java.util.List;

/**
 * Created by dufeng on 16/11/3.<br/>
 * Description: AddGroupMemberResponse
 */

public class AddGroupMemberResponse extends BaseResponse {

    private int version;
    private List<Long> userIds;

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public List<Long> getUserIds() {
        return userIds;
    }

    public void setUserIds(List<Long> userIds) {
        this.userIds = userIds;
    }
}
