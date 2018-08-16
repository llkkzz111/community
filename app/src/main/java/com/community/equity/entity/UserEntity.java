package com.community.equity.entity;

import java.io.Serializable;
import java.util.List;

/**
 * Created by liuzhao on 16/4/8.
 */
public class UserEntity extends FollowEntity implements Serializable {
    private int id;
    private String img;
    private String name;
    private String title;
    private String phone;
    private int questions_count;
    private int my_activities_count;
    private int request_call_sent_counter;
    private int answers_counter;
    private int investment_counter;
    private int launched_pitches_counter;
    private int sent_lead_investors_counter;
    private int received_votes_count;

    private int followed_pitches_count;
    private int beehives_count;
    private List<LevelsBean> levels;
    private List<LevelsBean> other_levels;

    public int getFollowedPitchesCount() {
        return followed_pitches_count;
    }

    public void setFollowedPitchesPount(int followed_pitches_count) {
        this.followed_pitches_count = followed_pitches_count;
    }

    public int getBeehivesCount() {
        return beehives_count;
    }

    public void setBeehivesCount(int beehives_count) {
        this.beehives_count = beehives_count;
    }

    public List<LevelsBean> getLevels() {
        return levels;
    }

    public void setLevels(List<LevelsBean> levels) {
        this.levels = levels;
    }

    public List<LevelsBean> getOtherLevels() {
        return other_levels;
    }

    public void setOtherLevels(List<LevelsBean> other_levels) {
        this.other_levels = other_levels;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }


    public int getQuestions_count() {
        return questions_count;
    }

    public void setQuestions_count(int questions_count) {
        this.questions_count = questions_count;
    }

    public int getMy_activities_count() {
        return my_activities_count;
    }

    public void setMy_activities_count(int my_activities_count) {
        this.my_activities_count = my_activities_count;
    }

    public int getReceived_votes_count() {
        return received_votes_count;
    }

    public void setReceived_votes_count(int received_votes_count) {
        this.received_votes_count = received_votes_count;
    }

    public int getReceived_votes_counter() {
        return received_votes_count;
    }

    public void setReceived_votes_counter(int received_votes_counter) {
        this.received_votes_count = received_votes_counter;
    }

    public int getRequest_call_sent_counter() {
        return request_call_sent_counter;
    }

    public void setRequest_call_sent_counter(int request_call_sent_counter) {
        this.request_call_sent_counter = request_call_sent_counter;
    }

    public int getAnswers_counter() {
        return answers_counter;
    }

    public void setAnswers_counter(int answers_counter) {
        this.answers_counter = answers_counter;
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

    public static class LevelsBean {
        /**
         * name : investor
         * human_name : 身份验证
         * url : http://staging2.community.com/investors/new?return_url=%2Fnews%2Fusers%2F80%2Fprofile
         */

        private String name;
        private String human_name;
        private String url;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getHuman_name() {
            return human_name;
        }

        public void setHuman_name(String human_name) {
            this.human_name = human_name;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }
}
