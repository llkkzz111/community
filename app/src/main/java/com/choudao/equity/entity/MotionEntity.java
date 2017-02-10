package com.choudao.equity.entity;

import com.choudao.equity.base.BaseApiResponse;

/**
 * Created by liuzhao on 16/4/28.
 */
public class MotionEntity extends BaseApiResponse {
    private int id;
    private String content;
    private String entry_path;
    private String content_prefix;
    private String type;
    private String created_at;
    private UserEntity user;
    private MotionJumpEntity entry;
    private long timestamp;

    public long getTimestamp() {
        return timestamp * 1000;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getEntry_path() {
        return entry_path;
    }

    public void setEntry_path(String entry_path) {
        this.entry_path = entry_path;
    }

    public String getContent_prefix() {
        return content_prefix;
    }

    public void setContent_prefix(String content_prefix) {
        this.content_prefix = content_prefix;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public MotionJumpEntity getEntry() {
        return entry;
    }

    public void setEntry(MotionJumpEntity entry) {
        this.entry = entry;
    }
}
