/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 * <p/>
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

package com.ocj.oms.mobile.base;

import android.animation.ArgbEvaluator;
import android.animation.ValueAnimator;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.support.v4.view.ViewCompat;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowManager;

import com.facebook.common.logging.FLog;
import com.facebook.react.bridge.GuardedRunnable;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.common.ReactConstants;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.PixelUtil;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;

import javax.annotation.Nullable;

/**
 * {@link NativeModule} that allows changing the appearance of the status bar.
 */
@ReactModule(name = "StatusBarManager")
public class StatusBarModule extends ReactContextBaseJavaModule {

    private static final String HEIGHT_KEY = "HEIGHT";

    public StatusBarModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "StatusBarManager";
    }

    @Override
    public
    @Nullable
    Map<String, Object> getConstants() {
        final Context context = getReactApplicationContext();
        final int heightResId = context.getResources()
                .getIdentifier("status_bar_height", "dimen", "android");
        final float height = heightResId > 0 ?
                PixelUtil.toDIPFromPixel(context.getResources().getDimensionPixelSize(heightResId)) :
                0;

        return MapBuilder.<String, Object>of(
                HEIGHT_KEY, height);
    }

    @ReactMethod
    public void setColor(final int color, final boolean animated) {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            FLog.w(ReactConstants.TAG, "StatusBarModule: Ignored status bar change, current activity is null.");
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            UiThreadUtil.runOnUiThread(
                    new GuardedRunnable(getReactApplicationContext()) {
                        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
                        @Override
                        public void runGuarded() {
                            if (animated) {
                                int curColor = activity.getWindow().getStatusBarColor();
                                ValueAnimator colorAnimation = ValueAnimator.ofObject(
                                        new ArgbEvaluator(), curColor, color);

                                colorAnimation.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                                    @Override
                                    public void onAnimationUpdate(ValueAnimator animator) {
                                        activity.getWindow().setStatusBarColor((Integer) animator.getAnimatedValue());
                                    }
                                });
                                colorAnimation
                                        .setDuration(300)
                                        .setStartDelay(0);
                                colorAnimation.start();
                            } else {
                                activity.getWindow().setStatusBarColor(color);
                            }
                        }
                    });
        }
    }

    @ReactMethod
    public void setTranslucent(final boolean translucent) {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            FLog.w(ReactConstants.TAG, "StatusBarModule: Ignored status bar change, current activity is null.");
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            UiThreadUtil.runOnUiThread(
                    new GuardedRunnable(getReactApplicationContext()) {
                        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
                        @Override
                        public void runGuarded() {
                            // If the status bar is translucent hook into the window insets calculations
                            // and consume all the top insets so no padding will be added under the status bar.
                            View decorView = activity.getWindow().getDecorView();
                            if (translucent) {
                                decorView.setOnApplyWindowInsetsListener(new View.OnApplyWindowInsetsListener() {
                                    @Override
                                    public WindowInsets onApplyWindowInsets(View v, WindowInsets insets) {
                                        WindowInsets defaultInsets = v.onApplyWindowInsets(insets);
                                        return defaultInsets.replaceSystemWindowInsets(
                                                defaultInsets.getSystemWindowInsetLeft(),
                                                0,
                                                defaultInsets.getSystemWindowInsetRight(),
                                                defaultInsets.getSystemWindowInsetBottom());
                                    }
                                });
                            } else {
                                decorView.setOnApplyWindowInsetsListener(null);
                            }

                            ViewCompat.requestApplyInsets(decorView);
                        }
                    });
        }
    }

    @ReactMethod
    public void setHidden(final boolean hidden) {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            FLog.w(ReactConstants.TAG, "StatusBarModule: Ignored status bar change, current activity is null.");
            return;
        }
        UiThreadUtil.runOnUiThread(
                new Runnable() {
                    @Override
                    public void run() {
                        if (hidden) {
                            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                            activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
                        } else {
                            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
                            activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
                        }
                    }
                });
    }

    @ReactMethod
    public void setStyle(final String style) {
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            FLog.w(ReactConstants.TAG, "StatusBarModule: Ignored status bar change, current activity is null.");
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            UiThreadUtil.runOnUiThread(
                    new Runnable() {
                        @TargetApi(Build.VERSION_CODES.M)
                        @Override
                        public void run() {
                            View decorView = activity.getWindow().getDecorView();
                            decorView.setSystemUiVisibility(
                                    style.equals("dark-content") ? View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR : 0);
                        }
                    }
            );
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            UiThreadUtil.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    try {
                        FlymeSetStatusBarLightMode(activity.getWindow(), style.equals("dark-content"));
                        MIUISetStatusBarLightMode(activity.getWindow(), style.equals("dark-content"));
                    } catch (Exception e) {
                    }
                }
            });
        }
    }

    /**
     * 设置状态栏图标为深色和魅族特定的文字风格
     * 可以用来判断是否为Flyme用户
     *
     * @param window 需要设置的窗口
     * @param dark   是否把状态栏字体及图标颜色设置为深色
     * @return boolean 成功执行返回true
     */
    public static boolean FlymeSetStatusBarLightMode(Window window, boolean dark) {
        boolean result = false;
        if (window != null) {
            try {
                WindowManager.LayoutParams lp = window.getAttributes();
                Field darkFlag = WindowManager.LayoutParams.class
                        .getDeclaredField("MEIZU_FLAG_DARK_STATUS_BAR_ICON");
                Field meizuFlags = WindowManager.LayoutParams.class
                        .getDeclaredField("meizuFlags");
                darkFlag.setAccessible(true);
                meizuFlags.setAccessible(true);
                int bit = darkFlag.getInt(null);
                int value = meizuFlags.getInt(lp);
                if (dark) {
                    value |= bit;
                } else {
                    value &= ~bit;
                }
                meizuFlags.setInt(lp, value);
                window.setAttributes(lp);
                result = true;
            } catch (Exception e) {

            }
        }
        return result;
    }

    /**
     * 设置状态栏字体图标为深色，需要MIUIV6以上
     *
     * @param window 需要设置的窗口
     * @param dark   是否把状态栏字体及图标颜色设置为深色
     * @return boolean 成功执行返回true
     */
    public static boolean MIUISetStatusBarLightMode(Window window, boolean dark) {
        boolean result = false;
        if (window != null) {
            Class clazz = window.getClass();
            try {
                int darkModeFlag = 0;
                Class layoutParams = Class.forName("android.view.MiuiWindowManager$LayoutParams");
                Field field = layoutParams.getField("EXTRA_FLAG_STATUS_BAR_DARK_MODE");
                darkModeFlag = field.getInt(layoutParams);
                Method extraFlagField = clazz.getMethod("setExtraFlags", int.class, int.class);
                if (dark) {
                    extraFlagField.invoke(window, darkModeFlag, darkModeFlag);//状态栏透明且黑色字体
                } else {
                    extraFlagField.invoke(window, 0, darkModeFlag);//清除黑色字体
                }
                result = true;
            } catch (Exception e) {

            }
        }
        return result;
    }
}
