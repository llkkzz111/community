package com.choudao.imsdk;

import android.app.Application;
import android.content.Context;

/**
 * Created by dufeng on 16-4-22.<br/>
 * Description: IMApplication
 */
public class IMApplication extends Application {

    public static Context context;

    public static long userId = -1;
    public static String token = "";
    public static String appVersion = "";

    public static long nowChatId = -1;
    public static int nowSessionType = -1;
    public static boolean isCanConnect = false;
    /**
     * 快速重新连接的时候需要
     */
    public static String serverAddress = "123.59.128.198";//"123.59.128.198";//10.241.60.53
    public static int serverPort = 9999;//9999//39999
    public static String phoneMark = "";


    @Override
    public void onCreate() {
        super.onCreate();
        context = this;
    }
}
