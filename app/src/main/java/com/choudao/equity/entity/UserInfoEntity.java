package com.choudao.equity.entity;

import java.io.Serializable;

/**
 * Created by dufeng on 16/9/6.<br/>
 * Description: UserInfoEntity
 */
public class UserInfoEntity implements Serializable {

    private int id;
    private String img;
    private String name;
    private String title;
    private String phone;
    private int followers_count;
    private int following_count;
    private int questions_count;
    private int answers_counter;
    private String desc;
    private String address;
    private String share_url;
    private int current_user_id;
    private boolean is_followed;
    private int request_call_sent_counter;
    private int investment_counter;
    private int launched_pitches_counter;
    private int sent_lead_investors_counter;
    private int received_votes_count;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getFollowers_count() {
        return followers_count;
    }

    public void setFollowers_count(int followers_count) {
        this.followers_count = followers_count;
    }

    public int getFollowing_count() {
        return following_count;
    }

    public void setFollowing_count(int following_count) {
        this.following_count = following_count;
    }

    public int getQuestions_count() {
        return questions_count;
    }

    public void setQuestions_count(int questions_count) {
        this.questions_count = questions_count;
    }

    public int getAnswers_counter() {
        return answers_counter;
    }

    public void setAnswers_counter(int answers_counter) {
        this.answers_counter = answers_counter;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getShare_url() {
        return share_url;
    }

    public void setShare_url(String share_url) {
        this.share_url = share_url;
    }

    public int getCurrent_user_id() {
        return current_user_id;
    }

    public void setCurrent_user_id(int current_user_id) {
        this.current_user_id = current_user_id;
    }

    public boolean isIs_followed() {
        return is_followed;
    }

    public void setIs_followed(boolean is_followed) {
        this.is_followed = is_followed;
    }

    public int getRequest_call_sent_counter() {
        return request_call_sent_counter;
    }

    public void setRequest_call_sent_counter(int request_call_sent_counter) {
        this.request_call_sent_counter = request_call_sent_counter;
    }

    public int getInvestment_counter() {
        return investment_counter;
    }

    public void setInvestment_counter(int investment_counter) {
        this.investment_counter = investment_counter;
    }

    public int getLaunched_pitches_counter() {
        return launched_pitches_counter;
    }

    public void setLaunched_pitches_counter(int launched_pitches_counter) {
        this.launched_pitches_counter = launched_pitches_counter;
    }

    public int getSent_lead_investors_counter() {
        return sent_lead_investors_counter;
    }

    public void setSent_lead_investors_counter(int sent_lead_investors_counter) {
        this.sent_lead_investors_counter = sent_lead_investors_counter;
    }

    public int getReceived_votes_count() {
        return received_votes_count;
    }

    public void setReceived_votes_count(int received_votes_count) {
        this.received_votes_count = received_votes_count;
    }
}
