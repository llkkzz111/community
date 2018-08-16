package com.community.equity.entity;

import java.util.List;

/**
 * Created by liuzhao on 16/4/8.
 */
public class QuestionEntity extends FollowEntity {
    private int id;
    private String title;
    private String content;
    private int answers_count;
    private int view_count;
    private String createdAt;
    private String path;
    private List<TagEntity> tags;
    private UserEntity user;
    private UserEntity currentUser;
    private List<AnswerEntity> answers;
    private AnswerEntity myAnswer;
    private long timestamp;

    public long getTimestamp() {
        return timestamp * 1000;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }


    public int getView_count() {
        return view_count;
    }

    public void setView_count(int view_count) {
        this.view_count = view_count;
    }

    public AnswerEntity getMyAnswer() {
        return myAnswer;
    }

    public void setMyAnswer(AnswerEntity myAnswer) {
        this.myAnswer = myAnswer;
    }

    public List<AnswerEntity> getAnswers() {
        return answers;
    }

    public void setAnswers(List<AnswerEntity> answers) {
        this.answers = answers;
    }

    public UserEntity getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(UserEntity currentUser) {
        this.currentUser = currentUser;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getAnswersCount() {
        return answers_count;
    }

    public void setAnswers_count(int answersCount) {
        this.answers_count = answersCount;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public List<TagEntity> getTags() {
        return tags;
    }

    public void setTags(List<TagEntity> tags) {
        this.tags = tags;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }
}
