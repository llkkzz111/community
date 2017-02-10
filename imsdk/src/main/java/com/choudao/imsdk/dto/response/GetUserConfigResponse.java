package com.choudao.imsdk.dto.response;

/**
 * Created by dufeng on 16/6/7.<br/>
 * Description: GetPushConfigResponse
 */
public class GetUserConfigResponse extends BaseResponse {

    private boolean accept;
    private boolean showDetail;
    private boolean friendConfirmation;

    public boolean isAccept() {
        return accept;
    }

    public void setAccept(boolean accept) {
        this.accept = accept;
    }

    public boolean isShowDetail() {
        return showDetail;
    }

    public void setShowDetail(boolean showDetail) {
        this.showDetail = showDetail;
    }

    public boolean isFriendConfirmation() {
        return friendConfirmation;
    }

    public void setFriendConfirmation(boolean friendConfirmation) {
        this.friendConfirmation = friendConfirmation;
    }
}
