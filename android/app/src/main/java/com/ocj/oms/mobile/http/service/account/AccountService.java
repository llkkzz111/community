package com.ocj.oms.mobile.http.service.account;

import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.mobile.bean.AlipayAuth;
import com.ocj.oms.mobile.bean.CheckToken;
import com.ocj.oms.mobile.bean.CheckUpdateBean;
import com.ocj.oms.mobile.bean.LotteryListBean;
import com.ocj.oms.mobile.bean.MemberBean;
import com.ocj.oms.mobile.bean.ReserveOrderBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.ResultStr;
import com.ocj.oms.mobile.bean.SignBean;
import com.ocj.oms.mobile.bean.SignDetailBean;
import com.ocj.oms.mobile.bean.SignPacksBean;
import com.ocj.oms.mobile.bean.SignPacksListBean;
import com.ocj.oms.mobile.bean.SubmitReserveOrderBean;
import com.ocj.oms.mobile.bean.ThirdBean;
import com.ocj.oms.mobile.bean.TvSafeVerifyBean;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;

import java.util.Map;

import io.reactivex.Observable;
import okhttp3.MultipartBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 2017/4/13.
 */

public interface AccountService {

    /**
     * 访客登录
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/loginrules/login_by_visit")
    Observable<ApiResult<UserInfo>> visitLogin(@Body Map<String, String> params);

    /**
     * 检查token类型
     *
     * @param token
     */
    @GET("api/members/checking/token")
    Observable<ApiResult<CheckToken>> checkToken(@Query(value = "token") String token);

    /**
     * 免密码登录
     *
     * @param accessToken
     */
    @GET("/api/members/loginrules/login_by_access_code")
    Observable<ApiResult<UserInfo>> accessToken(@Query(value = "access_token") String accessToken);

    /**
     * API.02.01.001登录ID判断接口
     *
     * @param loginID
     */
    @GET("/api/members/members/check_loginid")
    Observable<ApiResult<UserType>> checkLogin(@Query(value = "login_id") String loginID);

    /**
     * 2.30	API.02.10.001 发送手机验证码接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/smscode/send_verify_code_mobile")
    Observable<ApiResult<VerifyBean>> getVerifyCode(@Body Map<String, String> params);

    /**
     * API.02.01.003 手机验证码快速注册（验证码，密码一步注册）接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/verify_code_register")
    Observable<ApiResult<UserInfo>> rapidRagisterNew(@Body Map<String, String> map);

    /**
     * API.02.10.003 手机验证码快速登录接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/smscode/sms_login")
    Observable<ApiResult<UserInfo>> smsLogin(@Body Map<String, String> map);

    /**
     * API.02.01.009 普通登录（密码登录）接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/password_login")
    Observable<ApiResult<UserInfo>> passwordLogin(@Body Map<String, String> params);


    /**
     * API.02.01.002 TV用户信息验证和查询接口
     *
     * @param telephone 固话/手机
     * @param custName  用户名称
     */

    @GET("/api/members/members/verify_tvuser")
    Observable<ApiResult<UserInfo>> verifyTVUser(@Query(value = "telephone") String telephone, @Query(value = "cust_name") String custName);

    /**
     * API.02.01.007 绑定手机（登录成功后）接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/binding_mobile")
    Observable<ApiResult<Result<String>>> bindMobile(@Body Map<String, String> params);


    /**
     * API.02.01.005 会员最近购买信息混淆列表接口
     *
     * @param memberId 会员ID
     * @param type
     */
    @GET("/api/members/members/hist_items")
    Observable<ApiResult<TvSafeVerifyBean>> tvUserVerifyImg(@Query(value = "cust_no") String memberId, @Query(value = "image_type") String type);


    /**
     * API.02.01.006 安全校验登录（回答问题）接口
     * member_id
     * hist_receivers
     * hist_address
     * hist_items
     * access_token
     * name
     */
    @POST("/api/members/members/login_by_qa")
    Observable<String> loginByQa(@QueryMap(encoded = true) Map<String, String> map);

    /**
     * API.02.10.002 手机验证码准确性检查接口
     *
     * @param cellphone
     * @param purpose
     * @param smspasswd
     */
    @GET("/api/members/smscode/check_verify_code_mobile")
    Observable<ApiResult<VerifyBean>> checkVerifyCode(@Query(value = "cellphone") String cellphone, @Query(value = "smspasswd") String smspasswd, @Query(value = "purpose") String purpose);

    /**
     * API.02.01.004 密码设置（登录成功后）接口
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/set_password")
    Observable<ApiResult<UserInfo>> updatePassword(@Body Map<String, String> params);

    /**
     * API.02.11.003 发送邮箱链接接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/emailcode/find_password")
    Observable<String> mailResetPassword(@Body Map<String, String> params);

    /**
     * API.02.01.006 安全校验登录
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/login_by_qa")
    Observable<ApiResult<UserInfo>> tvUserSafeLogin(@Body Map<String, String> params, @Query(value = "device_id") String way);


    /**
     * API.02.01.018  电视用户手机登录
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/tv_login")
    Observable<ApiResult<UserInfo>> tvUserMobileLogin(@Body Map<String, String> params, @Query(value = "device_id") String deviceId);


    /**
     * API.02.01.015 会员信息查询
     */
    @GET("/api/members/members/check_member_info")
    Observable<ApiResult<MemberBean>> checkMemberInfo(@Query(value = "access_token") String token);

    /**
     * 1.2	API.02.01.031修改用户生日
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_birthday")
    Observable<ApiResult<Result<String>>> changeBirthday(@Body Map<String, String> params);


    /**
     * API.02.01.022修改会员手机
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_tel")
    Observable<ApiResult<Result<String>>> changeMobile(@Body Map<String, String> params);

    /**
     * API.02.10.004 修改会员手机发送验证码
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/smscode/sms_changetel")
    Observable<ApiResult<VerifyBean>> smschange(@Body Map<String, String> params);


    /**
     * API.02.01.030 修改昵称
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_name")
    Observable<ApiResult<Result<String>>> changeName(@Body Map<String, String> params);

    /**
     * API.02.01.023 修改邮箱
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_email")
    Observable<ApiResult<Result<String>>> changeMail(@Body Map<String, String> params);

    /**
     * 修改头像
     */
    @Multipart
    @POST("/api/members/members/change_portrait")
    Observable<ApiResult<Result<String>>> changePortrait(@Part MultipartBody.Part file);


    /**
     * API.02.16.001 微信第三方登录接口
     *
     * @param code
     */
    @GET("/api/members/thirdaccounts/wechat_login")
    Observable<ApiResult<ThirdBean>> wechatlogin(@Query(value = "code") String code, @Query(value = "device_id") String way);


    /**
     * API.02.16.002 微博第三方登录
     *
     * @param code
     */
    @GET("/api/members/thirdaccounts/weibo_login")
    Observable<ApiResult<ThirdBean>> weiboLogin(@Query(value = "code") String code, @Query(value = "device_id") String dvId);


    /**
     * API.02.16.005
     * <p>
     * QQ第三方登录接口
     */
    @GET("/api/members/thirdaccounts/qq_login")
    Observable<ApiResult<ThirdBean>> qqLogin(@Query(value = "code") String code, @Query(value = "device_id") String dvId);


    /**
     * API.02.16.003
     * <p>
     * 支付宝第三方登录接口
     *
     * @param code
     */
    @GET("/api/members/thirdaccounts/alipay_callback?device_id=123")
    Observable<ApiResult<ThirdBean>> aliPayLogin(@Query(value = "code") String code);


    /**
     * <p>
     * 支付宝秘钥获取
     */
    @GET("/api/members/thirdaccounts/alipay_auth_login?msale_way=ADR")
    Observable<ApiResult<AlipayAuth>> alipayLoginSecret();

    /**
     * <p>
     * 2.59	API.02.01.025电视用户首次用手机登录接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/tel_phone_login")
    Observable<ApiResult<UserInfo>> telPhoneLogin(@Body Map<String, String> params);

    /**
     * <p>
     * 意见反馈接口
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/suggestion/feedback")
    Observable<ApiResult<Result<String>>> suggestion(@Body Map<String, String> params);

    /**
     * API.02.06.008
     * <p>
     * 签到满15天彩票领取接口
     *
     * @param userName
     * @param mobile
     * @param cardId
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/cust/fct/get?sign_fct=fct")
    Observable<ApiResult<String>> signGetLottery(@Query(value = "userName") String userName, @Query(value = "mobile") String mobile,
                                                 @Query(value = "cardId") String cardId, @Query(value = "access_token") String access_token);

    /**
     * API.02.06.009
     * <p>
     * 签到20天领取满签礼包
     *
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/full/sign?sign_inSize=sign2")
    Observable<ApiResult<SignPacksBean>> signGetPacks(@Query(value = "access_token") String access_token);

    /**
     * API.02.06.001
     * <p>
     * 签到接口
     *
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/check_in")
    Observable<ApiResult<SignBean>> sign(@Query(value = "access_token") String access_token);

    /**
     * API.02.06.010
     * <p>
     * <p>
     * 签到页面的查询接口
     *
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/sign/mcontent")
    Observable<ApiResult<SignDetailBean>> signDetail(@Query(value = "access_token") String access_token);

    /**
     * API.02.06.007
     * <p>
     * <p>
     * 彩票查询接口
     *
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/cust/fct/search")
    Observable<ApiResult<LotteryListBean>> getLotteryList(@Query(value = "access_token") String access_token);

    /**
     * API.02.06.011
     * <p>
     * <p>
     * 签到页面的礼包查询
     *
     * @param access_token
     * @return
     */
    @GET("/api/members/opoints/sign/details")
    Observable<ApiResult<SignPacksListBean>> getSignPacksList(@Query(value = "access_token") String access_token);

    /**
     * 获取所有smg内容
     *
     * @param id
     * @return
     */
    @GET("/cms/pages/relation/pageV1")
    Observable<ApiResult<CmsContentBean>> getSMGList(@Query(value = "id") String id);

    /**
     * API.03.12.004预约订单生成接口
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/orders/advanceorders/provide_advance_order_info")
    Observable<ApiResult<ReserveOrderBean>> getReserveOrder(@Body Map<String, String> params);

    /**
     * API.03.12.001预约订单写入接口
     *
     * @param params
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/orders/advanceorders/create_advance_order")
    Observable<ApiResult<SubmitReserveOrderBean>> submitReserveOrder(@Body Map<String, String> params);

    /**
     * 退出登录
     */
    @GET("/api/members/members/logout")
    Observable<ApiResult<ResultStr>> logout();

    /**
     * API.02.20.001 app版本检测
     *
     * @param
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/app/ver/check")
    Observable<ApiResult<CheckUpdateBean>> checkUpdate(@Body Map<String, String> params);

    /**
     * API.02.01.032 修改会员分站
     *
     * @param
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/members/members/change_new_address")
    Observable<ApiResult<Object>> editUserStation(@Body Map<String, String> params);


}
