package com.choudao.imsdk.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.choudao.imsdk.IMApplication;

/**
 * Created by dufeng on 16/6/29.<br/>
 * Description: SharedPreferencesUtils
 */
public class SharedPreferencesUtils {

    private static String PREFERENCE_NAME = "ChouDaoPreferences";
    /**
     * access_token
     */
    private static String ACCESS_TOKEN_KEY = "access_token";
    /**
     * token_type
     */
    private static String TOKEN_TYPE = "token_type";

    /**
     * 读取Access_token
     *
     * @return
     */
    public static String getAccessToken() {
        return getString(ACCESS_TOKEN_KEY);
    }

    /**
     * 读取TokenType
     *
     * @return
     */
    public static String getTokenType() {
        return getString(TOKEN_TYPE);
    }

    /**
     * get string preferences
     *
     * @param key The name of the preference to retrieve
     * @return The preference value if it exists, or null. Throws ClassCastException if there is a preference with this
     * name that is not a string
     * @see #getString(String, String)
     */
    public static String getString(String key) {
        return getString(key, null);
    }

    /**
     * get string preferences
     *
     * @param key          The name of the preference to retrieve
     * @param defaultValue Value to return if this preference does not exist
     * @return The preference value if it exists, or defValue. Throws ClassCastException if there is a preference with
     * this name that is not a string
     */
    public static String getString(String key, String defaultValue) {
        SharedPreferences settings = IMApplication.context.getSharedPreferences(PREFERENCE_NAME, Context.MODE_PRIVATE);
        return settings.getString(key, defaultValue);
    }

    public static int getInt(String key, int defaultValue) {
        SharedPreferences settings = IMApplication.context.getSharedPreferences(PREFERENCE_NAME, Context.MODE_PRIVATE);
        return settings.getInt(key, defaultValue);
    }

    public static boolean putInt(String key, int value) {
        SharedPreferences settings = IMApplication.context.getSharedPreferences(PREFERENCE_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = settings.edit();
        editor.putInt(key, value);
        return editor.commit();
    }

    public static int getUserId() {
        return getInt("user_id", -1);
    }

    public static void setContactsVersion(int version) {
        SharedPreferencesUtils.putInt("VERSION_" + SharedPreferencesUtils.getUserId(), version);
    }

}
