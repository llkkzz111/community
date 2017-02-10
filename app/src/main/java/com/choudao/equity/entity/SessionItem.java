package com.choudao.equity.entity;

import com.choudao.imsdk.db.bean.SessionInfo;

/**
 * Created by dufeng on 16/7/21.<br/>
 * Description: SessionItem
 */
public class SessionItem implements Comparable<SessionItem> {
    public static final int HEAD_NO_NETWORK = 0;
    public static final int ITEM_CONTENT = 1;


    private SessionInfo sessionInfo;

    private String name;
    private String headImgUrl;
    private boolean isTop;
    private long topTime;
    private boolean isMute;
    private int itemType;

    public SessionItem(int itemType) {
        this.itemType = itemType;
    }

    public SessionItem() {
    }

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

    public boolean isTop() {
        return isTop;
    }

    public void setTop(boolean top) {
        isTop = top;
    }

    public long getTopTime() {
        return topTime;
    }

    public void setTopTime(long topTime) {
        this.topTime = topTime;
    }

    public boolean isMute() {
        return isMute;
    }

    public void setMute(boolean mute) {
        isMute = mute;
    }

    public int getItemType() {
        return itemType;
    }

    public void setItemType(int itemType) {
        this.itemType = itemType;
    }

    @Override
    public int compareTo(SessionItem another) {
//        Logger.e("===compareTo===", name + ": " + topTime + " --- " + another.getTopTime());
        if (isTop() && another.isTop()) {
            if (topTime == another.topTime) {
                return getSessionInfo().getLastTime() <= another.getSessionInfo().getLastTime() ? 1 : -1;
            } else {
                return topTime < another.topTime ? 1 : -1;
            }
        } else if (isTop() || another.isTop()) {
            return isTop() ? -1 : 1;
        } else {
            return getSessionInfo().getLastTime() <= another.getSessionInfo().getLastTime() ? 1 : -1;
        }
    }

}
