package com.ocj.oms.mobile.ui.login.media;

import android.content.Intent;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.ocj.oms.common.CropCircleTransformation;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.rn.RNActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import org.greenrobot.eventbus.EventBus;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import butterknife.BindView;
import butterknife.OnClick;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;

import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_WEBVIEW;


/**
 * 用户再次登录{1.账号密码  2.短信验证码}
 */
@Route(path = RouterModule.AROUTER_PATH_RELOGIN)
public class MobileReloginActivity extends BaseActivity {

    @BindView(R.id.iv_pwd_state) ImageView ivPwsState;
    @BindView(R.id.et_password) EditText etPassword;
    @BindView(R.id.et_med_getcode) ClearEditText etMobileCode;
    @BindView(R.id.tv_login_changetype) TextView tvChangeLoginType;//右边登录切换
    @BindView(R.id.tv_get_code) TextView tvGetCode;//发送短信按钮
    @BindView(R.id.ll_code_login) LinearLayout mobileParent;
    @BindView(R.id.ll_pwd_login) LinearLayout pwdParent;
    @BindView(R.id.tv_name_welcome) TextView tvName;
    @BindView(R.id.iv_head) ImageView ivHead;

    boolean pwdType = true;//是否是密码登录

    String loginId = "";

    @Override
    protected int getLayoutId() {
        return R.layout.activity_media_relogin;
    }


    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C005);
        initView();

    }

    private void initView() {

        Glide.with(mContext).load(OCJPreferencesUtils.getHeadImage()).
                skipMemoryCache(true).
                diskCacheStrategy(DiskCacheStrategy.NONE).
                error(R.drawable.icon_user).
                placeholder(R.drawable.icon_user).
                bitmapTransform(new CropCircleTransformation(mContext)).
                into(ivHead);
        loginId = TextUtils.isEmpty(OCJPreferencesUtils.getLoginId()) ? OCJPreferencesUtils.getInternetId() : OCJPreferencesUtils.getLoginId();
        String custName = TextUtils.isEmpty(OCJPreferencesUtils.getCustName()) ? "" : OCJPreferencesUtils.getCustName() + ",";
        tvName.setText(custName + "欢迎登录");
        tvChangeLoginType.setTag(pwdType);
        tvChangeLoginType.setText("使用动态码登录");

        if (!TextUtils.equals(OCJPreferencesUtils.getLoginType(), "3")) {
            tvChangeLoginType.setVisibility(View.GONE);
        }

        showPwd();

    }

    /**
     * 显示短信验证码
     */
    private void showMobileCode() {
        mobileParent.setVisibility(View.VISIBLE);
        pwdParent.setVisibility(View.GONE);
    }

    @OnClick({R.id.iv_pwd_state})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_pwd_state:
                if (etPassword.getTransformationMethod() == HideReturnsTransformationMethod.getInstance()) {//隐藏密码
                    etPassword.setTransformationMethod(PasswordTransformationMethod.getInstance());
                    ivPwsState.setSelected(false);
                    etPassword.setSelection(etPassword.getText().length());
                } else {//显示密码
                    etPassword.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                    ivPwsState.setSelected(true);
                    etPassword.setSelection(etPassword.getText().length());
                }
                break;
        }
    }

    /**
     * 显示账号密码
     */
    private void showPwd() {
        pwdParent.setVisibility(View.VISIBLE);
        mobileParent.setVisibility(View.GONE);
    }


    @OnClick({R.id.iv_left_back, R.id.tv_switch_account, R.id.tv_get_code, R.id.login_btn})
    public void onButtonClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left_back:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C005C005001C003001);
                RouterModule.invokeTokenCallback(null, OCJPreferencesUtils.getAccessToken(), "guest", false);
                EventBus.getDefault().post("login_out");
                break;

            case R.id.tv_switch_account:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C005F010001A001001);
                Intent intent = getIntent();
                intent.setClass(mContext, LoginActivity.class);
                startActivity(intent);
                break;

            case R.id.tv_get_code:
                sendCode(loginId);
                break;

            case R.id.login_btn:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C005F008001O008001);
                if (!pwdType) {
                    if (TextUtils.isEmpty(etMobileCode.getText())) {
                        ToastUtils.showLongToast("输入验证码不能为空!");
                        return;
                    }
                    loginByMobile(etMobileCode.getText().toString().trim());

                } else {
                    if (TextUtils.isEmpty(etPassword.getText())) {
                        ToastUtils.showLongToast("密码输入不能为空!");
                        return;
                    }
                    loginByPwd(etPassword.getText().toString().trim());
                }
                break;

        }

    }

    private void sendCode(String mobile) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, mobile);

        String mType = OCJPreferencesUtils.getLoginType();
        int type = Integer.parseInt(mType);
        if (type == UserType.TYPE_MOBILE) {
            params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        } else if (type == UserType.TYPE_MOBILE_TV) {
            params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_TVUSER_LOGIN);
        }
        new AccountMode(mContext).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(mContext) {

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                ToastUtils.showLongToast("验证码发送成功!");
                countDown();
            }

            @Override
            public void onComplete() {

            }
        });


    }

    /**
     * 密码登录
     */
    private void loginByPwd(String pwd) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.LOGIN_ID, loginId);
        params.put(ParamKeys.PASSWORD, pwd);
        showLoading();
        new AccountMode(mContext).passwordLogin(params, new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showLongToast(e.getMessage());

            }

            @Override
            public void onSuccess(UserInfo apiResult) {
                hideLoading();
                saveInfo(apiResult);
            }
        });


    }

    private void saveInfo(UserInfo result) {
        OCJPreferencesUtils.setAccessToken(result.getAccessToken());
        OCJPreferencesUtils.setCustName(result.getCust_name());
        OCJPreferencesUtils.setCustNo(result.getCust_no());
        OCJPreferencesUtils.setVisitor(false);
        EventBus.getDefault().post("login_success");
        junpToRN(result);
    }

    private void junpToRN(UserInfo userInfo) {
        if ("WebView".equals(getIntent().getStringExtra("from"))) {
            ActivityStack.getInstance().finishToActivity(RNActivity.class);
            ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                    .withString("url", getIntent().getStringExtra("fromPage"))
                    .navigation();

        } else {
            RouterModule.invokeTokenCallback(null, userInfo.getAccessToken(), "self", false);
            RouterModule.sendAdviceEvent("refreshMePage", true);
            RouterModule.sendRefreshCartEvent("", "");

        }
    }


    /**
     * 手机号码登录
     *
     * @param mobile *
     */
    private void loginByMobile(String mobile) {
        Map<String, String> params = new HashMap<>();
        showLoading();
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        params.put(ParamKeys.MOBILE, loginId);
        params.put(ParamKeys.VERIFY_CODE, mobile);
        new AccountMode(mContext).smsLogin(params, new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onSuccess(UserInfo apiResult) {
                hideLoading();
                saveInfo(apiResult);
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showLongToast(e.getMessage());

            }
        });
    }


    private void countDown() {
        Observable.interval(0, 1, TimeUnit.SECONDS)//设置0延迟，每隔一秒发送一条数据
                .take(121)
                .map(new Function<Long, Long>() {
                    @Override
                    public Long apply(@io.reactivex.annotations.NonNull Long aLong) throws Exception {
                        return 120 - aLong;
                    }
                })
                .doOnSubscribe(new Consumer<Disposable>() {
                    @Override
                    public void accept(@io.reactivex.annotations.NonNull Disposable disposable) throws Exception {
                        tvGetCode.setEnabled(false);
                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<Long>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Long aLong) {
                        if (aLong == 0) {
                            tvGetCode.setText("获取验证码");
                            tvGetCode.setTextColor(getResources().getColor(R.color.text_red_E5290D));
                            tvGetCode.setBackgroundResource(R.drawable.btn_verify_code);

                        } else {
                            tvGetCode.setText(String.format("%s 重新发送", aLong + ""));
                            tvGetCode.setTextColor(getResources().getColor(R.color.text_grey_666));
                            tvGetCode.setBackgroundResource(R.drawable.btn_timer_resent_code);
                        }
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {
                        tvGetCode.setEnabled(true);
                    }
                });
    }


    @OnClick({R.id.tv_login_changetype})
    public void onRightClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C005C005001A001001);
        boolean isPWdType = (boolean) tvChangeLoginType.getTag();
        tvChangeLoginType.setTag(!isPWdType);
        pwdType = !isPWdType;
        if (pwdType) {
            tvChangeLoginType.setText("使用动态码登录");
            showPwd();
        } else {
            tvChangeLoginType.setText("使用密码登录");
            showMobileCode();
        }


    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        EventBus.getDefault().post("login_out");
        RouterModule.invokeTokenCallback(null, OCJPreferencesUtils.getAccessToken(), "guest", false);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C005);
    }
}
