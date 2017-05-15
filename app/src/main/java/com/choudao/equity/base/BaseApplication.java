package com.choudao.equity.base;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import com.choudao.equity.BuildConfig;
import com.choudao.equity.R;
import com.choudao.equity.service.IMService;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.FileUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.TimeUtils;
import com.choudao.equity.utils.UIManager;
import com.choudao.equity.utils.Utils;
import com.choudao.imsdk.IMApplication;
import com.choudao.imsdk.utils.ApiUtils;
import com.choudao.imsdk.utils.Logger;
import com.facebook.stetho.Stetho;
import com.mcxiaoke.packer.helper.PackerNg;
import com.umeng.analytics.AnalyticsConfig;

import java.util.Date;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

/**
 * Created by Han on 2016/3/11.
 */
public class BaseApplication extends IMApplication implements Logger.LoggerListener {

    public static boolean isMsgActivityShow = false;



    public ApplicationComponent applicationComponent;

    @Override
    public void onCreate() {
        super.onCreate();

        UIManager.getInstance().setBaseContext(getBaseContext());
        ConstantUtils.USER_ID = PreferencesUtils.getUserId();
        initJpush();
        Logger.loggerListener = this;
        Logger.isDebug = BuildConfig.LOG_DEBUG;
        userId = PreferencesUtils.getUserId();
        serverAddress = BuildConfig.SOCKET_IP;
        serverPort = BuildConfig.SOCKET_PORT;
        phoneMark = Utils.getEquipId();
        appVersion = Utils.getVersion(this);

        applicationComponent = DaggerApplicationComponent.builder().applicationModule(new ApplicationModule(this)).build();
        //获取登陆状态
        ConstantUtils.isLogin = PreferencesUtils.getLoginState();
        ApiUtils.BASE_HTTP_URL = ConstantUtils.BASE_HTTP_URL;
        getDeviceInfo();

        initIMService();
        initUmeng();
        initStetho();
    }
    public ApplicationComponent getApplicationComponent() {
        return applicationComponent;
    }

    private void initIMService() {
        Logger.e("===BaseApplication===", "isServiceRun = " + Utils.isServiceRun(this, IMService.class));
//        token = PreferencesUtils.getAccessToken(getBaseContext());
        if (!Utils.isServiceRun(this, IMService.class)) {
            Intent intent = new Intent(this, IMService.class);
            startService(intent);
        }
    }

    private void initJpush() {
        JPushInterface.init(this);   // 初始化 JPush
        JPushInterface.setDebugMode(BuildConfig.DEBUG);    // 设置开启日志,发布时请关闭日志
        JPushInterface.setAlias(this, ConstantUtils.getEnvironmentType(this) + ConstantUtils.USER_ID, null);

        BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(this);
        builder.statusBarDrawable = R.drawable.ic_small_icon;
        JPushInterface.setPushNotificationBuilder(1, builder);
    }

    private void initUmeng() {
        AnalyticsConfig.setChannel(PackerNg.getMarket(context));
        AnalyticsConfig.setAppkey(BuildConfig.UMENG_APPID);
    }


    public void getDeviceInfo() {
        ApiUtils.USER_AGENT = "Choudao/" + BuildConfig.VERSION_NAME + " Android; " + Build.VERSION.RELEASE + " " + Build.MODEL;

        DisplayMetrics dm = new DisplayMetrics();
        WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(dm);

        // 竖屏
        ConstantUtils.SCREEN_WIDTH = dm.widthPixels;
        ConstantUtils.SCREEN_HEIGHT = dm.heightPixels;

        ConstantUtils.DENSITYDPI = dm.densityDpi;
        ConstantUtils.DENSITY = dm.density;
    }

    /**
     * 添加网络请求监测
     */
    private void initStetho() {
        Stetho.initialize(
                Stetho.newInitializerBuilder(this)
                        .enableDumpapp(
                                Stetho.defaultDumperPluginsProvider(this))
                        .enableWebKitInspector(
                                Stetho.defaultInspectorModulesProvider(this))
                        .build());
    }

    @Override
    public void writeLog(String msg) {
        String exceptionLogFilePath = FileUtils.CACHE_IM_LOG_PATH + "im_" + TimeUtils.formatDateByFormat(new Date(), "yyyy-MM-dd") + "_log.log";
        FileUtils.writeFile(exceptionLogFilePath, msg, true);
    }

}
