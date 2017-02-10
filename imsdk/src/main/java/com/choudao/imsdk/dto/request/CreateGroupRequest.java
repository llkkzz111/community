package com.choudao.imsdk.dto.request;

import java.util.List;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: CreateGroupRequest
 */

public class CreateGroupRequest extends BaseRequest {

    private List<Long> userIds;

    public CreateGroupRequest() {
    }

    public CreateGroupRequest(List<Long> userIds) {
        this.userIds = userIds;
    }

    public List<Long> getUserIds() {
        return userIds;
    }

    public void setUserIds(List<Long> userIds) {
        this.userIds = userIds;
    }
}
