package com.ocj.oms.mobile.ui.login;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.blankj.utilcode.utils.RegexUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.basekit.presenter.BasePresenter;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.register.RegisterActivity;
import com.ocj.oms.mobile.ui.register.RegisterInputMobileActivity;
import com.ocj.oms.mobile.ui.safty.SecurityCheckActivity;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.orhanobut.logger.Logger;

import org.greenrobot.eventbus.EventBus;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

import static com.ocj.oms.common.net.mode.ApiCode.Response.ERR_PWD;


/**
 * Created by liuzhao on 2017/4/12.
 */

public class LoginPresenter extends BasePresenter<LoginContract.View> implements LoginContract.Presenter {
    AccountMode accountMode;
    Activity mContext;
    public int type = -1;

    String loginId;

    public LoginPresenter(Activity mContext, LoginContract.View view) {
        this.view = view;
        this.mContext = mContext;
        this.accountMode = new AccountMode(mContext);
    }


    @Override
    public void getVerifyCode(final long countTime, final String mobileNum) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, mobileNum);
        if (type == UserType.TYPE_MOBILE) {
            params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        } else if (type == UserType.TYPE_MOBILE_TV) {
            params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_TVUSER_LOGIN);
        }
        new AccountMode(mContext).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(mContext) {
            @Override
            public void onSubscribe(Disposable d) {
                super.onSubscribe(d);
                view.loadingCode();
            }

            @Override
            public void onError(ApiException e) {
                view.getVerifyFail();
                view.finishLoadingCode();
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                String verifyCode = result.getData().getVerifyode();
                String internalId = result.getData().getInternetId();

                view.getInternalId(internalId);
                view.getVerifySuccess(verifyCode);
                Observable.interval(0, 1, TimeUnit.SECONDS)
                        .take(countTime + 1)
                        .subscribeOn(Schedulers.newThread())
                        .map(new Function<Long, Long>() {
                            @Override
                            public Long apply(Long aLong) throws Exception {
                                return countTime - aLong;
                            }
                        })
                        .doOnSubscribe(new Consumer<Disposable>() {
                            @Override
                            public void accept(Disposable disposable) throws Exception {
                                view.startCountTime();
                            }
                        })
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(new Observer<Long>() {
                            @Override
                            public void onSubscribe(Disposable d) {
                            }

                            @Override
                            public void onNext(Long aLong) {
                                view.countingTime(aLong);
                            }

                            @Override
                            public void onError(Throwable e) {
                            }

                            @Override
                            public void onComplete() {
                                view.finishCountTime();
                            }
                        });
            }

            @Override
            public void onComplete() {
                view.finishLoadingCode();
            }
        });
    }

    @Override
    public void checkUserType(final String loginId) {
        new AccountMode(mContext).checkLogin(loginId, new ApiResultObserver<UserType>(mContext) {

            @Override
            public void onSubscribe(Disposable d) {
                super.onSubscribe(d);
                view.showLoading();
            }

            @Override
            public void onError(ApiException e) {
                view.hideLoading();
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(UserType userType) {
                view.hideLoading();
                type = userType.getUserType();
                view.setUserType(type);
                switch (userType.getUserType()) {
                    case UserType.TYPE_UNKNOWN:
                        view.showUnknown(loginId);
                        break;
                    case UserType.TYPE_USER_NAME:
                        view.showNewMediaMail();
                        break;
                    case UserType.TYPE_MAIL:
                        view.showNewMediaMail();
                        break;
                    case UserType.TYPE_MOBILE:
                        view.showNewMediaMob();
                        break;
                    case UserType.TYPE_MOBILE_TV:
                        view.showTVMob();
                        break;
                    case UserType.TYPE_TV:
                        view.showTVTel();
                        break;
                    default:
                        break;
                }
            }
        });
    }

    /**
     * 多媒体手机登录
     */
    @Override
    public void smsLogin(Map<String, String> params) {
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        accountMode.smsLogin(params, new LoginApiResultObserver(mContext));

    }

    /**
     * 多媒体邮箱 用户名密码， 手机号密码
     *
     * @param params
     */
    @Override
    public void passwordLogin(Map<String, String> params) {
        accountMode.passwordLogin(params, new LoginApiResultObserver(mContext));
    }

    /**
     * 电视用户手机登录
     *
     * @param mobile
     * @param verifyCode
     * @param name
     */
    @Override
    public void tvMobLogin(String mobile, String verifyCode, String name, String internalId, String thirdId) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, mobile);
        params.put(ParamKeys.VERIFY_CODE, verifyCode);
        params.put(ParamKeys.INTERNAT_ID, internalId);
        params.put(ParamKeys.CUST_NAME, name);
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        params.put(ParamKeys.ASSOCIATE_STATE, thirdId);
        accountMode.telPhoneLogin(params, new LoginApiResultObserver(mContext));
    }

    /**
     * 电视用户电话登录
     *
     * @param tel
     * @param name
     */
    @Override
    public void tvTelLogin(final String tel, final String name) {

        accountMode.tvUserLogin(tel, name, new ApiResultObserver<UserInfo>(mContext) {

            @Override
            public void onSubscribe(Disposable d) {
                super.onSubscribe(d);
                view.showLoading();
            }

            @Override
            public void onError(ApiException e) {
                view.hideLoading();
                view.showShortToast(e.getMessage());
                view.loginFail(e.getCode(), e.getMessage());
            }

            @Override
            public void onSuccess(UserInfo apiResult) {
                view.hideLoading();
                String memberId = apiResult.getCust_no();
                Intent intent = new Intent(mContext, SecurityCheckActivity.class);
                intent.putExtra(IntentKeys.MEMBER_ID, memberId);
                intent.putExtra(IntentKeys.CUST_NAME, name);
                intent.putExtra(IntentKeys.INTERNAL_ID, apiResult.getInternet_id());
                intent.putExtra(IntentKeys.LOGIN_ID, tel);

                OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                OCJPreferencesUtils.setCustName(apiResult.getCust_name());
                OCJPreferencesUtils.setCustNo(apiResult.getCust_no());
                OCJPreferencesUtils.setLoginType(type + "");
                OCJPreferencesUtils.setLoginID(tel);

                EventBus.getDefault().post(IntentKeys.GET_HEAD_IMAGE);

                mContext.startActivity(intent);
            }


            @Override
            public void onComplete() {

            }
        });
    }


    public void setLoginId(String input) {
        this.loginId = input;
    }


    public class LoginApiResultObserver extends ApiResultObserver<UserInfo> {

        public LoginApiResultObserver(Context context) {
            super(context);
        }

        @Override
        public void onSubscribe(Disposable d) {
            super.onSubscribe(d);
            view.showLoading();
        }

        @Override
        public void onError(ApiException e) {
            view.hideLoading();
            view.loginFail(e.getCode(), e.getMessage());
        }

        @Override
        public void onSuccess(UserInfo userInfo) {
            view.hideLoading();
            OCJPreferencesUtils.setAccessToken(userInfo.getAccessToken());
            OCJPreferencesUtils.setCustName(userInfo.getCust_name());
            OCJPreferencesUtils.setCustNo(userInfo.getCust_no());
            OCJPreferencesUtils.setLoginType(type + "");
            OCJPreferencesUtils.setLoginID(loginId);
            OCJPreferencesUtils.setVisitor(false);
            Logger.i(userInfo.toString());
            EventBus.getDefault().post(IntentKeys.GET_HEAD_IMAGE);
            view.loginSuccess(userInfo);
        }
    }
}
