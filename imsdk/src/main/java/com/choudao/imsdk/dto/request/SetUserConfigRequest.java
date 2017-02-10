package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/6/7.<br/>
 * Description: SetPushConfigRequest
 */
public class SetUserConfigRequest extends BaseRequest {
    private boolean accept;
    private boolean showDetail;
    private boolean friendConfirmation;

    public SetUserConfigRequest() {
    }

    public SetUserConfigRequest(boolean accept, boolean showDetail, boolean friendConfirmation) {
        this.accept = accept;
        this.showDetail = showDetail;
        this.friendConfirmation = friendConfirmation;
    }

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
