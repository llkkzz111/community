package com.ocj.oms.mobile.ui.rn;

import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.annotation.CheckResult;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.facebook.react.ReactActivity;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.BuildConfig;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.CheckUpdateBean;
import com.ocj.oms.mobile.bean.MemberBean;
import com.ocj.oms.mobile.bean.SignBean;
import com.ocj.oms.mobile.bean.SignDetailBean;
import com.ocj.oms.mobile.bean.SignPacksBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.dialog.CommonDialogFragment;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.personal.advice.AdviceCtiticActivity;
import com.ocj.oms.mobile.ui.sign.LotteryDialog;
import com.ocj.oms.mobile.ui.sign.SignDialog;
import com.ocj.oms.rn.SplashScreen;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.system.AppUtil;
import com.trello.rxlifecycle2.LifecycleProvider;
import com.trello.rxlifecycle2.LifecycleTransformer;
import com.trello.rxlifecycle2.RxLifecycle;
import com.trello.rxlifecycle2.android.ActivityEvent;
import com.trello.rxlifecycle2.android.RxLifecycleAndroid;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import io.reactivex.Observable;
import io.reactivex.annotations.NonNull;
import io.reactivex.subjects.BehaviorSubject;

import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_WEBVIEW;


public class RNActivity extends ReactActivity implements LifecycleProvider<ActivityEvent> {

    private SignDialog signDialog;
    private LotteryDialog lotteryDialog;
    private ImageView ivSign;
    private ImageView ivAdvice;
    private boolean isSign = true;
    private boolean isFirst = true;
    private final BehaviorSubject<ActivityEvent> lifecycleSubject = BehaviorSubject.create();

    private View view;
    ImageView cacheImg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EventBus.getDefault().register(this);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams
                (RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        params.gravity = Gravity.CENTER | Gravity.RIGHT;
        params.setMargins(DensityUtil.dip2px(RNActivity.this, 0), DensityUtil.dip2px(RNActivity.this, 150), DensityUtil.dip2px(RNActivity.this, 0), DensityUtil.dip2px(RNActivity.this, 0));
        ivSign = new ImageView(this);
        ivSign.setImageResource(R.drawable.icon_rn_sign);
        addContentView(ivSign, params);
        ivSign.setVisibility(View.GONE);

        ivAdvice = new ImageView(this);
        ivAdvice.setImageResource(R.drawable.icon_advice);
        addContentView(ivAdvice, params);
        ivAdvice.setVisibility(View.GONE);
        view = LayoutInflater.from(getBaseContext()).inflate(R.layout.inc_cache_image_layout, null);
        cacheImg = (ImageView) view.findViewById(R.id.iv_cache);
        cacheImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                        .withString("url", OCJPreferencesUtils.getBootAD())
                        .navigation();
                view.setVisibility(View.GONE);
            }
        });
        FrameLayout.LayoutParams cacheParams = new FrameLayout.LayoutParams
                (RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        addContentView(view, cacheParams);
        view.setVisibility(View.GONE);
        view.findViewById(R.id.iv_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                view.setVisibility(View.GONE);
            }
        });
        //checkAdvertImg();
        // getAdvertImgUrl();
        checkUpdate();

        signDialog = new SignDialog(RNActivity.this);
        lotteryDialog = new LotteryDialog(RNActivity.this);
        signDialog.setOnSignButtonClickListener(new SignDialog.OnSignButtonClickListener() {
            @Override
            public void onConfirmClick(int currentPosition) {
                if (currentPosition == 15) {
                    lotteryDialog.show();
                    signDialog.dismiss();
                } else if (currentPosition == 20) {
                    signGetPacks();
                }
            }

            @Override
            public void onCancelClick() {
                signDialog.dismiss();
                Toast.makeText(RNActivity.this, "您可前往个人中心继续\n领取查看签到礼包哟〜", Toast.LENGTH_SHORT).show();
            }
        });
        signDialog.setOnKeyListener(new DialogInterface.OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                return keyCode == KeyEvent.KEYCODE_BACK;
            }
        });
        lotteryDialog.setOnLotteryButtonClickListener(new LotteryDialog.OnLotteryButtonClickListener() {
            @Override
            public void onConfirmClick(String name, String id, String phone) {
                signGetLottery(name, id, phone);
            }

            @Override
            public void onCancelClick() {
                lotteryDialog.dismiss();
            }
        });

        ivSign.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sign();
            }
        });
        ivAdvice.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent;
                intent = new Intent(RNActivity.this, AdviceCtiticActivity.class);
                startActivity(intent);
            }
        });
        getSignDetail();
        //加载过度loading
        ActivityStack.getInstance().add(this);
        SplashScreen.show(this);

    }


    private void getSignDetail() {
        new AccountMode(RNActivity.this).signDetail(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignDetailBean>>(RNActivity.this) {
            @Override
            public void onError(ApiException e) {
                isSign = true;
            }

            @Override
            public void onNext(ApiResult<SignDetailBean> signDetailBeanApiResult) {
                SignDetailBean signDetailBean = signDetailBeanApiResult.getData();
                if (equalsTwo(signDetailBean.getSignYn(), "todayy")) {
                    if (isFirst) {
                        ivSign.setVisibility(View.GONE);
                    }
                    isSign = true;
                } else if (equalsTwo(signDetailBean.getSignYn(), "todayn")) {
                    if (isFirst) {
                        ivSign.setVisibility(View.VISIBLE);
                    }
                    isSign = false;
                }
            }
        });
    }

    private void signGetLottery(String name, String id, String phone) {
        new AccountMode(this).signGetLottery(name, phone, id, OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<String>(this) {
            @Override
            public void onSuccess(String apiResult) {
                Toast.makeText(RNActivity.this, getString(R.string.sign_string), Toast.LENGTH_SHORT).show();
                lotteryDialog.dismiss();
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }

    private void signGetPacks() {
        new AccountMode(RNActivity.this).signGetPacks(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignPacksBean>>(RNActivity.this) {
            @Override
            public void onError(ApiException e) {

                Toast.makeText(RNActivity.this, e.getMessage(), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onNext(ApiResult<SignPacksBean> resultApiResult) {
                if (signDialog.isShowing()) {
                    signDialog.dismiss();
                }
            }
        });
    }

    private void sign() {
        new AccountMode(RNActivity.this).sign(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignBean>>(RNActivity.this) {
            @Override
            public void onError(ApiException e) {
                if (equalsTwo(e.getCode() + "", "4010")) {
                    Intent intent;
                    intent = new Intent(RNActivity.this, LoginActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(RNActivity.this, e.getMessage(), Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onNext(ApiResult<SignBean> signBeanApiResult) {
                signDialog.setCurrentPosition(signBeanApiResult.getData().getDays());
                ivSign.setVisibility(View.GONE);
                isSign = true;
                signDialog.show();
            }
        });
    }


    private void checkUpdate() {
        new AccountMode(this).checkUpdate("ANDROID", BuildConfig.VERSION_NAME, new ApiResultObserver<CheckUpdateBean>(this) {
            @Override
            public void onSuccess(CheckUpdateBean apiResult) {
                final CheckUpdateBean bean = apiResult;
                OCJPreferencesUtils.setOpenTimes(OCJPreferencesUtils.getOpenTimes() + 1);
                if (!equalsTwo(bean.getUpdate_yn(), "0")) {
                    showUpdateDialog(bean);
                } else if (equalsTwo(bean.getPrompt_comment_app(), "Y")) {
                    if (!OCJPreferencesUtils.getFeelGoodState() && OCJPreferencesUtils.getlookAround() <= 3 && OCJPreferencesUtils.getOpenTimes() == 8) {

                    }
                }

            }

            @Override
            public void onError(ApiException e) {

            }
        });
    }

    private void showUpdateDialog(final CheckUpdateBean bean) {
        final CommonDialogFragment updateDialog = CommonDialogFragment.newInstance(R.layout.dialog_update_layout);
        updateDialog.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                View update = updateDialog.getViewByRootViewId(R.id.tv_confirm);
                View cancle = updateDialog.getViewByRootViewId(R.id.tv_cancel);
                if (TextUtils.equals(bean.getUpdate_yn(), "1")) {
                    cancle.setVisibility(View.GONE);
                }
                TextView updateContent = (TextView) updateDialog.getViewByRootViewId(R.id.tv_update_content);
                if (AppUtil.isDebug()) {
                    updateDialog.getViewByRootViewId(R.id.iv_find).setOnLongClickListener(new View.OnLongClickListener() {
                        @Override
                        public boolean onLongClick(View v) {
                            updateDialog.dismiss();
                            return true;
                        }
                    });
                }
                cancle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        updateDialog.dismiss();
                    }
                });
                updateContent.setText(bean.getApp_ver_tip());
                update.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (equalsTwo(bean.getApp_ver_target(), "MARKET")) {
                            try {
                                Intent viewIntent = new Intent(Intent.ACTION_VIEW,
                                        Uri.parse("market://details?id=com.ocj.oms.mobile"));
                                viewIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(viewIntent);
                            } catch (Exception e) {
                                ToastUtils.showShortToast("您的手机没有安装Android应用市场");
                                e.printStackTrace();
                            }
                        } else if (equalsTwo(bean.getApp_ver_target(), "HTML5")) {
                            Intent intent = new Intent();
                            intent.setAction("android.intent.action.VIEW");
                            Uri content_url = Uri.parse(bean.getApp_ver_url());
                            intent.setData(content_url);
                            startActivity(intent);
                        }
                    }
                });
                updateDialog.getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
                    @Override
                    public boolean onKey(DialogInterface dialogInterface, int keyCode, KeyEvent keyEvent) {
                        return keyCode == KeyEvent.KEYCODE_BACK;
                    }
                });
            }
        });
        updateDialog.show(getFragmentManager(), "update");
    }

    /**
     * 请求用户个人信息
     */
    private void checkMemberInfo() {

        new AccountMode(RNActivity.this).checkMemberInfo(OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<MemberBean>(RNActivity.this) {
            @Override
            public void onSuccess(MemberBean apiResult) {
                OCJPreferencesUtils.setHeadImage(apiResult.getCustPhoto());
            }

            @Override
            public void onError(ApiException e) {
            }

        });


    }


    @Subscribe
    public void onEvent(String event) {
        switch (event) {
            case "login_success":
                getSignDetail();
                isFirst = false;
                break;
            case "login_out":
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ivSign.setVisibility(View.GONE);
                        ivAdvice.setVisibility(View.GONE);
                        isSign = true;
                    }
                });

                break;
            case "home_true":
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ivAdvice.setVisibility(View.GONE);
                        if (isSign) {
                            ivSign.setVisibility(View.GONE);
                        } else {
                            ivSign.setVisibility(View.VISIBLE);
                        }
                    }
                });
                break;
            case "home_false":
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ivAdvice.setVisibility(View.GONE);
                        ivSign.setVisibility(View.GONE);
                    }
                });

                break;
            case IntentKeys.SIGN_SUCCESS:
                ivSign.setVisibility(View.GONE);
                isSign = true;
                break;
            case IntentKeys.GET_HEAD_IMAGE:
                checkMemberInfo();
                break;
        }
    }


    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "OCJ_RN_APP";
    }

    @Override
    @NonNull
    @CheckResult
    public final Observable<ActivityEvent> lifecycle() {
        return lifecycleSubject.hide();
    }

    @Override
    @NonNull
    @CheckResult
    public final <T> LifecycleTransformer<T> bindUntilEvent(@NonNull ActivityEvent event) {
        return RxLifecycle.bindUntilEvent(lifecycleSubject, event);
    }

    @Override
    @NonNull
    @CheckResult
    public final <T> LifecycleTransformer<T> bindToLifecycle() {
        return RxLifecycleAndroid.bindActivity(lifecycleSubject);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ActivityStack.getInstance().remove(this);
        EventBus.getDefault().unregister(this);
    }


    private void getAdvertImgUrl() {
        new ItemsMode(RNActivity.this).getGuidePageAdvert(new ApiResultObserver<CmsContentBean>(RNActivity.this) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(CmsContentBean apiResult) {
                if (apiResult.getPackageList() == null || apiResult.getPackageList().get(0) == null || apiResult.getPackageList().get(0).getComponentList() == null
                        || TextUtils.isEmpty(apiResult.getPackageList().get(0).getComponentList().get(0).getFirstImgUrl())) {
                } else if (!TextUtils.isEmpty(apiResult.getPackageList().get(0).getComponentList().get(0).getFirstImgUrl())) {
                    String imgUrl = apiResult.getPackageList().get(0).getComponentList().get(0).getFirstImgUrl();
                    OCJPreferencesUtils.setBootAD(apiResult.getPackageList().get(0).getComponentList().get(0).getDestinationUrl());
                    if (TextUtils.equals(OCJPreferencesUtils.getGuideAdvertImg(), imgUrl) && !TextUtils.isEmpty(OCJPreferencesUtils.getBootAD())) {
                        showAdvert(imgUrl);
                    } else {
                        cacheUrl(imgUrl);//去缓存
                    }
                }
            }
        });
    }


    /**
     * 展示广告页
     *
     * @param imgUrl
     */
    private void showAdvert(String imgUrl) {
        Glide.with(RNActivity.this).load(imgUrl).
                skipMemoryCache(true).centerCrop().
                diskCacheStrategy(DiskCacheStrategy.SOURCE).
                into(cacheImg);//缓存
        OCJPreferencesUtils.setGuideAdvertImage(imgUrl);
        view.setVisibility(View.VISIBLE);
        new CountDownTimer(3000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                Log.d("amtf", "倒计时" + millisUntilFinished / 1000 + "秒");
            }

            @Override
            public void onFinish() {
                view.setVisibility(View.GONE);
            }
        }.start();


    }


    private void cacheUrl(String url) {
        Glide.with(RNActivity.this).load(url).
                skipMemoryCache(true).centerCrop().
                diskCacheStrategy(DiskCacheStrategy.SOURCE).
                into(cacheImg);//缓存
        OCJPreferencesUtils.setGuideAdvertImage(url);
    }

    public boolean equalsTwo(String a, String b) {
        if (a == null || b == null) {
            return false;
        }
        return a.equalsIgnoreCase(b);
    }

}
