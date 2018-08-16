package com.community.imsdk.dto.response;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dufeng on 16/11/2.<br/>
 * Description: GetGroupInfoAndMemberResponse
 */

public class GetGroupInfoAndMemberResponse extends BaseResponse {

    private GroupInfoDTO info;

    private List<GroupMemberDTO> members;

    public GroupInfoDTO getInfo() {
        return info;
    }

    public void setInfo(GroupInfoDTO info) {
        this.info = info;
    }

    public List<GroupMemberDTO> getMembers() {
        return members;
    }

    public void setMembers(List<GroupMemberDTO> members) {
        this.members = members;
    }

    public List<Long> getMemberIds() {
        List<Long> list = new ArrayList<>();
        for (GroupMemberDTO membersBean : members) {
            list.add(membersBean.getUserId());
        }
        return list;
    }
}
