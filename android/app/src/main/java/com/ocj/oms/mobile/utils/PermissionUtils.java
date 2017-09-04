package com.ocj.oms.mobile.utils;

import android.app.AppOpsManager;
import android.content.Context;
import android.os.Binder;
import android.os.Build;
import android.util.Log;

import java.lang.reflect.Method;

/**
 * Created by liuzhao on 16/9/23.
 */

public class PermissionUtils {
    /**
     * @see AppOpsManager
     */
    public static final int OP_READ_CONTACTS = 4;
    public static final int OP_READ_PHONE_STATE = 51;
    private static String TAG = "PermissionUtils";

    /**
     * 是否禁用某项操作
     *
     * @hide
     */
    public static boolean isAllowed(Context context, int op) {
        Log.d(TAG, "api level: " + Build.VERSION.SDK_INT);
        if (Build.VERSION.SDK_INT < 19) {
            return true;
        }
        Log.d(TAG, "op is " + op);
        String packageName = context.getApplicationContext().getPackageName();
        AppOpsManager aom = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
        Class<?>[] types = new Class[]{int.class, int.class, String.class};
        Object[] args = new Object[]{op, Binder.getCallingUid(), packageName};
        try {
            Method method = aom.getClass().getDeclaredMethod("checkOpNoThrow", types);
            Object mode = method.invoke(aom, args);
            Log.d(TAG, "invoke checkOpNoThrow: " + mode);
            if ((mode instanceof Integer) && ((Integer) mode == AppOpsManager.MODE_ALLOWED)) {
                Log.d(TAG, "allowed");
                return true;
            }
        } catch (Exception e) {
            Log.e(TAG, "invoke error: " + e);
            e.printStackTrace();
        }
        return false;
    }
}
