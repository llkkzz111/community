package com.community.imsdk.dto.response;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: GroupInfoDTO
 */

public class GroupInfoDTO {
    private String name;
    private String notice;
    private int type;
    private long holder;
    private int infoVersion;
    private int memberCount;
    private int memberVersion;

    public long getHolder() {
        return holder;
    }

    public void setHolder(long holder) {
        this.holder = holder;
    }

    public int getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(int memberCount) {
        this.memberCount = memberCount;
    }

    public int getMemberVersion() {
        return memberVersion;
    }

    public void setMemberVersion(int memberVersion) {
        this.memberVersion = memberVersion;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNotice() {
        return notice;
    }

    public void setNotice(String notice) {
        this.notice = notice;
    }

    public int getInfoVersion() {
        return infoVersion;
    }

    public void setInfoVersion(int infoVersion) {
        this.infoVersion = infoVersion;
    }
}
