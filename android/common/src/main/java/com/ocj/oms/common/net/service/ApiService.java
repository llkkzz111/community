package com.ocj.oms.common.net.service;

import java.util.Map;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 16/7/6.
 */

public interface ApiService {

    String SMS_PURPOSE_TOKEN_LOGIN = "token_login_context"; // 无密码快速登录
    String SMS_PURPOSE_MOBILE_LOGIN = "mobile_login_context"; // 手机登录
    String SMS_PURPOSE_TVUSER_LOGIN = "tvuser_login_context"; // 电视用户绑定手机
    String SMS_PURPOSE_SET_PASSWORD = "set_password_context"; // 设置密码
    String SMS_PURPOSE_QUICK_REGISTER = "quick_register_context"; // 快速注册
    String SMS_PURPOSE_RETRIEVE_PASSWORD = "retrieve_password_context"; // 找回密码
    String EMAILUSER_SMS_CONTEXT = "emailuser_sms_context";

    /**
     * @param
     * @return
     */
    @GET("welcome/locations.json")
    Call<String> getLocations(@QueryMap Map<String, Object> map);


}
