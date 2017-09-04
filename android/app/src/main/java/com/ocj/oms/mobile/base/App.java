package com.ocj.oms.mobile.base;

import android.content.Context;
import android.os.StrictMode;
import android.support.multidex.MultiDex;

import com.alibaba.android.arouter.launcher.ARouter;
import com.blankj.utilcode.utils.Utils;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.modules.network.OkHttpClientProvider;
import com.facebook.react.modules.network.ReactCookieJarContainer;
import com.facebook.soloader.SoLoader;
import com.facebook.stetho.okhttp3.StethoInterceptor;
import com.jz.jizhalivesdk.JiZhaAPP;
import com.learnium.RNDeviceInfo.RNDeviceInfo;
import com.mcxiaoke.packer.helper.PackerNg;
import com.oblador.vectoricons.VectorIconsPackage;
import com.ocj.oms.basekit.BaseApplication;
import com.ocj.oms.common.net.mode.ApiHost;
import com.ocj.oms.mobile.BuildConfig;
import com.ocj.oms.mobile.ui.rn.AndroidModulePackage;
import com.ocj.oms.utils.Installation;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.UIManager;
import com.ocj.oms.utils.system.AppUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;
import com.reactnativecomponent.splashscreen.RCTSplashScreenPackage;
import com.reactnativecomponent.swiperefreshlayout.RCTSwipeRefreshLayoutPackage;
import com.squareup.leakcanary.LeakCanary;
import com.umeng.analytics.MobclickAgent;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import cn.jpush.android.api.JPushInterface;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;

import static com.ocj.oms.utils.system.AppUtil.isDebug;

/**
 * Created by Pactera on 2017/3/28.
 */

public class App extends BaseApplication implements ReactApplication {

    static App instance = null;

    public static synchronized App getInstance() {
        if (instance == null) {
            new Throwable("Application is not initialization ");
        }
        return instance;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(base);
    }


    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        OcjStoreDataAnalytics.init(this, OcjStoreDataAnalytics.DataAnalyticsTalkingdata | OcjStoreDataAnalytics.DataAnalyticsOcj, PackerNg.getMarket(getBaseContext()));
        initArouter();
//        CrashHandlerUtil.getInstance().init(getBaseContext());
        if (LeakCanary.isInAnalyzerProcess(this)) {
            // This process is dedicated to LeakCanary for heap analysis.
            // You should not init your app in this process.
            return;
        }
        initHost();
//        enabledStrictMode();
        Utils.init(this);
        if (AppUtil.isDebug()) {
            LeakCanary.install(this);
        }

        UIManager.getInstance().setBaseContext(getApplicationContext());
        //RN相关
        SoLoader.init(this, /* native exopackage */ false);
        //RN OKHTTP添加https证书
        OkHttpClientProvider.replaceOkHttpClient(initCustomOkHttpClient());
        initJpush();
        initUmeng();
        initJzVideo();
    }

    private void initJzVideo() {
        //设置 appkey 和 secret
        JiZhaAPP.setJiZhaAPP("jz2017018690", "2b9e22c07b8609ce5c103b605ed47e2f7ecd49616ac09b67b6876de8a0620337", instance);
        String UUID = Installation.id(this);//获取手机唯一标识
        JiZhaAPP.setUUID(UUID);
        JiZhaAPP.setALiPlayer(instance);//设置播放器
        JiZhaAPP.setGiftList();//获取礼物列表
    }

    //初始化接口相关
    private void initHost() {
        ApiHost.API_HOST = BuildConfig.ApiUrl;
        ApiHost.H5_HOST = BuildConfig.H5Url;
    }

    private void initUmeng() {
        MobclickAgent.startWithConfigure(new MobclickAgent.UMAnalyticsConfig(getBaseContext(), "5153f9d456240bcd14001158", PackerNg.getMarket(getBaseContext())));
    }

    private void initJpush() {
        JPushInterface.setDebugMode(isDebug());    // 设置开启日志,发布时请关闭日志
        JPushInterface.init(this);            // 初始化 JPush

        OCJPreferencesUtils.setJpushCode(JPushInterface.getRegistrationID(getBaseContext()));
    }

    private void initArouter() {
        if (isDebug()) {
            ARouter.openLog();     // 打印日志
            ARouter.openDebug();   // 开启调试模式(如果在InstantRun模式下运行，必须开启调试模式！线上版本需要关闭,否则有安全风险)
        }
        ARouter.init(this); // 尽可能早，推荐在Application中初始化
    }

    /**
     * 开启严格模式
     */
    private static void enabledStrictMode() {
        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder() //
                .detectAll() //
                .penaltyLog() //在Logcat 中打印违规异常信息
//                .penaltyDeath() //
                .build());
    }


    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        public boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new VectorIconsPackage(),
                    new RCTSplashScreenPackage(),
                    new RNDeviceInfo(),
                    new AndroidModulePackage(),
                    new RCTSwipeRefreshLayoutPackage()
            );
        }
    };


    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    public OkHttpClient initCustomOkHttpClient() {
        OkHttpClient.Builder client = new OkHttpClient.Builder()
                .connectTimeout(30 * 1000, TimeUnit.MILLISECONDS)
                .readTimeout(30 * 1000, TimeUnit.MILLISECONDS)
                .writeTimeout(30 * 1000, TimeUnit.MILLISECONDS)
                .cookieJar(new ReactCookieJarContainer());
        client.addNetworkInterceptor(new StethoInterceptor());
        client.addInterceptor(new HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY));
        OkHttpClient.Builder builder = OkHttpClientProvider.enableTls12OnPreLollipop(client);
        return builder.build();
    }

}
