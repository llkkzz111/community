package com.choudao.imsdk.dto.request;

/**
 * Created by dufeng on 16/8/25.<br/>
 * Description: AddFriendRequest
 */
public class UpdateGroupInfoRequest extends BaseRequest {
    private long id;

    private String name;

    public UpdateGroupInfoRequest() {
    }

    public UpdateGroupInfoRequest(long id, String name, String notice) {
        this.id = id;
        this.name = name;
        this.notice = notice;
    }

    public String getNotice() {
        return notice;
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    private String notice;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

}
