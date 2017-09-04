package com.ocj.oms.mobile.ui.personal.setting;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.text.TextUtils;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.ocj.oms.common.CropCircleTransformation;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.BuildConfig;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.App;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.MemberBean;
import com.ocj.oms.mobile.bean.ResultStr;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.LocaleActivity;
import com.ocj.oms.mobile.ui.MainActivity;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.login.media.MobileReloginActivity;
import com.ocj.oms.mobile.ui.personal.ProfileInfoActivity;
import com.ocj.oms.mobile.ui.personal.adress.ReceiverAddressManagerActivity;
import com.ocj.oms.mobile.ui.personal.advice.AdviceCtiticActivity;
import com.ocj.oms.mobile.ui.reset.ResetPasswordActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.webview.WebViewActivity;
import com.ocj.oms.mobile.utils.ClearUtils;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.system.AppUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import org.greenrobot.eventbus.EventBus;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/17.
 * <p>
 * 设置
 */
@Route(path = RouterModule.AROUTER_PATH_SETTING)
public class SettingActivity extends BaseActivity {
    @BindView(R.id.btn_close) ImageView btnClose;
    @BindView(R.id.iv_head) ImageView ivHead;
    @BindView(R.id.tv_nick_name) TextView nickName;
    @BindView(R.id.tv_setting_username) TextView useName;
    @BindView(R.id.iv_person_info) ImageView ivPersonInfo;
    @BindView(R.id.rl_profile) RelativeLayout rlProfile;
    @BindView(R.id.rl_reset_pwd) RelativeLayout rlResetPwd;
    @BindView(R.id.rl_area_manage) RelativeLayout rlAreaManage;
    @BindView(R.id.rl_adress_set) RelativeLayout rlAdressSet;
    @BindView(R.id.rl_textsize_set) RelativeLayout rlTextsizeSet;
    @BindView(R.id.rl_wechat_gift) RelativeLayout rlWechatGift;
    @BindView(R.id.rl_clear_cache) RelativeLayout rlClearCache;
    @BindView(R.id.rl_touch_mode) RelativeLayout rlTouchMode;
    @BindView(R.id.rl_website) RelativeLayout rlWebsite;
    @BindView(R.id.tv_version) TextView tvVersion;
    @BindView(R.id.rl_version) RelativeLayout rlVersion;
    @BindView(R.id.ll_logout) LinearLayout llLogout;
    @BindView(R.id.tv_cache_size) TextView tvCacheSize;
    @BindView(R.id.switch_default) Switch switch_default;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_setting_layout;
    }


    @Override
    protected void initEventAndData() {
        updateCacheText();
        tvVersion.setText("V" + BuildConfig.VERSION_NAME);
        checkMemberInfo();
        initReceiver();
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C055);
        if(AppUtil.isDebug()){
            rlVersion.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    startActivity(new Intent(mContext, MainActivity.class));
                    return true;
                }
            });
        }
        switch_default.setChecked(OCJPreferencesUtils.getFinger());
        switch_default.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                OCJPreferencesUtils.setFinger(isChecked);
            }
        });
    }


    /**
     * 请求用户个人信息
     */
    private void checkMemberInfo() {

        new AccountMode(mContext).checkMemberInfo(OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<MemberBean>(mContext) {
            @Override
            public void onSuccess(MemberBean apiResult) {
                nickName.setText(apiResult.getCustomerCommon().getCust_name());
                useName.setText("用户名: " + apiResult.getCustomerCommon().getInternet_Id());
                llLogout.setVisibility(View.VISIBLE);
                OCJPreferencesUtils.setCustName(apiResult.getCustomerCommon().getCust_name());
                OCJPreferencesUtils.setInternetId(apiResult.getCustomerCommon().getInternet_Id());
                Glide.with(mContext).load(apiResult.getCustPhoto()).
                        skipMemoryCache(true).
                        diskCacheStrategy(DiskCacheStrategy.NONE).
                        error(R.drawable.icon_user).
                        placeholder(R.drawable.icon_user).
                        bitmapTransform(new CropCircleTransformation(mContext)).
                        into(ivHead);
                OCJPreferencesUtils.setHeadImage(apiResult.getCustPhoto());
            }

            @Override
            public void onError(ApiException e) {
                if (e.getCode() == 4010) {
                    Intent intent = new Intent();
                    if (TextUtils.isEmpty(OCJPreferencesUtils.getLoginId())) {
                        intent.setClass(mContext, LoginActivity.class);
                    } else {
                        intent.setClass(mContext, MobileReloginActivity.class);
                    }
                    startActivity(intent);
                    finish();
                } else {
                    ToastUtils.showLongToast(e.getMessage());
                    llLogout.setVisibility(View.GONE);
                }
            }

        });


    }

    private String CacheSize = "未知";

    @OnClick({R.id.btn_close, R.id.iv_head, R.id.tv_nick_name, R.id.tv_setting_username,
            R.id.iv_person_info, R.id.rl_profile, R.id.rl_reset_pwd, R.id.rl_area_manage,
            R.id.rl_adress_set, R.id.rl_textsize_set, R.id.rl_wechat_gift, R.id.rl_clear_cache,
            R.id.rl_touch_mode, R.id.rl_website, R.id.rl_version, R.id.tv_logout,
            R.id.rl_good_praise, R.id.rl_advice})
    public void onClick(View view) {
        Intent intent = new Intent();
        switch (view.getId()) {
            case R.id.btn_close:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D003001C003001);
                finishActivity();
                break;
            case R.id.iv_head:
                break;
            case R.id.tv_nick_name:
                break;
            case R.id.tv_setting_username:
                break;
            case R.id.iv_person_info:
                break;
            case R.id.rl_profile:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010001C010001);
                intent.setClass(mContext, ProfileInfoActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_reset_pwd:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010002C010001);
                intent.putExtra(IntentKeys.FROM_SETTING, "");
                intent.setClass(mContext, ResetPasswordActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_area_manage:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010003C010001);
                startActivity(new Intent(mContext, ReceiverAddressManagerActivity.class));
                break;
            case R.id.rl_adress_set:
                Intent intent2 = new Intent(mContext, LocaleActivity.class);
                intent2.putExtra(IntentKeys.FROM_SETTING, "");
                startActivity(intent2);
                break;
            case R.id.rl_textsize_set:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010004C010001);
                intent.setClass(mContext, SettingTextSizeActivity.class);
                startActivity(intent);
                break;
            case R.id.rl_wechat_gift:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010005C010001);
                startActivity(new Intent(mContext, WeChatGiftActivity.class));
                break;
            case R.id.rl_clear_cache:
                /**
                 * 清除缓存
                 */
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010006C010001);
                clearCache();
                break;
            case R.id.rl_touch_mode:
                break;
            case R.id.rl_website:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010007C010001);
                Intent intent1 = new Intent(mContext, WebViewActivity.class);
                intent1.putExtra(IntentKeys.URL, "http://mcompany.ocj.com.cn");
                startActivity(intent1);
                break;
            case R.id.rl_version:
//                if (AppUtil.isDebug()) {
//                    startActivity(new Intent(mContext, MainActivity.class));
//                }
                break;
            case R.id.tv_logout:
                DialogFactory.showLeftDialog(mContext, "是否退出登录", "退出登录", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010009C010001);
                        logout();
                    }
                }).show(getFragmentManager(), "login_out");
                break;
            case R.id.rl_good_praise:
                try {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010008C010001);
                    Intent viewIntent = new Intent(Intent.ACTION_VIEW,
                            Uri.parse("market://details?id=com.ocj.oms.mobile"));
                    viewIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    startActivity(viewIntent);
                } catch (Exception e) {
                    Toast.makeText(mContext, "您的手机没有安装Android应用市场", Toast.LENGTH_SHORT).show();
                    e.printStackTrace();
                }
                break;
            case R.id.rl_advice:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C055D010008C010001);
                startActivity(new Intent(mContext, AdviceCtiticActivity.class));
                break;
        }
    }


    private void logout() {
        new AccountMode(mContext).logout(new ApiResultObserver<ResultStr>(mContext) {
            @Override
            public void onSuccess(ResultStr apiResult) {
                OCJPreferencesUtils.setVisitor(true);
                OCJPreferencesUtils.setAccessToken(apiResult.getResult());
                EventBus.getDefault().post("login_out");
                toRNActivity();

            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }
        });


    }

    private void toRNActivity() {
        RouterModule.sendAdviceEvent("refreshToHomePage", false);
        RouterModule.sendRefreshCartEvent("", "");
        finish();
    }

    private void clearCache() {
        showLoading();
        Glide.get(App.getInstance()).clearMemory();
        Thread thread = new Thread() {
            @Override
            public void run() {
                super.run();
                ClearUtils.clearAllCache();
                Glide.get(App.getInstance()).clearDiskCache();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        hideLoading();
                        Toast.makeText(mContext, "清除成功", Toast.LENGTH_SHORT).show();
                        updateCacheText();
                    }
                });
            }
        };
        thread.start();
    }

    private void updateCacheText() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                final String cacheSize = ClearUtils.getTotalCacheString();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tvCacheSize.setText(cacheSize);
                    }
                });
            }
        }).start();
    }


    private void finishActivity() {
        finish();
    }

    private void startMainActivity() {
        ActivityStack.getInstance().finishAllActivity();
        Intent intent = new Intent();
        intent.setClass(mContext, MainActivity.class);
        startActivity(intent);
    }

    @Override
    public void onBackPressed() {
        finishActivity();
    }


    private void initReceiver() {
        IntentFilter recIntent = new IntentFilter();
        recIntent.addAction(IntentKeys.FRESH_SETTING);
        registerReceiver(settingReceiver, recIntent);

    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(settingReceiver);
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C055);
    }

    BroadcastReceiver settingReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            checkMemberInfo();
        }
    };


}
