package com.community.equity.entity;

import java.util.List;

/**
 * Created by dufeng on 16/5/20.<br/>
 * Description: FriendsEntity
 */
public class FriendsEntity {


    private int current_page;
    private int total;
    private String hex;
    private String message;

    private UserBean current_user;
    private List<UserBean> dataSource;
    private List<UserBean> system_users;

    public int getCurrent_page() {
        return current_page;
    }

    public void setCurrent_page(int current_page) {
        this.current_page = current_page;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public UserBean getCurrent_user() {
        return current_user;
    }

    public void setCurrent_user(UserBean current_user) {
        this.current_user = current_user;
    }

    public List<UserBean> getDataSource() {
        return dataSource;
    }

    public void setDataSource(List<UserBean> dataSource) {
        this.dataSource = dataSource;
    }

    public List<UserBean> getSystem_users() {
        return system_users;
    }

    public void setSystem_users(List<UserBean> system_users) {
        this.system_users = system_users;
    }

    public String getHex() {
        return hex;
    }

    public void setHex(String hex) {
        this.hex = hex;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public static class UserBean {
        private int id;
        private String img;
        private String name;
        private String title;
        private String phone;
        private int followers_count;
        private int following_count;

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
    }

}
