package com.community.imsdk.dto.response;

import java.util.List;

/**
 * Created by dufeng on 16/8/3.<br/>
 * Description: PullFriendsListResponse
 */
public class PullFriendListResponse extends BaseResponse {


    private int version;

    private List<FriendsBean> friends;

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public List<FriendsBean> getFriends() {
        return friends;
    }

    public void setFriends(List<FriendsBean> friends) {
        this.friends = friends;
    }


    public static class FriendsBean {
        private long createTime;
        private long friendUserId;
        private int friendUserType;
        private int id;
        private String remark;

        public FriendsBean(long friendUserId, int friendUserType) {
            this.friendUserId = friendUserId;
            this.friendUserType = friendUserType;
        }

        public FriendsBean() {
        }

        public long getCreateTime() {
            return createTime;
        }

        public void setCreateTime(long createTime) {
            this.createTime = createTime;
        }

        public long getFriendUserId() {
            return friendUserId;
        }

        public void setFriendUserId(long friendUserId) {
            this.friendUserId = friendUserId;
        }

        public int getFriendUserType() {
            return friendUserType;
        }

        public void setFriendUserType(int friendUserType) {
            this.friendUserType = friendUserType;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }

    public long showMinId() {
        if (friends.size() == 0) {
            return 0;
        }
        long id = friends.get(friends.size() - 1).id;
        for (FriendsBean configRequest : friends) {
            if (configRequest.id < id) {
                id = configRequest.id;
            }
        }
        return id;
    }

    public String showAllUserId() {

        String result = "";
        for (FriendsBean configRequest : friends) {
            result += configRequest.friendUserId + ",";
        }
        if (result.length() > 0) {
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }
}
