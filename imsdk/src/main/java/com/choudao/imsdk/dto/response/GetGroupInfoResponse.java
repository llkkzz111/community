package com.choudao.imsdk.dto.response;

/**
 * Created by dufeng on 16/10/31.<br/>
 * Description: GetGroupInfoResponse
 */

public class GetGroupInfoResponse extends BaseResponse {

    private GroupInfoDTO info;


    public GroupInfoDTO getInfo() {
        return info;
    }

    public void setInfo(GroupInfoDTO info) {
        this.info = info;
    }

}
