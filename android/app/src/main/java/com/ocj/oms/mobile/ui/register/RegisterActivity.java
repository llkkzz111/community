package com.ocj.oms.mobile.ui.register;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.view.CallTextView;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import org.greenrobot.eventbus.EventBus;

import java.util.concurrent.TimeUnit;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;

/**
 * 快速注册页
 */
public class RegisterActivity extends BaseActivity<String, RigesterContract.View, RegisterPresenter> implements RigesterContract.View {

    @BindView(R.id.timmer_get_code) TextView btnGetCode;
    @BindView(R.id.btn_pwd_hide) ImageView btnHidePwd;
    @BindView(R.id.et_verify_code) ClearEditText etVerifyCode;
    @BindView(R.id.et_register_pwd) ClearEditText etRigsterPwd;
    @BindView(R.id.btn_right_login) TextView btnTitleRightAction;
    @BindView(R.id.btn_rapid_register) Button btnRigester;
    @BindView(R.id.slid_lockview) SlideLockView lockView;
    @BindView(R.id.ll_slid_lockview) LinearLayout lockViewLayout;//验证显示隐藏
    @BindView(R.id.tv_agreement) TextView tvAgreement;//协议

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    private String mobile = "";
    RegisterPresenter presenter;

    boolean isSafeVerify = true;//是否已通过安全认证
    private String thirdPartyID;
    @BindView(R.id.tv_problems) CallTextView callTextView;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_register_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C011);
        initView();
        presenter = new RegisterPresenter(mContext, RegisterActivity.this);
        mobile = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        //普通注册
        btnTitleRightAction.setText("登录");
        callTextView.setTraceEvent(EventId.AP1706C011F010001A001001);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C011);
    }

    /**
     * 初始化布局文件
     */
    private void initView() {
        btnRigester.setEnabled(false);

        if (getIntent().hasExtra(IntentKeys.ASSOCIATE_STATE)) {
            btnTitleRightAction.setVisibility(View.GONE);
            thirdPartyID = getIntent().getStringExtra(IntentKeys.ASSOCIATE_STATE);
        } else {
            btnTitleRightAction.setVisibility(View.GONE);
        }

        lockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                isSafeVerify = true;
                if (lockView.isAnim()) {
                    if (!TextUtils.isEmpty(etVerifyCode.getText()) && !TextUtils.isEmpty(etRigsterPwd.getText())) {
                        btnRigester.setEnabled(true);
                    }
                    lockView.setStopAnim(false);
                }
                lockViewLayout.setVisibility(View.GONE);
            }

            @Override
            public void onVerifyFail() {
                isSafeVerify = false;
                btnRigester.setEnabled(false);
            }
        });


    }

    @OnTextChanged(value = R.id.et_verify_code, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onCheckText(CharSequence text) {
        checkState();
    }


    @OnTextChanged(value = R.id.et_register_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onWatchText(CharSequence text) {
        checkState();
    }

    private void checkState() {
        String verifyCode = etVerifyCode.getText().toString().trim();
        String password = etRigsterPwd.getText().toString().trim();
        if (TextUtils.isEmpty(verifyCode) || TextUtils.isEmpty(password) || password.length() < 6) {
            btnRigester.setEnabled(false);
        } else {
            btnRigester.setEnabled(true);
        }

    }


    @OnClick({R.id.btn_rapid_register})
    public void onButtonClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C011F008002O008001);
        String verifyCode = etVerifyCode.getText().toString();
        String loginPwd = etRigsterPwd.getText().toString();
        if (TextUtils.isEmpty(verifyCode)) {
            ToastUtils.showLongToast("请输入验证码");
            return;
        }
        if (TextUtils.isEmpty(loginPwd)) {
            ToastUtils.showLongToast("请输入登录密码");
            return;
        }
        if (verifyCode.length() != 6) {
            ToastUtils.showLongToast("验证码长度为6");
            return;
        }

        if (loginPwd.length() < 6) {
            ToastUtils.showLongToast("密码最小长度为6");
            return;
        }
        if (mobile.equals(loginPwd)) {
            ToastUtils.showLongToast("账号和密码不能相同！");
            return;
        }

        //TODO 分支判断是否是第三方登录带过来的

        presenter.rigsterCommit(thirdPartyID, mobile, verifyCode, loginPwd);
    }


    @OnClick({R.id.btn_right_login, R.id.btn_close, R.id.tv_agreement})
    public void onClick(View view) {
        Intent intent = new Intent();
        switch (view.getId()) {
            case R.id.btn_right_login:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C011C005001A001001);
                intent.setClass(mContext, LoginActivity.class);
                intent.putExtra(IntentKeys.LOGIN_ID, mobile);
                startActivity(new Intent(intent));
                break;
            case R.id.tv_agreement:
                RouterModule.globalToWebView("http://m.ocj.com.cn/staticPage/shop/m/register_service.jsp");
                break;
            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C011C005001C003001);
                finish();
                break;
            default:
                break;
        }
    }

    @OnClick({R.id.timmer_get_code})
    public void onTextClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C011F008001O008001);
        presenter.sendMobileCode(mobile, ApiService.SMS_PURPOSE_QUICK_REGISTER);
    }

    @OnClick({R.id.btn_pwd_hide})
    void onEyeClick(View v) {
        if (etRigsterPwd.getTransformationMethod() == HideReturnsTransformationMethod.getInstance()) {//隐藏密码
            etRigsterPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
            btnHidePwd.setSelected(false);
            etRigsterPwd.setSelection(etRigsterPwd.getText().length());
        } else {//显示密码
            etRigsterPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
            btnHidePwd.setSelected(true);
            etRigsterPwd.setSelection(etRigsterPwd.getText().length());
        }
    }


    @Override
    public void fail(String msg) {
        ToastUtils.showLongToast(msg);
    }

    @Override
    public void succed(UserInfo userInfo) {
        ToastUtils.showLongToast("注册成功!");
        OCJPreferencesUtils.setAccessToken(userInfo.getAccessToken());
        OCJPreferencesUtils.setVisitor(false);
        EventBus.getDefault().post("login_success");
        if ("WebView".equals(getIntent().getStringExtra("fromPage"))) {
            RouterModule.invokeTokenCallback(null, userInfo.getAccessToken(), "self", false);
        } else {
            RouterModule.invokeTokenCallback(null, userInfo.getAccessToken(), "self", false);
            RouterModule.sendAdviceEvent("refreshMePage", false);
            RouterModule.sendRefreshCartEvent("", "");
        }


    }

    @Override
    public void showErrorMsg(String msg) {
        ToastUtils.showLongToast(msg);
    }

    @Override
    public void showOverLimitTimes() {

//        isSafeVerify = false;
//        lockViewLayout.setVisibility(View.VISIBLE);
//        btnRigester.setEnabled(false);
    }


    @Override
    public void showTimmer(String verifyCode) {
        //btnGetCode.start();
        countDown();
//        etVerifyCode.setText(verifyCode);
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
                        btnGetCode.setEnabled(false);
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
                            btnGetCode.setText("获取验证码");
                            btnGetCode.setTextColor(getResources().getColor(R.color.text_red_E5290D));
                            btnGetCode.setBackgroundResource(R.drawable.btn_verify_code);

                        } else {
                            btnGetCode.setText(String.format("%s 重新发送", aLong + ""));
                            btnGetCode.setTextColor(getResources().getColor(R.color.text_grey_666));
                            btnGetCode.setBackgroundResource(R.drawable.btn_timer_resent_code);
                        }
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {
                        btnGetCode.setEnabled(true);
                    }
                });
    }


}
