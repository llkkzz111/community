package com.community.equity.entity;

import com.alibaba.fastjson.annotation.JSONField;

import java.io.Serializable;

/**
 * Created by liuz on 2016/4/24.
 */
public class CommentEntity extends ShareEntity implements Serializable {
    private String title;
    private String content;
    private int id;
    private String createdAt;
    private int votesWeight;
    @JSONField(name = "isVoted")
    private boolean isVoted;
    private long timestamp;
    private UserEntity user;

    public long getTimestamp() {
        return timestamp * 1000;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public boolean getVoted() {
        return isVoted;
    }

    public void setVoted(boolean voted) {
        isVoted = voted;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getVotesWeight() {
        return votesWeight;
    }

    public void setVotesWeight(int votesWeight) {
        this.votesWeight = votesWeight;
    }


}
