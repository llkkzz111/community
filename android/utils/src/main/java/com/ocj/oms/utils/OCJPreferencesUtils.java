package com.ocj.oms.utils;


import android.text.TextUtils;

import com.google.gson.JsonObject;

import static com.ocj.oms.utils.PreferencesKeys.FINGER_TYPE;
import static com.ocj.oms.utils.PreferencesKeys.LOOK_STATE;
import static com.ocj.oms.utils.PreferencesKeys.OPEN_TIMES;
import static com.ocj.oms.utils.PreferencesKeys.UNIQUE_VIDEO_ID;

/**
 * Created by liu on 2017/4/26.
 */

public class OCJPreferencesUtils extends PreferencesUtils {


    /**
     * 是否是第一次访问
     *
     * @return
     */
    public static boolean isFirst() {
        return getBoolean(PreferencesKeys.IS_FIRST, true);
    }

    /**
     * 是否是第一次访问
     *
     * @param visitor
     * @return
     */
    public static boolean setIsFirst(boolean visitor) {
        return putBoolean(PreferencesKeys.IS_FIRST, visitor);
    }

    /**
     * 读取username
     *
     * @return
     */
    public static boolean isVisitor() {
        return getBoolean(PreferencesKeys.IS_VISITOR, true);
    }

    /**
     * 设置Username
     *
     * @param visitor
     * @return
     */
    public static boolean setVisitor(boolean visitor) {
        return putBoolean(PreferencesKeys.IS_VISITOR, visitor);
    }
    /**
     * 读取internetId
     *
     * @return
     */
    public static String getInternetId() {
        return getString(PreferencesKeys.INTERNET_ID);
    }

    /**
     * 设置internetId
     *
     * @param internetId
     * @return
     */
    public static boolean setInternetId(String  internetId) {
        return putString(PreferencesKeys.INTERNET_ID, internetId);
    }

    /**
     * 读取username
     *
     * @return
     */
    public static String getCustName() {
        return getString(PreferencesKeys.CUST_NAME);
    }

    /**
     * 设置Username
     *
     * @param custName
     * @return
     */
    public static boolean setCustName(String custName) {
        return putString(PreferencesKeys.CUST_NAME, custName);
    }

    /**
     * custNo
     *
     * @return
     */
    public static String getCustNo() {
        return getString(PreferencesKeys.CUST_NO);
    }

    /**
     * custNo
     *
     * @param custNo
     * @return
     */
    public static boolean setCustNo(String custNo) {
        return putString(PreferencesKeys.CUST_NO, custNo);
    }


    /**
     * 设置LoginId
     *
     * @param loginId
     * @return
     */
    public static boolean setLoginID(String loginId) {
        return putString(PreferencesKeys.LOGIN_ID, loginId);
    }

    /**
     * 获取LoginId
     */
    public static String getLoginId() {
        return getString(PreferencesKeys.LOGIN_ID);
    }

    /**
     * 存储RNhost
     *
     * @param host
     * @return
     */
    public static boolean setRNApiHost(String host) {
        return putString(PreferencesKeys.RN_API_HOST, host);
    }


    /**
     * 获取rnhost
     *
     * @return
     */
    public static String getRNApiHost() {
        return getString(PreferencesKeys.RN_API_HOST);
    }

    public static boolean setRNDebug(String debug) {
        return putString(PreferencesKeys.RN_API_DEBUG, debug);
    }

    public static String getRNDebug() {
        return getString(PreferencesKeys.RN_API_DEBUG);
    }

    /**
     * 存储RNhost
     *
     * @param host
     * @return
     */
    public static boolean setRNH5ApiHost(String host) {
        return putString(PreferencesKeys.RN_H5_API_HOST, host);
    }

    /**
     * 获取rnhost
     *
     * @return
     */
    public static String getRNH5ApiHost() {
        return getString(PreferencesKeys.RN_H5_API_HOST);
    }


    public static void setVideoId(String code) {
        OCJPreferencesUtils.putString(UNIQUE_VIDEO_ID, code);
    }

    public static String getVideoId() {
        return OCJPreferencesUtils.getString(UNIQUE_VIDEO_ID);
    }

    /**
     * 设置LoginType
     *
     * @param type
     * @return
     */
    public static boolean setLoginType(String type) {
        return putString(PreferencesKeys.LOGIN_TYPE, type);
    }

    /**
     * 获取LoginType
     */
    public static String getLoginType() {
        return getString(PreferencesKeys.LOGIN_TYPE);
    }


    /**
     * 读取Access_token
     *
     * @return
     */
    public static String getAccessToken() {
        return getString(PreferencesKeys.ACCESS_TOKEN_KEY);
    }

    /**
     * 设置AccessToken
     *
     * @param AccessToen
     * @return
     */
    public static boolean setAccessToken(String AccessToen) {
        if (TextUtils.isEmpty(AccessToen)) {
            return false;
        }
        return putString(PreferencesKeys.ACCESS_TOKEN_KEY, AccessToen);
    }

    /**
     * 读取头像
     *
     * @return
     */
    public static String getHeadImage() {
        return getString(PreferencesKeys.HEAD_IMAGE);
    }

    /**
     * 设置头像
     *
     * @param image
     * @return
     */
    public static boolean setHeadImage(String image) {
        return putString(PreferencesKeys.HEAD_IMAGE, image);
    }


    /**
     * 读取FOUNT_SCALE
     *
     * @return
     */
    public static float getFontScale() {
        return getFloat(PreferencesKeys.FOUNT_SCALE, 1.0f);
    }

    /**
     * 设置FOUNT_SCALE
     *
     * @param scale
     * @return
     */
    public static boolean setFontScale(float scale) {
        return putFloat(PreferencesKeys.FOUNT_SCALE, scale);
    }


    /**
     * 设置广告页
     *
     * @param image
     * @return
     */
    public static boolean setGuideAdvertImage(String image) {
        return putString(PreferencesKeys.GUIDE_ADVERT_IMG, image);
    }

    /**
     * 读取广告页
     *
     * @return
     */
    public static String getGuideAdvertImg() {
        return getString(PreferencesKeys.GUIDE_ADVERT_IMG);
    }


    /**
     * 设置地区
     *
     * @param selectArean
     * @return
     */
    public static boolean setArea(String selectArean) {
        return putString(PreferencesKeys.AREA_SETTING, selectArean);
    }

    /**
     * 读取地区
     *
     * @return
     */
    public static String getArea() {
        return getString(PreferencesKeys.AREA_SETTING);
    }


    /**
     * 设置地区
     *
     * @param selectArean
     * @return
     */
    public static boolean setVersion(String selectArean) {
        return putString(PreferencesKeys.VERSION_NAME, selectArean);
    }

    /**
     * 读取地区
     *
     * @return
     */
    public static String getVersion() {
        return getString(PreferencesKeys.VERSION_NAME);
    }

    /**
     * 地区默认是上海
     *
     * @return
     */
    public static JsonObject getDefaultArea() {
        JsonObject json = new JsonObject();
        json.addProperty("region_cd", "2000");
        json.addProperty("sel_region_cd", "2000");
        json.addProperty("substation_code", "100");
        json.addProperty("district_code", "");
        json.addProperty("area_lgroup", "10");
        json.addProperty("area_mgroup", "001");
        json.addProperty("area_lgroup_name", "上海");
        return json;
    }


    public static void setRegion(String region) {
        putString(PreferencesKeys.REGINON_CD, region);
    }

    public static String getRegion() {
        return getString(PreferencesKeys.REGINON_CD);
    }

    public static void setSelRegion(String SelRegion) {
        putString(PreferencesKeys.SEL_REGINON_CD, SelRegion);
    }

    public static String getSelRegion() {
        return getString(PreferencesKeys.SEL_REGINON_CD);

    }

    public static void setSubstation(String substation) {
        putString(PreferencesKeys.SUBSTATION_CODE, substation);
    }

    public static String getSubstation() {
        return getString(PreferencesKeys.SUBSTATION_CODE);
    }

    public static String getJpushCode() {
        return getString(PreferencesKeys.JPUSH_CODE);
    }

    public static void setJpushCode(String jpushCode) {
        putString(PreferencesKeys.JPUSH_CODE, jpushCode);
    }

    public static boolean setFeelGoodState(boolean feelGoodState) {
        return putBoolean(PreferencesKeys.FEEL_GOOD_STATE, feelGoodState);
    }

    public static boolean getFeelGoodState() {
        return getBoolean(PreferencesKeys.FEEL_GOOD_STATE);
    }

    public static int getlookAround() {
        return getInt(LOOK_STATE);
    }

    public static void setLookAround(int lookAround) {
        putInt(LOOK_STATE, lookAround);
    }

    public static int getOpenTimes() {
        return getInt(OPEN_TIMES);
    }

    public static void setOpenTimes(int openTimes) {
        putInt(OPEN_TIMES, openTimes);
    }

    public static void setBootAD(String bootAD) {
        putString(PreferencesKeys.BOOT_AD, bootAD);
    }

    public static String getBootAD() {
        return getString(PreferencesKeys.BOOT_AD);
    }

    public static boolean getFinger(){
        return  getBoolean(FINGER_TYPE,false);
    }

    public static void setFinger(boolean isFinger){
        putBoolean(FINGER_TYPE,isFinger);
    }
}
