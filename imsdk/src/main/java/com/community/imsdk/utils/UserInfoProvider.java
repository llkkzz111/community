package com.community.imsdk.utils;

import com.alibaba.fastjson.JSON;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.constants.UserType;
import com.community.imsdk.http.ApiService;
import com.community.imsdk.http.ServiceGenerator;
import com.community.imsdk.http.entity.FriendsInfoEntity;

import java.io.IOException;
import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import retrofit2.Call;
import retrofit2.Response;

/**
 * Created by dufeng on 16/11/10.<br/>
 * Description: UserInfoProvider
 */

public class UserInfoProvider {

    private static final String TAG = "===UserInfoProvider===";

    public static void checkAndLoadUserInfos(List<Long> userIds) {
        String noUserIdStr = "";
        for (long userId : userIds) {
            UserInfo localUserInfo = DBHelper.getInstance().queryUniqueUserInfo(userId);
            if (localUserInfo == null) {
                noUserIdStr += userId + ",";
            }
        }
        if (noUserIdStr.length() > 0) {//如果需要本地没有的用户信息就去拉取一遍
            noUserIdStr = noUserIdStr.substring(0, noUserIdStr.length() - 1);
            loadNormalUserInfos(noUserIdStr);
        }
    }

    public static List<UserInfo> loadNormalUserInfos(String noUserIds) {
        ApiService service = ServiceGenerator.createService(ApiService.class);
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("user_id_list", noUserIds);
        Logger.e(TAG, "user_id_list : " + noUserIds);
        Call<FriendsInfoEntity> call = service.getFriendsInfo(params);
        List<UserInfo> userInfoList = new ArrayList<>();
        try {
            Response<FriendsInfoEntity> response = call.execute();
            if (response.isSuccessful()) {

                for (FriendsInfoEntity.DataSourceBean dataSourceBean : response.body().getDataSource()) {
                    UserInfo userIfo = new UserInfo();
                    userIfo.setUserId(dataSourceBean.getId());
                    userIfo.setUserType(UserType.NORMAL.code);
                    userIfo.setHeadImgUrl(dataSourceBean.getImg());
                    userIfo.setName(dataSourceBean.getName());
                    userIfo.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(dataSourceBean.getName()));
                    userIfo.setTitle(dataSourceBean.getTitle());
                    userIfo.setPhone(dataSourceBean.getPhone());
                    userIfo.setFollowersCount(dataSourceBean.getFollowers_count());
                    userIfo.setFollowingCount(dataSourceBean.getFollowing_count());
                    userIfo.setAnswerCount(dataSourceBean.getAnswers_counter());
                    userIfo.setQuestionCount(dataSourceBean.getQuestions_count());
                    userIfo.setAddress(dataSourceBean.getAddress());
                    userIfo.setDesc(dataSourceBean.getDesc());
                    userIfo.setShareUrl(dataSourceBean.getShare_url());
                    userInfoList.add(userIfo);
                }
                Logger.i(TAG, "userInfoList --> " + JSON.toJSONString(userInfoList));
                //保存联系人信息
                DBHelper.getInstance().saveUserInfoList(userInfoList);
            }
        } catch (IOException e) {
            Logger.e(TAG, " ->loadNormalUserInfos -- ", e);
        }
        return userInfoList;
    }
}
