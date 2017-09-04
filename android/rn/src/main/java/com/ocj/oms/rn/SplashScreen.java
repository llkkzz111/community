package com.ocj.oms.rn;

import android.app.Activity;
import android.app.ProgressDialog;

/**
 * Created by admin-ocj on 2017/6/3.
 */

public class SplashScreen {
    public static ProgressDialog progressDialog;

    /**
     * 打开启动屏
     */
    public static void show(Activity activity) {
        progressDialog = new ProgressDialog(activity);
        progressDialog.show();
    }

    /**
     * 关闭启动屏
     */
    public static void hide(Activity activity) {
        if (progressDialog != null) {
            progressDialog.dismiss();
            progressDialog = null;
        }
    }
}
