package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/10/31.<br/>
 * Description: GetGroupInfoRequest
 */

public class GetGroupInfoRequest extends BaseRequest {
    private long id;
    private boolean isShowNotice = false;


    public GetGroupInfoRequest() {
    }

    public GetGroupInfoRequest(long id) {
        this.id = id;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public boolean isShowNotice() {
        return isShowNotice;
    }

    public void setShowNotice(boolean isShowNotice) {
        this.isShowNotice = isShowNotice;
    }
}
