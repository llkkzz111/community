package com.community.imsdk.http;

import com.community.imsdk.http.entity.FriendsInfoEntity;

import java.util.Map;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 16/11/10.
 */

public interface ApiService {
    /**
     * 获取用户好友列表
     *
     * @param
     * @return
     */
    @GET("users/list.json")
    Call<FriendsInfoEntity> getFriendsInfo(@QueryMap(encoded = true) Map<String, Object> map);
}
