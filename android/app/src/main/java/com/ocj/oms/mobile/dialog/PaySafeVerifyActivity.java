package com.ocj.oms.mobile.dialog;


import android.content.Intent;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.reset.ResetCheckActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.utils.PermissionUtils;
import com.ocj.oms.mobile.view.SlideLockView;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.PreferencesUtils;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

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


/**
 * Created by yy on 2017/5/8.
 * 支付安全校验 pop
 */

public class PaySafeVerifyActivity extends BaseActivity {


    @BindView(R.id.tv_name_welcome) TextView tvCustName;
    @BindView(R.id.ll_code_verify) LinearLayout codeVerify;
    @BindView(R.id.ll_pwd_verify) LinearLayout pwdVerify;

    @BindView(R.id.et_code) ClearEditText inputCode;
    @BindView(R.id.et_password) ClearEditText inputPwd;

    @BindView(R.id.tv_swich) TextView verifySwitch;
    //滑动解锁
    @BindView(R.id.ll_slide) LinearLayout llSlide;
    @BindView(R.id.slide) SlideLockView slideLockView;

    @BindView(R.id.tv_send_code) TextView tvCode;
    @BindView(R.id.iv_pwd_state) ImageView eyeState;

    @BindView(R.id.verify_btn) Button btnConfirm;

    @BindView(R.id.btn_forget) TextView btnFroget;//忘记密码按钮


    boolean isPwd = true;//是否是密码验证

    String loginId = "";
    int errorTime = 1;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_pay_saveverify_layout;
    }


    @Override
    protected void initEventAndData() {
        loginId = OCJPreferencesUtils.getLoginId();
        verifySwitch.setTag(isPwd);
        codeVerify.setVisibility(View.GONE);
        pwdVerify.setVisibility(View.VISIBLE);
        verifySwitch.setText("使用验证码校验");

        tvCustName.setText("当前用户 " + createName(OCJPreferencesUtils.getCustName()));
        initView();
    }


    @OnClick({R.id.iv_left_close, R.id.tv_swich,R.id.btn_forget})
    public void onButtonClick(View view) {
        int id = view.getId();
        switch (id) {
            case R.id.iv_left_close:
                finishAnimte();
                break;

            case R.id.tv_swich:
                isPwd = (boolean) verifySwitch.getTag();
                isPwd = !isPwd;
                verifySwitch.setTag(isPwd);
                swicthView(isPwd);
                break;
            case R.id.btn_forget:
                //忘记密码
                Intent intent = new Intent();
                intent.putExtra(IntentKeys.LOGIN_ID,loginId);
                intent.putExtra(IntentKeys.LOGIN_TYPE, OCJPreferencesUtils.getLoginType());
                intent.setClass(mContext, ResetCheckActivity.class);
                startActivity(intent);
                break;
        }


    }


    private void initView() {
        slideLockView.setOnLockVerifyLister(new SlideLockView.OnLockVerify() {
            @Override
            public void onVerfifySucced() {
                btnConfirm.setEnabled(true);
                slideLockView.setStopAnim(false);
                llSlide.setVisibility(View.GONE);
                errorTime = 1;
            }

            @Override
            public void onVerifyFail() {
                btnConfirm.setEnabled(false);
            }
        });
    }


    private void swicthView(boolean check) {
        if (check) {
            codeVerify.setVisibility(View.GONE);
            pwdVerify.setVisibility(View.VISIBLE);
            verifySwitch.setText("使用验证码校验");
            btnFroget.setVisibility(View.VISIBLE);
        } else {
            codeVerify.setVisibility(View.VISIBLE);
            pwdVerify.setVisibility(View.GONE);
            verifySwitch.setText("使用登录密码校验");
            btnFroget.setVisibility(View.GONE);
        }
    }


    @OnClick({R.id.tv_send_code})
    public void onCodeClick(View view) {
        String loginType = OCJPreferencesUtils.getLoginType();
        if (!loginType.equals("3")) {
            ToastUtils.showLongToast("你不是手机用户，无法发送验证码");
            return;
        }
        sendMobileCode();
    }

    @OnClick({R.id.verify_btn})
    public void onClick(View view) {
        // TODO 暂时做再次登录的逻辑
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C005F008001O008001);
        if (!isPwd) {
            if (TextUtils.isEmpty(inputCode.getText())) {
                ToastUtils.showLongToast("输入验证码不能为空!");
                return;
            }
            loginByMobile(inputCode.getText().toString().trim());

        } else {
            if (TextUtils.isEmpty(inputPwd.getText())) {
                ToastUtils.showLongToast("密码输入不能为空!");
                return;
            }
            loginByPwd(inputPwd.getText().toString().trim());
        }


    }


    @OnClick(R.id.view_dismiss)
    public void onClick() {
        finishAnimte();
    }

    private void finishAnimte() {
        finish();
        overridePendingTransition(R.anim.push_bottom_in, R.anim.push_bottom_out);
    }

    @Override
    public void onBackPressed() {
        finishAnimte();
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
                        tvCode.setEnabled(false);
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
                            tvCode.setText("获取验证码");
                            tvCode.setTextColor(getResources().getColor(R.color.text_red_E5290D));
                            tvCode.setBackgroundResource(R.drawable.btn_verify_code);

                        } else {
                            tvCode.setText(String.format("%s 重新发送", aLong + ""));
                            tvCode.setTextColor(getResources().getColor(R.color.text_grey_666));
                            tvCode.setBackgroundResource(R.drawable.btn_timer_resent_code);
                        }
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {
                        tvCode.setEnabled(true);
                    }
                });
    }


    //控制密码明文还是隐藏
    @OnClick(R.id.iv_pwd_state)
    public void onEyeClick() {
        if (inputPwd.getTransformationMethod() == HideReturnsTransformationMethod.getInstance()) {//隐藏密码
            inputPwd.setTransformationMethod(PasswordTransformationMethod.getInstance());
            eyeState.setSelected(false);
        } else {//显示密码
            inputPwd.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
            eyeState.setSelected(true);
        }
        if (inputPwd.hasFocus()) {
            inputPwd.setSelection(inputPwd.getText().length());
        }

    }

    /**
     * 手机号码登录
     *
     * @param mobile *
     */
    private void loginByMobile(String mobile) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_MOBILE_LOGIN);
        params.put(ParamKeys.MOBILE, loginId);
        params.put(ParamKeys.VERIFY_CODE, mobile);
        new AccountMode(mContext).smsLogin(params, new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onSuccess(UserInfo apiResult) {
                saveInfo(apiResult);

            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());

            }
        });
    }


    /**
     * 密码登录
     */
    private void loginByPwd(String pwd) {
        checkErrorTime();
        if (llSlide.getVisibility() == View.VISIBLE) {
            return;
        }

        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.LOGIN_ID, loginId);
        params.put(ParamKeys.PASSWORD, pwd);
        new AccountMode(mContext).passwordLogin(params, new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                errorTime++;

            }

            @Override
            public void onSuccess(UserInfo apiResult) {
                errorTime = 1;
                saveInfo(apiResult);
            }
        });


    }

    /**
     * 检查密码错误次数
     */
    private void checkErrorTime() {
        if (errorTime >= 3) {
            llSlide.setVisibility(View.VISIBLE);
            slideLockView.reset();
            btnConfirm.setEnabled(false);
        }

    }


    private void saveInfo(UserInfo result) {
        OCJPreferencesUtils.setAccessToken(result.getAccessToken());
        OCJPreferencesUtils.setCustName(result.getCust_name());
        OCJPreferencesUtils.setCustNo(result.getCust_no());
        OCJPreferencesUtils.setVisitor(false);
        RouterModule.sendAdviceEvent("refreshToken", true);
        // RouterModule.sendRefreshCartEvent("", "");
        setResult(RESULT_OK);
        finish();
        // EventBus.getDefault().post("login_success");
    }


    private String createName(String s) {
        if (s.length() < 2) {
            return s;
        }
        StringBuilder builder = new StringBuilder();
        String firstName = s.substring(0, 1);
        builder.append(firstName);
        for (int i = 0; i < s.length() - 1; i++) {
            builder.append("*");
        }
        return builder.toString();
    }


    public void sendMobileCode() {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, OCJPreferencesUtils.getLoginId());
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_QUICK_REGISTER);
        new AccountMode(mContext).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                if (null == result || result.getCode() != 200) {
                    ToastUtils.showLongToast("验证码发送失败！");
                    return;
                }
                ToastUtils.showLongToast("验证码发送成功");
                countDown();

            }

            @Override
            public void onComplete() {

            }
        });


    }


}
