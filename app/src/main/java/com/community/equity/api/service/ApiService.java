package com.community.equity.api.service;

import com.community.equity.base.BaseApiResponse;
import com.community.equity.entity.AnswerEntity;
import com.community.equity.entity.CommentEntity;
import com.community.equity.entity.ContactInfo;
import com.community.equity.entity.FollowEntity;
import com.community.equity.entity.MotionEntity;
import com.community.equity.entity.ProfileEntity;
import com.community.equity.entity.QuestionEntity;
import com.community.equity.entity.SearchUserEntity;
import com.community.equity.entity.TagEntity;
import com.community.equity.entity.UpdateEntity;
import com.community.equity.entity.UserEntity;
import com.community.equity.entity.UserInfoEntity;
import com.community.equity.entity.WxAccessToken;
import com.community.equity.entity.WxUserInfo;
import com.community.equity.utils.ConstantUtils;
import com.community.imsdk.db.bean.MobileUserInfo;

import java.util.List;
import java.util.Map;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Field;
import retrofit2.http.FieldMap;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 16/7/6.
 */

public interface ApiService {
    /**
     * 获取最新,最热问题列表
     *
     * @param type
     * @param tag
     * @return
     */
    @GET("{type}")
    Call<BaseApiResponse<List<QuestionEntity>>> listQuestion(@Path(value = "type", encoded = true) String type, @Query(value = "tag") String tag);

    /**
     * 添加问题
     *
     * @param map
     * @return
     */
    @POST("questions.json")
    Call<QuestionEntity> addQuestions(@QueryMap Map<String, Object> map);

    /**
     * 查看问题
     *
     * @param questionId
     * @return
     */
    @GET("questions/{questionId}.json")
    Call<QuestionEntity> getQuestion(@Path(value = "questionId") int questionId);

    /**
     * 对问题的态度
     *
     * @param questionId
     * @return
     */
    @POST("questions/{questionId}/toggle_follow.json")
    Call<QuestionEntity> setQuestionFollow(@Path(value = "questionId") int questionId);


    /**
     * 查看我的回答
     *
     * @param questionId
     * @return
     */
    @GET("questions/{questionId}/my_answer.json")
    Call<AnswerEntity> getMyAnswer(@Path(value = "questionId") int questionId);

    /**
     * 查看单个回答
     *
     * @param questionId
     * @param answerId
     * @return
     */
    @GET("questions/{questionId}/answers/{answerId}.json")
    Call<AnswerEntity> getSingleAnswer(@Path(value = "questionId") int questionId, @Path(value = "answerId") int answerId);

    /**
     * 对某个答案的态度
     *
     * @param answerId
     * @return
     */
    @POST("answers/{answerId}/{vote}.json")
    Call<AnswerEntity> setVoteAnswer(@Path(value = "answerId") int answerId, @Path(value = "vote") String vote);

    /**
     * 修改回答
     *
     * @param questionId
     * @param answerId
     * @param content
     * @return
     */
    @FormUrlEncoded
    @POST("questions/{questionId}/answers/{answerId}.json")
    Call<AnswerEntity> updateAnswer(@Path(value = "questionId") int questionId, @Path(value = "answerId") int answerId, @Field(value = "answer[content]") String content);

    /**
     * 添加回答
     *
     * @param questionId
     * @param content
     * @return
     */
    @FormUrlEncoded
    @POST("questions/{questionId}/answers.json")
    Call<AnswerEntity> addAnswers(@Path(value = "questionId") int questionId, @Field(value = "answer[content]") String content);

    /**
     * 获取回答下面的所有评论
     *
     * @param answerId
     * @return
     */
    @GET("answers/{answerId}/comments.json")
    Call<BaseApiResponse<List<CommentEntity>>> getCommentsList(@Path(value = "answerId") int answerId);

    /**
     * 添加评论
     *
     * @param questionId
     * @param answerid
     * @param map
     * @return
     */
    @FormUrlEncoded
    @POST("questions/{questionId}/answers/{answerid}/comments.json")
    Call<CommentEntity> addComment(@Path(value = "questionId") int questionId, @Path(value = "answerid") int answerid, @FieldMap Map<String, Object> map);

    /**
     * 获取手机通讯录中的联系人列表
     *
     * @param map
     * @return
     */
    @POST("users/contacts.json")
    Call<Map<String, MobileUserInfo>> Contacts(@Body Map<String, Map<String, ContactInfo>> map);

    /**
     * 修改评论
     *
     * @param answerid
     * @param commentId
     * @param map
     * @return
     */
    @FormUrlEncoded
    @POST("answers/{answerid}/comments/{commentId}.json")
    Call<CommentEntity> editComment(@Path(value = "answerid") int answerid, @Path(value = "commentId") int commentId, @FieldMap Map<String, Object> map);

    /**
     * 获取用户信息
     *
     * @return
     */
    @GET("user_profile.json")
    Call<ProfileEntity> getUserProfile(@QueryMap Map<String, Object> map);

    /**
     * 修改用户头像
     * post
     *
     * @return
     */

    @POST("user_profile/avatar.json")
    Call<ProfileEntity> userProfileUpdateHeadImg(@QueryMap Map<String, Object> map);


    /**
     * 关注或者取消关注
     *
     * @return
     */
    @POST("users/{userId}/toggle_follow.json")
    Call<FollowEntity> setToggleFollow(@Path(value = "userId") int userId);

    /**
     * 赞或者取消赞
     *
     * @return
     */
    @POST("comments/{commentid}/toggle_vote.json")
    Call<CommentEntity> setAnsewerVote(@Path(value = "commentid") int commentid);


    /**
     * 获取tag列表
     *
     * @return
     */
    @GET("tags.json")
    Call<BaseApiResponse<List<TagEntity>>> listTag();

    /**
     * 检查更新
     *
     * @return
     */
    @GET(ConstantUtils.BASE_API_URL + "apps/android/check_version.json")
    Call<UpdateEntity> updateVersion(@Query(value = "version") String version);

    /**
     * 获取用户信息
     *
     * @return
     */
    @GET("user_info.json")
    Call<UserInfoEntity> getUserInfo(@QueryMap Map<String, Object> map);


    /**
     * 搜索用户
     *
     * @param
     * @return
     */
    @POST("users/search.json")
    Call<SearchUserEntity> searchUser(@QueryMap Map<String, Object> map);

    /**
     * 校验用户是否登录
     *
     * @return
     */
    @GET(ConstantUtils.BASE_API_URL + "users/info.json")
    Call<UserEntity> getUserInfo();

    /**
     * 获取动态
     *
     * @return
     */
    @GET("activities.json")
    Call<BaseApiResponse<List<MotionEntity>>> getActivities(@QueryMap Map<String, Object> map);

    /**
     * 获取动态
     *
     * @return
     */
    @GET("users_home/activities.json")
    Call<BaseApiResponse<List<MotionEntity>>> getUserActivities(@QueryMap Map<String, Object> map);

    /**
     * 获取微信 token
     *
     * @return
     */
    @GET("https://api.weixin.qq.com/sns/oauth2/access_token")
    Call<WxAccessToken> getWxActionToken(@QueryMap Map<String, Object> map);

    /**
     * 获取微信用户信息
     *
     * @return
     */
    @GET("https://api.weixin.qq.com/sns/userinfo")
    Call<WxUserInfo> getWxUserInfo(@QueryMap Map<String, Object> map);

    /**
     * 获取七牛token
     * get
     *
     * @return
     */
    @GET("qiniu/token.json")
    Call<BaseApiResponse> getQiniuToken();


    /**
     * 获取用户关注列表
     *
     * @return
     */
    @GET("users_home/followers.json")
    Call<BaseApiResponse<List<UserEntity>>> getUserFollowers(@QueryMap Map<String, Object> map);

    /**
     * 获取用户关注列表
     *
     * @return
     */
    @GET("users_home/following.json")
    Call<BaseApiResponse<List<UserEntity>>> getUserFnas(@QueryMap Map<String, Object> map);

    /**
     * 获取用户回答列表
     * get
     *
     * @return
     */
    @GET("users_home/answer_list.json")
    Call<BaseApiResponse<List<AnswerEntity>>> getUserAnswers(@QueryMap Map<String, Object> map);


    /**
     * 获取用户问题列表
     * get
     *
     * @return
     */
    @GET("users_home/question_list.json")
    Call<BaseApiResponse<List<QuestionEntity>>> getUserQuestions(@QueryMap Map<String, Object> map);


    /**
     * 获取举报状态
     *
     * @return
     */
    @GET("reportings/has_reported.json")
    Call<BaseApiResponse> getReportState(@QueryMap Map<String, Object> map);


    /**
     * 更新用户手机
     * post
     *
     * @param
     * @return
     */
    @POST("user_settings/phone.json")
    Call<UserEntity> userSettingPhone(@QueryMap Map<String, Object> map);


    /**
     * 验证手机号是否在身边
     * post
     *
     * @param
     * @return
     */
    @POST("sms/verify.json")
    Call<BaseApiResponse> userSmsVerify(@QueryMap Map<String, Object> map);

    /**
     * 发送短信验证码
     * post
     *
     * @param
     * @return
     */
    @POST("sms/code.json")
    Call<BaseApiResponse> sendSMSCode(@QueryMap Map<String, Object> map);

    /**
     * 举报
     * post
     *
     * @param
     * @return
     */
    @POST("reportings.json")
    Call<BaseApiResponse> userReportings(@QueryMap Map<String, Object> map);


    /**
     * 修改用户信息
     *
     * @param
     * @return
     */
    @POST("user_profile.json")
    Call<ProfileEntity> updateProfile(@QueryMap Map<String, Object> map);

    /**
     * 修改用户信息
     *
     * @param
     * @return
     */
    @GET("welcome/locations.json")
    Call<String> getLocations(@QueryMap Map<String, Object> map);

}
