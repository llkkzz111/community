package com.ocj.oms.basekit;

import android.app.Application;

import com.facebook.stetho.Stetho;
import com.ocj.oms.utils.system.AppUtil;
import com.orhanobut.logger.LogLevel;
import com.orhanobut.logger.Logger;


/**
 * Created by Pactera on 2017/3/30.
 */


public class BaseApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        AppUtil.sycIsDebug(getApplicationContext());
        initLog();
        initStetho();
    }
    
    private void initLog() {
        if (AppUtil.isDebug()) {
            Logger.init()
                    .logLevel(LogLevel.FULL);//测试阶段设置日志输出
        } else {
            Logger.init()
                    .logLevel(LogLevel.NONE);//产品上线设置日志不输出
        }
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


}
