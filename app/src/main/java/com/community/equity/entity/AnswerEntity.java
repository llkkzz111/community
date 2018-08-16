package com.community.equity.entity;

import java.io.Serializable;

/**
 * Created by liuzhao on 16/4/15.
 */
public class AnswerEntity extends ShareEntity implements Serializable {

    private int id;
    private String content;
    private String votes_weight;
    private String questionTitle;
    private String chosen;
    private UserEntity user;
    private int commentsCount;
    private String safe_content;
    private int answers_count;
    private int question_id;
    private String question;
    private long timestamp;

    public long getTimestamp() {
        return timestamp * 1000;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public int getQuestion_id() {
        return question_id;
    }

    public void setQuestion_id(int question_id) {
        this.question_id = question_id;
    }

    public int getAnswersCount() {
        return answers_count;
    }

    public void setAnswers_count(int answersCount) {
        this.answers_count = answersCount;
    }

    public String getSafe_content() {
        return safe_content;
    }

    public void setSafe_content(String safe_content) {
        this.safe_content = safe_content;
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

    public String getVotes_weight() {
        return votes_weight;
    }

    public void setVotes_weight(String votes_weight) {
        this.votes_weight = votes_weight;
    }

    public String getQuestionTitle() {
        return questionTitle;
    }

    public void setQuestionTitle(String questionTitle) {
        this.questionTitle = questionTitle;
    }

    public String getChosen() {
        return chosen;
    }

    public void setChosen(String chosen) {
        this.chosen = chosen;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public int getCommentsCount() {
        return commentsCount;
    }

    public void setCommentsCount(int commentsCount) {
        this.commentsCount = commentsCount;
    }
}
