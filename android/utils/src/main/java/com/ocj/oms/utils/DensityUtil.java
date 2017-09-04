package com.ocj.oms.utils;

import android.annotation.TargetApi;
import android.app.Application;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Display;
import android.view.WindowManager;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Create by jeasinlee 2016/5/7 007
 */
public class DensityUtil {
    /**
     * 设置字体倍率
     *
     * @param c
     * @param fontScale
     */
    public static void setFountScale(Context c, float fontScale) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        Configuration config = c.getResources().getConfiguration();
        config.fontScale = fontScale;
        c.getResources().updateConfiguration(config, null);
    }

    public static int dip2px(Context c, float dpValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        final float scale = c.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    public static int dip2sp(Context c, float dpValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        return (int) (TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, c.getResources().getDisplayMetrics()));
    }

    public static int px2dip(Context c, float pxValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        final float scale = c.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }


    public static int px2sp(Context c, float pxValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        float fontScale = c.getResources().getDisplayMetrics().scaledDensity;
        return (int) (pxValue / fontScale + 0.5f);
    }


    public static int sp2px(Context c, float spValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        float fontScale = c.getResources().getDisplayMetrics().scaledDensity;
        return (int) (spValue * fontScale + 0.5f);
    }

    public static int sp2dip(Context c, float spValue) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        return (int) (TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, spValue, c.getResources().getDisplayMetrics()));
    }

    public static int getScreenW(Context c) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        return c.getResources().getDisplayMetrics().widthPixels;
    }

    public static int getScreenH(Context c) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        return c.getResources().getDisplayMetrics().heightPixels;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public static int getScreenRealH(Context context) {
        if (!(context instanceof Application)) {
            context = context.getApplicationContext();
        }
        int h;
        WindowManager winMgr = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = winMgr.getDefaultDisplay();
        DisplayMetrics dm = new DisplayMetrics();
        if (Build.VERSION.SDK_INT >= 17) {
            display.getRealMetrics(dm);
            h = dm.heightPixels;
        } else {
            try {
                Method method = Class.forName("android.view.Display").getMethod("getRealMetrics", DisplayMetrics.class);
                method.invoke(display, dm);
                h = dm.heightPixels;
            } catch (Exception e) {
                display.getMetrics(dm);
                h = dm.heightPixels;
            }
        }
        return h;
    }

    public static int getStatusBarH(Context context) {
        if (!(context instanceof Application)) {
            context = context.getApplicationContext();
        }

        Class<?> c;
        Object obj;
        Field field;
        int statusBarHeight = 0;
        try {
            c = Class.forName("com.android.internal.R$dimen");
            obj = c.newInstance();
            field = c.getField("status_bar_height");
            int x = Integer.parseInt(field.get(obj).toString());
            statusBarHeight = context.getResources().getDimensionPixelSize(x);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
        return statusBarHeight;
    }

    public static int getNavigationBarrH(Context c) {
        if (!(c instanceof Application)) {
            c = c.getApplicationContext();
        }
        Resources resources = c.getResources();
        int identifier = resources.getIdentifier("navigation_bar_height", "dimen", "android");
        return resources.getDimensionPixelOffset(identifier);
    }


    public static int getScreenWidth(Context context) {
        if (!(context instanceof Application)) {
            context = context.getApplicationContext();
        }
        WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.widthPixels;
    }
}
