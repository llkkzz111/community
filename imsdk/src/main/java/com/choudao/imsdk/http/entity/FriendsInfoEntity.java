package com.choudao.imsdk.http.entity;

import java.util.List;

/**
 * Created by dufeng on 16/8/3.<br/>
 * Description: FriendsInfosEntity
 */
public class FriendsInfoEntity {


    private List<DataSourceBean> dataSource;

    public List<DataSourceBean> getDataSource() {
        return dataSource;
    }

    public void setDataSource(List<DataSourceBean> dataSource) {
        this.dataSource = dataSource;
    }

    public static class DataSourceBean {
        private long id;
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

        public long getId() {
            return id;
        }

        public void setId(long id) {
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
    }
}
