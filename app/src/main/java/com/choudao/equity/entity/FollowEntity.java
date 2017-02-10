package com.choudao.equity.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.io.Serializable;

/**
 * Created by liuzhao on 16/4/28.
 */
public class FollowEntity extends ShareEntity implements Serializable {
    private int current_user_id;

    @JSONField(name = "is_followed")
    private boolean is_followed;

    private int followers_count;

    public int getFollowers_count() {
        return followers_count;
    }

    public void setFollowers_count(int followers_count) {
        this.followers_count = followers_count;
    }

    public int getCurrent_user_id() {
        return current_user_id;
    }

    public void setCurrent_user_id(int current_user_id) {
        this.current_user_id = current_user_id;
    }

    public boolean getFollowed() {
        return is_followed;
    }

    public void setIs_followed(boolean is_followed) {
        this.is_followed = is_followed;
    }
}
