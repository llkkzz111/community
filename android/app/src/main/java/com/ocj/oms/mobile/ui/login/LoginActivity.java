package com.ocj.oms.mobile.ui.login;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.utils.RegexUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.ThirdBean;
import com.ocj.oms.mobile.bean.UserBean;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.UserType;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.third.login.ThirdPartyPresenter;
import com.ocj.oms.mobile.third.login.ThirdPartyView;
import com.ocj.oms.mobile.ui.MainActivity;
import com.ocj.oms.mobile.ui.login.association.AccountAssociationActivity;
import com.ocj.oms.mobile.ui.register.RegisterActivity;
import com.ocj.oms.mobile.ui.register.RegisterInputMobileActivity;
import com.ocj.oms.mobile.ui.reset.ResetCheckActivity;
import com.ocj.oms.mobile.ui.reset.ResetPasswordActivity;
import com.ocj.oms.mobile.ui.rn.RNActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.safty.BindMobileActivity;
import com.ocj.oms.mobile.view.CallTextView;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.DeviceUtils;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.RegExpValidatorUtils;
import com.ocj.oms.utils.system.AppUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;

import org.greenrobot.eventbus.EventBus;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import butterknife.OnTouch;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;

import static com.ocj.oms.common.net.mode.ApiCode.Response.ERR_PWD;
import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_WEBVIEW;

/**
 * 登录页面
 */
@Route(path = RouterModule.AROUTER_PATH_LOGIN)
public class LoginActivity extends BaseActivity<UserBean, LoginContract.View, LoginPresenter> implements LoginContract.View {

    @BindView(R.id.iv_title_logo) ImageView ivTitleLogo;
    @BindView(R.id.view_line) View viewLine;
    //用户头像
    @BindView(R.id.iv_logo) ImageView ivLogo;
    //欢迎登录
    @BindView(R.id.tv_login_greet) TextView tvGreet;
    //content
    @BindView(R.id.ll_content) LinearLayout llContent;
    //输入账户名
    @BindView(R.id.et_account) EditText etAccount;
    //输入密码
    @BindView(R.id.ll_pwd) LinearLayout llPwd;
    @BindView(R.id.et_pwd) EditText etPwd;
    @BindView(R.id.btn_pwd_hide) ImageView btnPwdHide;
    //输入验证码
    @BindView(R.id.ll_verify_code) LinearLayout llVerifyCode;
    @BindView(R.id.et_verify_code) EditText etVerifyCode;
    @BindView(R.id.btn_get_code) TextView btnGetCode;
    //输入姓名
    @BindView(R.id.et_user_name) EditText etUserName;
    //滑动解锁
    @BindView(R.id.ll_slide) LinearLayout llSlide;
    @BindView(R.id.slide) SlideLockView slideLockView;

    //登录
    @BindView(R.id.btn_login) Button btnLogin;
    //密码，动态密码切换
    @BindView(R.id.tv_change_pwd_type) TextView tvChangePwdType;
    //三方登录
    @BindView(R.id.ll_third_party) LinearLayout llThirdParty;
    @BindView(R.id.tv_title_third_login) TextView tvTitleThirdLogin;

    @BindView(R.id.tv_third) TextView tvThird;

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @BindView(R.id.tv_problems) CallTextView callText;

    public int pwdErrorTime = 0;
    //动画持续时间
    private long duration = 500;
    //上下位移高度
    private int toY = 0;
    private ThirdPartyPresenter thirdPartyPresenter;
    private IUiListener iUiListener;
    private SsoHandler ssoHandler;

    String internalId = "";
    private String associateState;
    private String result;
    //private int nums;
    boolean isVerify = false;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_login;
    }

    String inputLogin;


    @Override
    protected void initEventAndData() {
        IntentFilter recIntent = new IntentFilter();
        recIntent.addAction("wechat");
        registerReceiver(wxReceiver, recIntent);
        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C014);
        } else {
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C015);
        }
        String loginId = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        associateState = getIntent().getStringExtra(IntentKeys.ASSOCIATE_STATE);
        result = getIntent().getStringExtra(IntentKeys.RESULT);
        mPresenter = new LoginPresenter(this, this);
        initView();
        if (!TextUtils.isEmpty(loginId)) {
            etAccount.setText(loginId);
            tvTitleThirdLogin.setVisibility(View.GONE);
            ivTitleLogo.setVisibility(View.VISIBLE);
            ivLogo.setVisibility(View.GONE);
            tvGreet.setVisibility(View.GONE);
            checkLoginId();
        }


        thirdPartyPresenter = new ThirdPartyPresenter(this, new ThirdPartyView(this));
        toY = DensityUtil.dip2px(getBaseContext(), 65);

        //滑动解锁校验

        slideLockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                setLoginButtonCanClick();
                slideLockView.setStopAnim(false);
                isVerify = true;
            }

            @Override
            public void onVerifyFail() {
                btnLogin.setEnabled(false);
                btnLogin.setBackground(unClickBg);
                isVerify = false;
            }
        });

        if (AppUtil.isDebug()) {
            tvGreet.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    startActivity(new Intent(mContext, MainActivity.class));
                    return true;
                }
            });

            tvThird.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    startActivity(new Intent(mContext, MainActivity.class));
                    return true;
                }
            });
        }

        String eventId = getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE) ? EventId.AP1706C014F010003A001001 : EventId.AP1706C015F010004A001001;
        callText.setTraceEvent(eventId);
    }

    private void checkLoginId() {
        if (!TextUtils.isEmpty(getIntent().getStringExtra(IntentKeys.LOGIN_ID))) {
            llPwd.setVisibility(View.VISIBLE);
        }
    }

    private void initView() {
        btnLogin.setEnabled(false);
        btnLogin.setBackground(unClickBg);
        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
            llPwd.setVisibility(View.VISIBLE);
            tvChangePwdType.setVisibility(View.VISIBLE);
            tvChangePwdType.setText("使用动态码关联");
            btnLogin.setText("关 联");
            llThirdParty.setVisibility(View.GONE);
            tvTitleThirdLogin.setVisibility(View.VISIBLE);
            ivTitleLogo.setVisibility(View.GONE);
            ivLogo.setVisibility(View.GONE);
            tvGreet.setVisibility(View.GONE);
            mPresenter.checkUserType(getIntent().getStringExtra(IntentKeys.LOGIN_ID));
        }
    }


    private void setLoginButtonCanClick() {
        btnLogin.setEnabled(true);
        btnLogin.setBackground(normalBg);
    }

    @Override
    public void getInternalId(String id) {
        internalId = id;
    }

    @OnClick(R.id.btn_login)
    public void login() {
        inputLogin = etAccount.getText().toString();
        mPresenter.setLoginId(inputLogin);
        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
            OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C014F008001O008001);
        } else {
            Map<String, Object> parameters = new HashMap<String, Object>();
            parameters.put("text", inputLogin);
            OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015F008002O008001, "", parameters);
        }
        String thirdId = getIntent().getStringExtra(IntentKeys.ASSOCIATE_STATE);
        if (TextUtils.isEmpty(inputLogin)) {
            ToastUtils.showShortToast("请输入账号");
            return;
        }
        String tvTelUserName = etUserName.getText().toString();
        String mobileVerifyCode = etVerifyCode.getText().toString();

        Map<String, String> params = new HashMap<>();
        if (!TextUtils.isEmpty(associateState)) {
            params.put(ParamKeys.ASSOCIATE_STATE, associateState);
            params.put(ParamKeys.RESULT, result);
        }
        String pwd = etPwd.getText().toString();

        if (TextUtils.isEmpty(pwd) && llPwd.getVisibility() == View.VISIBLE) {
            ToastUtils.showShortToast("请输入密码");
            return;
        }

        if (llSlide.getVisibility() == View.VISIBLE && !isVerify) {
            ToastUtils.showLongToast("请完成安全验证");
            return;
        } else {
            setLoginButtonCanClick();
        }
        switch (mPresenter.type) {
            case UserType.TYPE_USER_NAME:
            case UserType.TYPE_MAIL:
            case UserType.TYPE_MOBILE:
                if (llPwd.getVisibility() == View.VISIBLE) {
                    params.put(ParamKeys.LOGIN_ID, inputLogin);
                    params.put(ParamKeys.PASSWORD, pwd);
                    mPresenter.passwordLogin(params);
                } else {
                    if (TextUtils.isEmpty(mobileVerifyCode)) {
                        ToastUtils.showShortToast("请输入验证码");
                        return;
                    }
                    params.put(ParamKeys.MOBILE, inputLogin);
                    params.put(ParamKeys.VERIFY_CODE, mobileVerifyCode);
                    mPresenter.smsLogin(params);
                }
                break;
            case UserType.TYPE_TV:
            case UserType.TYPE_MOBILE_TV:
                if (TextUtils.isEmpty(tvTelUserName)) {
                    ToastUtils.showShortToast("请输入用户名");
                    return;
                }
                if (UserType.TYPE_TV == mPresenter.type) {
                    mPresenter.tvTelLogin(inputLogin, tvTelUserName);
                } else {
                    if (TextUtils.isEmpty(mobileVerifyCode)) {
                        ToastUtils.showShortToast("请输入验证码");
                        return;
                    }
                    mPresenter.tvMobLogin(inputLogin, mobileVerifyCode, tvTelUserName, internalId, thirdId);
                }
                break;

            default:
                mPresenter.checkUserType(inputLogin);
                break;
        }
    }

    /**
     * 校验密码长度以及是否由密码和数字组合而成
     *
     * @param pwd
     */
    private boolean checkPwd(String pwd) {
        if (llPwd.getVisibility() == View.VISIBLE) {
            if (pwd.length() < 6) {
                ToastUtils.showLongToast("密码最短长度为6");
                return false;
            }
            if (RegExpValidatorUtils.isNumber(pwd) || RegExpValidatorUtils.isLetter(pwd)) {
                ToastUtils.showLongToast("密码请置为数字和字母组合");
                return false;
            }
            return true;
        }
        return false;
    }

    @OnTouch(R.id.et_account)
    public boolean onEtAccountTouch() {
        if (!etAccount.isFocused()) {
            etAccount.requestFocus();
            etAccount.setSelection(etAccount.getText().length());
            if (!getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE) && ivTitleLogo.getVisibility() != View.VISIBLE) {
                animation();
            }
            return true;
        }
        return false;
    }

    @OnClick({R.id.btn_get_code, R.id.btn_close, R.id.btn_go_rapid_register,
            R.id.tv_pwd_forget, R.id.btn_pwd_hide})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_close:
                if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C014D003001C003001);
                } else {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C005001C003001);
                }
                RouterModule.invokeTokenCallback(null, OCJPreferencesUtils.getAccessToken(), "guest", false);
                EventBus.getDefault().post("login_out");
                break;
            case R.id.btn_go_rapid_register:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C005001A001001);
                Intent intent1 = getIntent();
                intent1.setClass(mContext, RegisterInputMobileActivity.class);
                startActivity(intent1);
                break;

            case R.id.tv_pwd_forget:
                if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C014F010001A001001);
                } else {
                    Map<String, Object> parameters = new HashMap<String, Object>();
                    parameters.put("text", etAccount.getText().toString());

                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015F010001A001001, "", parameters);
                }
                //忘记密码
                Intent intent = new Intent();
                intent.putExtra(IntentKeys.LOGIN_ID, etAccount.getText().toString());
                intent.putExtra(IntentKeys.LOGIN_TYPE, userType + "");
                intent.setClass(mContext, ResetCheckActivity.class);
                startActivity(intent);
                break;
            case R.id.btn_pwd_hide:
                //隐藏密码
                if (PasswordTransformationMethod.getInstance().equals(etPwd.getTransformationMethod())) {
                    etPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                    btnPwdHide.setSelected(true);
                } else {
                    etPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
                    btnPwdHide.setSelected(false);
                }
                etPwd.setSelection(etPwd.getText().length());
                break;
            case R.id.btn_get_code:
                String loginID = etAccount.getText().toString();
                if (TextUtils.isEmpty(loginID) || !RegexUtils.isMobileSimple(loginID)) {
                    ToastUtils.showShortToast("请输入正确的手机号");
                    return;
                }
                //获取验证码
                mPresenter.getVerifyCode(120, loginID);
                break;

        }
    }

    @OnClick({R.id.ll_besttv_login, R.id.ll_wechat_login, R.id.ll_alipay_login, R.id.ll_qq_login, R.id.ll_weibo_login})
    void onThridLogin(View view) {
        switch (view.getId()) {
            case R.id.ll_besttv_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C002001C002001);
                break;
            case R.id.ll_wechat_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C002001C002002);
                thirdPartyPresenter.wechatLogin();
                break;
            case R.id.ll_qq_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C002001C002003);
                iUiListener = thirdPartyPresenter.qqLogin();
                break;
            case R.id.ll_alipay_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C002001C002004);
                thirdPartyPresenter.alipayLogin();
                break;
            case R.id.ll_weibo_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015C002001C002005);
                ssoHandler = thirdPartyPresenter.weiboLogin();
                break;
        }
    }

    @OnClick({R.id.tv_change_pwd_type})
    void onSentCode(View v) {

        llSlide.setVisibility(View.GONE);

        setLoginButtonCanClick();
        if (llPwd.getVisibility() == View.VISIBLE) {
            if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C014F010002A001001);
            } else {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015F010003A001001);
            }

            inputDynamicPwd();
        } else {
            if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C014F010002A001001);
            } else {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C015F010002A001001);
            }
            inputNormalPwd();
        }
    }

    @OnTextChanged(value = R.id.et_account, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onAfterTextChanged(CharSequence text) {
        if (!TextUtils.isEmpty(etAccount.getText())) {
            setLoginButtonCanClick();
        } else {
            clearState();
            //setLoginButtonUnClick();
        }

    }

    private void clearState() {
        mPresenter.type = -1;
        llPwd.setVisibility(View.GONE);
        etPwd.setText("");
        llVerifyCode.setVisibility(View.GONE);
        etVerifyCode.setText("");
        etUserName.setVisibility(View.GONE);
        etUserName.setText("");
        tvChangePwdType.setVisibility(View.GONE);
        llSlide.setVisibility(View.GONE);
    }

    @Override
    public void fail(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

    /**
     * 新媒体邮箱登录
     */
    @Override
    public void showNewMediaMail() {
        llPwd.setVisibility(View.VISIBLE);
        btnLogin.setText(R.string.login);
    }

    /**
     * 新媒体手机号登录
     */
    @Override
    public void showNewMediaMob() {
        llPwd.setVisibility(View.VISIBLE);
        tvChangePwdType.setVisibility(View.VISIBLE);
        btnLogin.setText(R.string.login);
    }

    /**
     * 电视用户电话登录
     */
    @Override
    public void showTVTel() {
        etUserName.setVisibility(View.VISIBLE);
        btnLogin.setText(R.string.login);
    }

    /**
     * 电视用户手机号登录
     */
    @Override
    public void showTVMob() {
        llVerifyCode.setVisibility(View.VISIBLE);
        etUserName.setVisibility(View.VISIBLE);
        btnLogin.setText(R.string.login);
    }

    /**
     * 密码登录
     */
    @Override
    public void inputNormalPwd() {
        llPwd.setVisibility(View.VISIBLE);
        etPwd.setText("");
        llVerifyCode.setVisibility(View.GONE);
        tvChangePwdType.setText(R.string.text_dynamic_pwd);
    }

    /**
     * 动态密码登录
     */
    @Override
    public void inputDynamicPwd() {
        llPwd.setVisibility(View.GONE);
        llVerifyCode.setVisibility(View.VISIBLE);
        etVerifyCode.setText("");
        tvChangePwdType.setText(R.string.login_bypwd);
    }


    @Override
    public void showUnknown(final String msg) {
        DialogFactory.showRightDialog(mContext, msg + " 尚未成为会员", "返回", "去注册", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = mContext.getIntent();
                if (RegexUtils.isMobileSimple(msg)) {
                    intent.setClass(mContext, RegisterActivity.class);
                } else {
                    intent.setClass(mContext, RegisterInputMobileActivity.class);
                }

                intent.putExtra(IntentKeys.LOGIN_ID, msg);
                mContext.startActivity(intent);
            }
        }).show(mContext.getFragmentManager(), "register");
    }

    @Override
    public void startCountTime() {
        btnGetCode.setEnabled(false);
        btnGetCode.setTextColor(Color.parseColor("#666666"));
        btnGetCode.setSelected(true);
    }

    @Override
    public void countingTime(long time) {
        btnGetCode.setText(time + " 重新发送");
    }

    @Override
    public void finishCountTime() {
        btnGetCode.setEnabled(true);
        btnGetCode.setTextColor(Color.parseColor("#E5290D"));
        btnGetCode.setSelected(false);
        btnGetCode.setText(R.string.btn_fetch_verify_code);
    }

    @Override
    public void getVerifyFail() {
        btnGetCode.setEnabled(true);
        btnGetCode.setTextColor(Color.parseColor("#E5290D"));
        btnGetCode.setSelected(false);
        btnGetCode.setText(R.string.btn_fetch_verify_code);
        ToastUtils.showShortToast("验证码获取失败！");
    }

    @Override
    public void getVerifySuccess(String verifyCode) {
//        etVerifyCode.setText(verifyCode);
    }

    @Override
    public void loadingCode() {
        btnGetCode.setEnabled(false);
        showLoading();
    }

    @Override
    public void finishLoadingCode() {
        hideLoading();
    }

    @Override
    public void loginFail(int code, String msg) {
        if (code == ERR_PWD) {
            if (pwdErrorTime == 2) {
                checkSlideShow();
                etPwd.setText("");
                slideLockView.reset();
                isVerify = false;
            } else {
                pwdErrorTime++;
            }
            showErrorDialog(code, msg);
        } else {
            showLongToast(msg);
        }

    }

    public void checkSlideShow() {
        if ((mPresenter.type == UserType.TYPE_USER_NAME || mPresenter.type == UserType.TYPE_MAIL || mPresenter.type == UserType.TYPE_MOBILE) && llPwd.getVisibility() == View.VISIBLE) {
            showSlide();
        } else {
            hideSlide();
        }
    }

    private void showSlide() {
        llSlide.setVisibility(View.VISIBLE);
    }

    public void hideSlide() {
        llSlide.setVisibility(View.GONE);
        setLoginButtonCanClick();
    }

    /**
     * 根据不同的code 显示对应的dialog
     *
     * @param code
     */
    private void showErrorDialog(int code, String msg) {
        DialogFactory.showLeftDialog(mContext, msg, "找回密码", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mContext, ResetCheckActivity.class);
                intent.putExtra(IntentKeys.LOGIN_ID, etAccount.getText().toString());
                intent.putExtra(IntentKeys.LOGIN_TYPE, userType + "");
                startActivity(intent);
            }
        }).show(getFragmentManager(), "login_error");
    }

    private int userType;

    @Override
    public void setUserType(int userType) {
        this.userType = userType;
    }

    @Override
    public void loginSuccess(final UserInfo userInfo) {
        pwdErrorTime = 0;
        OCJPreferencesUtils.setVisitor(false);
        OCJPreferencesUtils.setInternetId(userInfo.getInternet_id());
        EventBus.getDefault().post("login_success");
        if (userType == UserType.TYPE_MOBILE_TV) {//电视用户需要跳转到设置密码界面
            Intent intent = getIntent();
            intent.setClass(mContext, ResetPasswordActivity.class);
            intent.putExtra(IntentKeys.LOGIN_ID, inputLogin);
            intent.putExtra(IntentKeys.LOGIN_TYPE, userType + "");
            intent.putExtra(IntentKeys.TVMOBILE_USER_PWD, "tv_mobile_user_pwd");
            mContext.startActivity(intent);
        } else if ((userType == UserType.TYPE_MAIL || userType == UserType.TYPE_USER_NAME) && TextUtils.isEmpty(userInfo.getMobile())) {
            DialogFactory.showDialog(mContext, new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    junpToRN(userInfo);

                }
            }, new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = getIntent();
                    intent.setClass(mContext, BindMobileActivity.class);
                    intent.putExtra(IntentKeys.NO_MOBILE, "noMobile");
                    intent.putExtra(IntentKeys.INTERNAL_ID, userInfo.getInternet_id());
                    intent.putExtra(IntentKeys.ACCESS_TOKEN, userInfo.getAccessToken());
                    mContext.startActivity(intent);
                }
            }).show(getFragmentManager(), "mobile");
        } else {
            junpToRN(userInfo);
        }

    }

    private void junpToRN(UserInfo userInfo) {
        if ("WebView".equals(getIntent().getStringExtra("from"))) {
            ActivityStack.getInstance().finishToActivity(RNActivity.class);
            ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                    .withString("from", "RNActivity")
                    .withString("url", getIntent().getStringExtra("fromPage"))
                    .navigation();
        } else {
            RouterModule.invokeTokenCallback(null, userInfo.getAccessToken(), "self", false);
            RouterModule.sendAdviceEvent("refreshMePage", false);
            RouterModule.sendRefreshCartEvent("", "");
        }
    }


    private void animation() {
        greetMove();
        logoMove();
        contentMove();
        lineScale();
    }

    private void contentMove() {
        Animation mTranslateAnimation1 = new TranslateAnimation(0, 0, 0, -toY - ivLogo.getHeight() / 2 - DensityUtil.dip2px(getBaseContext(), 5) - tvGreet.getHeight());// 移动
        mTranslateAnimation1.setDuration(duration);
        AnimationSet animationSet = new AnimationSet(true);
        animationSet.setFillAfter(true);
        animationSet.addAnimation(mTranslateAnimation1);
        llContent.startAnimation(animationSet);
        animationSet.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                ivTitleLogo.setVisibility(View.VISIBLE);
                Observable<Integer> observable = Observable.create(new ObservableOnSubscribe<Integer>() {
                    @Override
                    public void subscribe(ObservableEmitter<Integer> emitter) throws Exception {
                        emitter.onNext(1);
                    }
                });
                Consumer<Integer> consumer = new Consumer<Integer>() {
                    @Override
                    public void accept(Integer integer) throws Exception {
                        ivLogo.setVisibility(View.GONE);
                        tvGreet.setVisibility(View.GONE);
                        ivLogo.clearAnimation();
                        llContent.clearAnimation();
                        tvGreet.clearAnimation();
                    }
                };
                observable.subscribeOn(Schedulers.io())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe(consumer);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }


    private void greetMove() {
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(tvGreet, "scaleX", 1f, 0f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(tvGreet, "scaleY", 1f, 0f);
        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.setDuration(duration);
        animatorSet.play(scaleX).with(scaleY);
        animatorSet.start();

        Animation mTranslateAnimation1 = new TranslateAnimation(0, 0, 0, -toY - ivLogo.getHeight() / 2 - DensityUtil.dip2px(getBaseContext(), 5) - tvGreet.getHeight());// 移动
        mTranslateAnimation1.setDuration(duration);
        mTranslateAnimation1.setFillAfter(true);
        tvGreet.startAnimation(mTranslateAnimation1);
    }

    private void logoMove() {
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(ivLogo, "scaleX", 1f, 0.5f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(ivLogo, "scaleY", 1f, 0.5f);
        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.setDuration(duration);
        animatorSet.play(scaleX).with(scaleY);
        animatorSet.start();

        Animation mTranslateAnimation = new TranslateAnimation(0, 0, 0, -toY - DensityUtil.dip2px(getBaseContext(), 20));// 移动
        mTranslateAnimation.setDuration(duration);
        ivLogo.startAnimation(mTranslateAnimation);
    }

    private void lineScale() {
        ObjectAnimator alphaAnimator = ObjectAnimator.ofFloat(viewLine, "alpha", 0f, 1f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(viewLine, "scaleX", 0f, 1f);
        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.setDuration(500);
        animatorSet.play(alphaAnimator).with(scaleY);
        animatorSet.start();
        viewLine.setVisibility(View.VISIBLE);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (ssoHandler != null) {
            ssoHandler.authorizeCallBack(requestCode, resultCode, data);
        }
        if (iUiListener != null) {
            Tencent.onActivityResultData(requestCode, resultCode, data, iUiListener);
        }
        hideLoading();
    }


    //微信授权成功后返回(根据code去拿token)
    public void requestWxLogin(final String code, String deId) {
        hideLoading();
        new AccountMode(mContext).wechatLogin(code, DeviceUtils.getIMEI(mContext), new ApiResultObserver<ThirdBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(ThirdBean apiResult) {
                if (apiResult.getAssociateState().equals("0")) {//没有关联
                    Intent intent = new Intent(mContext, AccountAssociationActivity.class);
                    intent.putExtra(IntentKeys.ASSOCIATE_STATE, apiResult.getAssociateState());
                    intent.putExtra(IntentKeys.RESULT, apiResult.getResult());
                    startActivity(intent);
                } else {
                    OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                    EventBus.getDefault().post(IntentKeys.GET_HEAD_IMAGE);
                    junpToRN(apiResult);
                }
            }

            @Override
            public void onComplete() {

            }
        });

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
        unregisterReceiver(wxReceiver);
        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C014);
        } else {
            OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C015);
        }
    }


    BroadcastReceiver wxReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals("wechat")) {
                String code = intent.getStringExtra(IntentKeys.ASSOCIATE_STATE);
                requestWxLogin(code, "");
            }
        }
    };


}
