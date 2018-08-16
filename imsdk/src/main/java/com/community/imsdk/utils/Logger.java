package com.community.imsdk.utils;

import android.util.Log;

import java.text.SimpleDateFormat;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: Utils
 */
public class Logger {
    public static ThreadLocal<String> threadTraceId = new ThreadLocal<>();

    public interface LoggerListener {

        void writeLog(String msg);
    }

    public static LoggerListener loggerListener;

    private Logger() {
        throw new UnsupportedOperationException("cannot be instantiated");
    }

    public static boolean isDebug = true;
    private static final String TAG = "===========";

    public static void i(String msg) {
        i(TAG, msg);
    }

    public static void d(String msg) {
        d(TAG, msg);
    }

    public static void e(String msg) {
        e(TAG, msg);
    }

    public static void v(String msg) {
        v(TAG, msg);
    }

    public static void w(String msg) {
        w(TAG, msg);
    }

    public static void i(String tag, String msg) {
        if (isDebug) {
            msg = getThreadInfo(msg);
            loggerListener.writeLog(getNowTime() + " I/" + tag + ": " + msg);
            Log.i(tag, msg);
        }
    }

    public static void d(String tag, String msg) {
//        loggerListener.writeLog(getNowTime() + " D/" + tag + ": " + msg);
        if (isDebug) {
            msg = getThreadInfo(msg);
            Log.d(tag, msg);
        }
    }

    public static void e(String tag, String msg) {
        if (isDebug) {
            msg = getThreadInfo(msg);
            loggerListener.writeLog(getNowTime() + " E/" + tag + ": " + msg);
            Log.e(tag, msg);
        }
    }

    public static void e(String tag, String extra, Exception e) {
        if (isDebug) {

            String msg = getThreadInfo(extra + "\n" + Log.getStackTraceString(e));
            loggerListener.writeLog(getNowTime() + " E/" + tag + ": " + msg);
            Log.e(tag, msg);
        }
    }

    public static void v(String tag, String msg) {
        if (isDebug) {
            if (msg != null)
                Log.v(tag, msg);
            else
                Log.v(tag, "msg为空");
        }
    }

    public static void w(String tag, String msg) {
        if (isDebug) {
            if (msg != null)
                Log.w(tag, msg);
            else
                Log.w(tag, "msg为空");
        }
    }

    public static String getTraceId() {
        if (isDebug) {
            String traceId = threadTraceId.get();
            return traceId == null ? "" : traceId;
        } else {
            return "";
        }
    }

    public static void setTraceId(String traceId) {
        if (isDebug) {
            threadTraceId.set("< " + traceId + " >");
        }
    }


    private static String getThreadInfo(String msg) {
        return Thread.currentThread().getName() + " " + getTraceId() + " ## " + msg;
    }

    private static String getNowTime() {
        String result = "";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            result = sdf.format(System.currentTimeMillis());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "\n" + result;
    }
}