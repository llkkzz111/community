package com.ocj.oms.mobile.http.service.account;

import android.content.Context;
import android.graphics.Bitmap;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.ServiceGenerator;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ParamKeys;
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
import com.ocj.oms.utils.DeviceUtils;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.Observer;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liuzhao on 2017/4/13.
 */

public class AccountMode extends BaseModel {
    public AccountMode(Context context) {
        super(context);
    }

    /**
     * 游客登录
     *
     * @param mObservable
     */
    public void visitLogin(Map<String, String> params, ApiObserver<ApiResult<UserInfo>> mObservable) {
        AccountService apiService = createService(AccountService.class);
        Observable<ApiResult<UserInfo>> observable = apiService.visitLogin(params);
        subscribe(observable, mObservable);
    }

    /**
     * 检查token类型
     *
     * @param mObservable
     */
    public void checkToken(String token, ApiObserver<ApiResult<CheckToken>> mObservable) {
        AccountService apiService = createService(AccountService.class);
        Observable<ApiResult<CheckToken>> observable = apiService.checkToken(token);
        subscribe(observable, mObservable);
    }

    /**
     * 免密登录
     *
     * @param mObservable
     */
    public void accessToken(String accessToken, ApiObserver<ApiResult<UserInfo>> mObservable) {
        AccountService apiService = createService(AccountService.class);
        Observable<ApiResult<UserInfo>> observable = apiService.accessToken(accessToken);
        subscribe(observable, mObservable);
    }

    /**
     * 检查用户类型
     *
     * @param loginId
     * @param apiResultObserver
     */
    public void checkLogin(String loginId, ApiResultObserver<UserType> apiResultObserver) {
        AccountService apiService = createService(AccountService.class);
        Observable<ApiResult<UserType>> observable = apiService.checkLogin(loginId);
        subscribe(observable, apiResultObserver);
    }

    /**
     * 获取短信验证码
     *
     * @param params
     * @param mObservable
     */
    public void getVerifyCode(Map<String, String> params, ApiObserver<ApiResult<VerifyBean>> mObservable) {
        AccountService apiService = ServiceGenerator.createService(AccountService.class);
        Observable<ApiResult<VerifyBean>> observable = apiService.getVerifyCode(params);
        subscribe(observable, mObservable);
    }

    public void checkVerifyCode(String cellphone, String smspasswd, String purpose, ApiObserver<ApiResult<VerifyBean>> apiObserver) {
        subscribe(createService(AccountService.class).checkVerifyCode(cellphone, smspasswd, purpose), apiObserver);
    }

    public Observable<ApiResult<VerifyBean>> checkCode(String cellphone, String smspasswd, String purpose) {
        return createService(AccountService.class).checkVerifyCode(cellphone, smspasswd, purpose);
    }

    /**
     * 手机验证码快速登录接口
     *
     * @param params
     * @param apiResultObserver
     */
    public void smsLogin(Map<String, String> params, ApiResultObserver<UserInfo> apiResultObserver) {
        subscribe(createService(AccountService.class).smsLogin(params), apiResultObserver);
    }


    /**
     * 短信验证码登录
     *
     * @param apiResultObserver
     */
    public void smsLogin(String phone, String verifyCode, String purpose, ApiResultObserver<UserInfo> apiResultObserver) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.PURPOSE, purpose);
        params.put(ParamKeys.MOBILE, phone);
        params.put(ParamKeys.VERIFY_CODE, verifyCode);
        smsLogin(params, apiResultObserver);
    }

    /**
     * 密码登录
     *
     * @param params
     * @param apiResultObserver
     */
    public void passwordLogin(Map<String, String> params, ApiResultObserver<UserInfo> apiResultObserver) {
        Observable observable = ServiceGenerator.createService(AccountService.class).passwordLogin(params);
        subscribe(observable, apiResultObserver);
    }

    /**
     * 电视用户固话认证登录
     *
     * @param apiResultObserver
     */
    public void tvUserLogin(String tele, String name, ApiResultObserver<UserInfo> apiResultObserver) {
        Observable observable = ServiceGenerator.createService(AccountService.class).verifyTVUser(tele, name);
        subscribe(observable, apiResultObserver);
    }


    /**
     * 手机快速注册
     */
    public void rapidRigester(Map<String, String> map, ApiObserver<ApiResult<UserInfo>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).rapidRagisterNew(map);
        subscribe(observable, observer);

    }

    /**
     * 发送邮箱验证码
     */
    public void mailResetPassword(Map<String, String> params, ApiObserver<String> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).mailResetPassword(params);
        subscribe(observable, observer);

    }

    /**
     * 修改密码
     */
    public void updatePassword(Map<String, String> params, ApiObserver<ApiResult<UserInfo>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).updatePassword(params);
        subscribe(observable, observer);

    }


    /**
     * 电视用户固话登录 获取图片列表
     */
    public void getTvUserSafeImglist(String memberId, String type, ApiObserver<ApiResult<TvSafeVerifyBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).tvUserVerifyImg(memberId, type);
        subscribe(observable, observer);

    }

    /**
     * API.02.01.007 绑定手机（登录成功后）接口
     */
    public void bindMobile(Map<String, String> params, ApiObserver<ApiResult<Result<String>>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).bindMobile(params);
        subscribe(observable, observer);
    }


    /**
     * 电视用户固话验证登录
     */
    public void tvUserSafeLogin(Map<String, String> params, Observer<ApiResult<UserInfo>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).tvUserSafeLogin(params, DeviceUtils.getAndroidID(mContext));
        subscribe(observable, observer);
    }

    /**
     * 电视用户手机验证码验证登录
     */
    public void tvUserMoblieLogin(Map<String, String> params, Observer<ApiResult<UserInfo>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).tvUserMobileLogin(params, DeviceUtils.getAndroidID(mContext));
        subscribe(observable, observer);
    }

    /**
     * 会员信息查询
     */
    public void checkMemberInfo(String token, ApiObserver<ApiResult<MemberBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).checkMemberInfo(token);
        subscribe(observable, observer);
    }

    /**
     * 1.2	API.02.01.031修改用户生日
     */
    public void changeBirthday(Map<String, String> params, ApiObserver<ApiResult<Result<String>>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).changeBirthday(params);
        subscribe(observable, observer);
    }


    /**
     * 修改会员手机号 02.01.022
     */
    public void changeMobile(Map<String, String> params, ApiObserver<ApiResult<Result<String>>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).changeMobile(params);
        subscribe(observable, observer);
    }

    /**
     * 修改会员手机号发送验证码 02.10.004
     */
    public void smsChange(Map<String, String> params, ApiObserver<ApiResult<VerifyBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).smschange(params);
        subscribe(observable, observer);
    }

    /**
     * 修改会员手机号发送验证码 02.10.004
     */
    public void changeName(Map<String, String> params, ApiObserver<ApiResult<Result<String>>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).changeName(params);
        subscribe(observable, observer);
    }

    /**
     *
     */
    public void changeMail(Map<String, String> params, ApiObserver<ApiResult<Result<String>>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).changeMail(params);
        subscribe(observable, observer);
    }


    /**
     * 微信登录
     */
    public void wechatLogin(String code, String way, ApiObserver<ApiResult<ThirdBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).wechatlogin(code, way);
        subscribe(observable, observer);

    }

    /**
     * QQ登录
     */
    public void qqLogin(String code, String deviceId, ApiObserver<ApiResult<ThirdBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).qqLogin(code, deviceId);
        subscribe(observable, observer);

    }

    /**
     * 微博登录
     */
    public void weiboLogin(String code, String deviceId, ApiObserver<ApiResult<ThirdBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).weiboLogin(code, deviceId);
        subscribe(observable, observer);

    }


    /**
     * 支付宝登录
     */
    public void aliPayLogin(String code, String way, ApiObserver<ApiResult<ThirdBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).aliPayLogin(code);
        subscribe(observable, observer);
    }

    /**
     * 支付宝秘钥获取
     */
    public Observable<ApiResult<AlipayAuth>> alipayLoginSecret() {
        return ServiceGenerator.createService(AccountService.class).alipayLoginSecret();
    }

    /**
     * 2.59	API.02.01.025电视用户首次用手机登录接口
     */
    public void telPhoneLogin(Map<String, String> params, ApiResultObserver<UserInfo> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).telPhoneLogin(params);
        subscribe(observable, observer);
    }

    /**
     * 意见反馈
     */
    public void suggestion(Map<String, String> params, ApiResultObserver<Result<String>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).suggestion(params);
        subscribe(observable, observer);
    }


    /**
     * 修改头像
     */
    public void changePortrait(Bitmap bitmap, ApiObserver<ApiResult<Result<String>>> observer) {
        RequestBody requestBody = RequestBody.create(MediaType.parse("image"), compressImage(bitmap));
        MultipartBody.Part body =
                MultipartBody.Part.createFormData("file", "abc.jpg", requestBody);

        Observable observable = ServiceGenerator.createService(AccountService.class).changePortrait(body);
        subscribe(observable, observer);
    }


    // 压缩图片 微信
    private byte[] compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while (baos.toByteArray().length / 1024 > 100 && options >= 10) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();// 重置baos即清空baos
            if (options == 0) {
                options = 1;
            }
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);// 这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;// 每次都减少10
        }

        return baos.toByteArray();
    }

    /**
     * 签到满15天彩票领取接口
     */
    public void signGetLottery(String userName, String mobile, String cardId, String access_token, ApiResultObserver<String> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).signGetLottery(userName, mobile, cardId, access_token);
        subscribe(observable, observer);
    }

    /**
     * 签到20天领取满签礼包
     */
    public void signGetPacks(String access_token, ApiObserver<ApiResult<SignPacksBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).signGetPacks(access_token);
        subscribe(observable, observer);
    }

    /**
     * 签到接口
     */
    public void sign(String access_token, ApiObserver<ApiResult<SignBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).sign(access_token);
        subscribe(observable, observer);
    }

    /**
     * 签到页面的查询接口
     */
    public void signDetail(String access_token, ApiObserver<ApiResult<SignDetailBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).signDetail(access_token);
        subscribe(observable, observer);
    }

    /**
     * 彩票查询接口
     */
    public void getLotteryList(String access_token, ApiObserver<ApiResult<LotteryListBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).getLotteryList(access_token);
        subscribe(observable, observer);
    }

    /**
     * 签到页面的礼包查询
     */
    public void getSignPacksList(String access_token, ApiObserver<ApiResult<SignPacksListBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).getSignPacksList(access_token);
        subscribe(observable, observer);
    }

    /**
     * 获取所有smg内容
     */
    public void getSMGList(ApiObserver<ApiResult<CmsContentBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).getSMGList("AP1706A002");
        subscribe(observable, observer);
    }

    /**
     * 预约订单生成接口
     */
    public void getReserveOrder(Map<String, String> params, ApiObserver<ApiResult<ReserveOrderBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).getReserveOrder(params);
        subscribe(observable, observer);
    }

    /**
     * 预约订单写入接口
     */
    public void submitReserveOrder(Map<String, String> params, ApiObserver<ApiResult<SubmitReserveOrderBean>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).submitReserveOrder(params);
        subscribe(observable, observer);
    }

    /**
     * 退出登录
     */
    public void logout(ApiObserver<ApiResult<ResultStr>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).logout();
        subscribe(observable, observer);
    }

    public void checkUpdate(String platform, String app_ver, ApiResultObserver<CheckUpdateBean> observer) {
        Map<String, String> params = new HashMap<>();
        params.put("platform", platform);
        params.put("app_ver", app_ver);
        Observable observable = ServiceGenerator.createService(AccountService.class).checkUpdate(params);
        subscribe(observable, observer);
    }


    /**
     * 修改用户分站
     */
    public void editUserStationCode(Map<String, String> params, ApiObserver<ApiResult<Object>> observer) {
        Observable observable = ServiceGenerator.createService(AccountService.class).editUserStation(params);
        subscribe(observable, observer);
    }


}
