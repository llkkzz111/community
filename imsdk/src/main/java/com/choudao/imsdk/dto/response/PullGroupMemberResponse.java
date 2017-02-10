package com.choudao.imsdk.dto.response;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: PullGroupMemberResponse
 */

public class PullGroupMemberResponse extends BaseResponse {
    private int version;

    private List<GroupMemberDTO> members;

    public List<GroupMemberDTO> getMembers() {
        return members;
    }

    public void setMembers(List<GroupMemberDTO> members) {
        this.members = members;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public List<Long> showMemberIds() {
        List<Long> list = new ArrayList<>();
        for (GroupMemberDTO membersBean : members) {
            list.add(membersBean.getUserId());
        }
        return list;
    }
}
