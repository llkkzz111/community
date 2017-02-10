package com.choudao.equity.entity;

import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.db.bean.SessionInfo;
import com.choudao.imsdk.dto.push.FriendRequestContent;

/**
 * Created by dufeng on 16/8/25.<br/>
 * Description: NewFriendItem
 */
public class NewFriendItem {

    public static final int VIEW_HEADER = 0;
    public static final int VIEW_CONTENT = 1;

    public static final int ACCEPT = 1;
    public static final int ADD = 2;
    public static final int ADDED = 3;
    public static final int REQUEST_SEND = 4;

    private int itemType;

    public NewFriendItem(int itemType) {
        this.itemType = itemType;
    }

    private SessionInfo sessionInfo;

    private String name;
    private String headImgUrl;
    private int action;
    private FriendRequestContent content;

    public SessionInfo getSessionInfo() {
        return sessionInfo;
    }

    public void setSessionInfo(SessionInfo sessionInfo) {
        this.sessionInfo = sessionInfo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHeadImgUrl() {
        return headImgUrl;
    }

    public void setHeadImgUrl(String headImgUrl) {
        this.headImgUrl = headImgUrl;
    }

    public int getAction() {
        return action;
    }

    public void setAction(int action) {
        this.action = action;
    }

    public FriendRequestContent getContent() {
        return content;
    }

    public void setContent(FriendRequestContent content) {
        this.content = content;
    }

    public void setContent(String data) {
        this.content = JSON.parseObject(data, FriendRequestContent.class);
    }

    public int getItemType() {
        return itemType;
    }
}
