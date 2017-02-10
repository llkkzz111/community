package com.choudao.equity.utils;

import android.app.ActivityManager;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.wifi.WifiManager;
import android.os.Looper;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import com.choudao.equity.base.BaseApplication;
import com.choudao.equity.entity.ProfileEntity;
import com.choudao.equity.entity.UserEntity;
import com.choudao.equity.entity.UserInfoEntity;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.constants.UserType;
import com.choudao.imsdk.utils.Pinyin4jUtil;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Created by Han on 2016/3/9.
 */
public class Utils {

    private static long lastClickTime = -1;

    public static boolean isOnMainThread() {
        return Looper.myLooper() == Looper.getMainLooper();
    }

    /**
     * 判断服务是否后台运行
     *
     * @param mContext     Context
     * @param serviceClass 判断的服务名字
     * @return true 在运行 false 不在运行
     */
    public static boolean isServiceRun(Context mContext, Class serviceClass) {
        boolean isRun = false;
        ActivityManager activityManager = (ActivityManager) mContext
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningServiceInfo> serviceList = activityManager
                .getRunningServices(40);
        int size = serviceList.size();
        for (int i = 0; i < size; i++) {
            if (serviceList.get(i).service.getClassName().equals(serviceClass.getName())) {
                isRun = true;
                break;
            }
        }
        return isRun;
    }

    /**
     * 将UserEntity转换为UserInfo
     *
     * @param entity
     * @return
     */
    public static UserInfo toUserInfo(ProfileEntity entity) {
        return toUserInfo(entity, null);
    }

    /**
     * 将UserEntity转换为UserInfo
     *
     * @param entity
     * @return
     */
    public static UserInfo toUserInfo(ProfileEntity entity, UserInfo info) {
        if (info == null) {
            info = new UserInfo();
            info.setUserType(UserType.NORMAL.code);
        }
        info.setUserId(entity.getUser().getId());
        info.setHeadImgUrl(entity.getUser().getImg());
        info.setName(entity.getUser().getName());
        info.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(entity.getUser().getName()));
        info.setTitle(entity.getUser().getTitle());
        info.setPhone(entity.getUser().getPhone());
        info.setFollowersCount(entity.getUser().getFollowers_count());
        info.setAnswerCount(entity.getUser().getAnswers_counter());
        info.setQuestionCount(entity.getUser().getQuestions_count());
        info.setAddress(entity.getAddress());
        info.setDesc(entity.getDesc());
        info.setShareUrl(entity.getShare_url());
        info.setEducation(entity.getEducation());
        info.setExperience(entity.getExperience());
        return info;
    }


    public static ProfileEntity toProfile(UserInfo info) {
        ProfileEntity entity = new ProfileEntity();
        entity.setTitle(info.getTitle());
        entity.setAddress(info.getAddress());
        entity.setDesc(info.getDesc());
        UserEntity userEntity = new UserEntity();
        userEntity.setId((int) info.getUserId());
        userEntity.setTitle(info.getTitle());
        userEntity.setName(info.getName());
        userEntity.setQuestions_count(info.getQuestionCount() == null ? 0 : info.getQuestionCount());
        userEntity.setAnswers_counter(info.getQuestionCount() == null ? 0 : info.getAnswerCount());
        entity.setUser(userEntity);
        return entity;
    }


    /**
     * 将UserInfoEntity转换为UserInfo
     *
     * @param entity
     * @return
     */
    public static UserInfo userInfoEntityToUserInfo(UserInfoEntity entity) {
        return userInfoEntityToUserInfo(entity, null);
    }

    /**
     * 将UserInfoEntity转换为UserInfo
     *
     * @param userInfo
     * @return
     */
    public static UserInfo userInfoEntityToUserInfo(UserInfoEntity userInfoEntity, UserInfo userInfo) {
        if (userInfo == null) {
            userInfo = new UserInfo();
            userInfo.setUserType(UserType.NORMAL.code);
        }
        userInfo.setUserId(userInfoEntity.getId());
        userInfo.setHeadImgUrl(userInfoEntity.getImg());
        userInfo.setName(userInfoEntity.getName());
        userInfo.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(userInfo.getName()));
        userInfo.setTitle(userInfoEntity.getTitle());
        userInfo.setPhone(userInfoEntity.getPhone());
        userInfo.setAddress(userInfoEntity.getAddress());
        userInfo.setDesc(userInfoEntity.getDesc());
        userInfo.setShareUrl(userInfoEntity.getShare_url());
        userInfo.setAnswerCount(userInfoEntity.getAnswers_counter());
        userInfo.setQuestionCount(userInfoEntity.getQuestions_count());
        userInfo.setFollowersCount(userInfoEntity.getFollowers_count());
        userInfo.setFollowingCount(userInfoEntity.getFollowing_count());
        return userInfo;
    }

    /**
     * 防止快速点击
     *
     * @return
     */
    public synchronized static boolean isFastClick() {
        long time = System.currentTimeMillis();
        if (time - lastClickTime < 500 || lastClickTime == -1) {
            return true;
        }
        lastClickTime = time;
        return false;
    }

    /**
     * 获取版本号
     *
     * @return 当前应用的版本号
     */
    public static String getVersion(Context context) {
        try {
            PackageManager manager = context.getPackageManager();
            PackageInfo info = manager.getPackageInfo(context.getPackageName(),
                    0);
            String version = info.versionName;
            return version;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 获取Manifest里面配置的渠道版本
     *
     * @return
     * @author liuz
     */
    public static String getChannelValue(Context mContext, String channel) {
        try {
            channel = mContext.getPackageManager().getApplicationInfo(mContext.getPackageName(), PackageManager.GET_META_DATA).metaData.getString(channel);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return channel;
    }

    /**
     * 判断当前App是否打开
     *
     * @param mContext
     * @param PackageName
     * @return
     */
    public static boolean isForeground(Context mContext, String PackageName) {
        // Get the Activity Manager
        ActivityManager manager = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);

        // Get a list of running tasks, we are only interested in the last one,
        // the top most so we give a 1 as parameter so we only get the topmost.
        List<ActivityManager.RunningTaskInfo> task = manager.getRunningTasks(1);

        // Get the info we need for comparison.
        ComponentName componentInfo = task.get(0).topActivity;

        // Check if it matches our package name.
        if (componentInfo.getPackageName().startsWith(PackageName)) return true;

        // If not then our app is not on the foreground.
        return false;
    }

    public static String getTopActivityName(Context mContext) {
        ActivityManager manager = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> task = manager.getRunningTasks(1);
        ComponentName componentInfo = task.get(0).topActivity;
        return componentInfo.getClassName();
    }

    /**
     * 是否需要升级（只比较版本号前3位）
     *
     * @param installedVersion 安装的版本
     * @param updateVersion    升级的版本
     * @return
     */
    public static boolean needUpdate(String installedVersion, String updateVersion) {
        // 没有安装应用:直接升级
        if (TextUtils.isEmpty(installedVersion)) {
            return true;
        }
        // 安装了应用 ：1.升级的版本号为空，不用升级2.安装版本同升级版本一致，不用升级3.升级的版本号无效（不含.或版本号前三位出现非数字的字符），不用升级
        if (!TextUtils.isEmpty(installedVersion) && !TextUtils.isEmpty(updateVersion) && !installedVersion.equalsIgnoreCase(updateVersion)) {
            if (updateVersion.contains(".")) {
                String[] updateVersions = updateVersion.split("\\.");
                String[] installedVersions = installedVersion.split("\\.");
                try {
                    for (int i = 0; i < (Math.min(3, Math.min(updateVersions.length, installedVersions.length))); i++) {
                        if (Integer.valueOf(updateVersions[i]) > Integer.valueOf(installedVersions[i]))
                            return true;
                        else if (Integer.valueOf(updateVersions[i]) < Integer.valueOf(installedVersions[i])) {
                            return false;
                        }
                    }
                } catch (NumberFormatException e) {//版本号前三位出现非数字的字符
                    return false;
                }
            }
        }
        return false;
    }

    /**
     * 获取View高度
     *
     * @param v
     * @return
     */
    public static int getViewHiehgt(View v) {
        int w = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        int h = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        v.measure(w, h);
        return v.getHeight();
    }

    /**
     * 获取View宽度
     *
     * @param v
     * @return
     */
    public static int getViewWidth(View v) {
        int w = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        int h = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        v.measure(w, h);
        return v.getWidth();
    }

    public static void hideInput(View v) {
        InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm.isActive()) {
            imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
        }
    }

    public static void showInput(View v) {
        InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm.isActive()) {
            imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    /**
     * 判断集合是否为空
     *
     * @param collection
     * @return
     */
    public static boolean isEmpty(Collection<? extends Object> collection) {
        boolean isEmpty = true;
        if (collection != null && !collection.isEmpty()) {
            isEmpty = false;
        }
        return isEmpty;
    }

    /**
     * 获取手机中所有支持分享的应用列表
     *
     * @param context
     * @return
     */
    public static List<ResolveInfo> getShareApps(Context context) {
        List<ResolveInfo> mApps = new ArrayList<ResolveInfo>();
        Intent intent = new Intent(Intent.ACTION_SEND, null);
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        intent.setType("text/plain");
//      intent.setType("*/*");
        PackageManager pManager = context.getPackageManager();
        mApps = pManager.queryIntentActivities(intent,
                PackageManager.COMPONENT_ENABLED_STATE_DEFAULT);
        return mApps;
    }

    public static void copyText(Context mContext, String text) {
        ClipboardManager myClipboard = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
        ClipData myClip = ClipData.newPlainText("text", text);
        myClipboard.setPrimaryClip(myClip);
    }

    /**
     * 将多个换行空格合并为一个空格
     *
     * @param str
     * @return
     */
    public static String formatStr(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        return formatStr(str, " ");
    }

    /**
     * 将多个空格合并为一个空格，将多个换行合并为一个换行
     *
     * @param str
     * @return
     */
    public static String formatStrTo(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        return str.replaceAll("\\n{2,}", "\n").replaceAll("\\t{2,}", " ");
    }

    public static String formatStr(String str, String s) {
        return str.replaceAll("\\s{2,}", " ").replaceAll("\\n", s);
    }

    /**
     * 获取设备唯一ID
     *
     * @return MD5(IMEI + MacAddress)
     */
    public static String getEquipId() {

        return getMD5Str(getIMEI() + getMacAddress() + "choudao") + getDeviceInfo();
    }

    public static String getIMEI() {
        TelephonyManager TelephonyMgr = (TelephonyManager) BaseApplication.context.getSystemService(Context.TELEPHONY_SERVICE);
        return TelephonyMgr.getDeviceId();
    }

    public static String getMacAddress() {
        WifiManager wm = (WifiManager) BaseApplication.context.getSystemService(Context.WIFI_SERVICE);
        return wm.getConnectionInfo().getMacAddress();
    }

    public static String getDeviceInfo() {
        //获取手机型号
        String strPhoneModule = android.os.Build.MODEL;

        //获取系统版本
        String strSystemType = android.os.Build.VERSION.RELEASE;

        return "-(" + strPhoneModule + ")-(" + strSystemType + ")";
    }

    /**
     * MD5加密
     */
    private static String getMD5Str(String str) {
        MessageDigest messageDigest = null;

        try {
            messageDigest = MessageDigest.getInstance("MD5");

            messageDigest.reset();

            messageDigest.update(str.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            System.out.println("NoSuchAlgorithmException caught!");
            System.exit(-1);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        byte[] byteArray = messageDigest.digest();

        StringBuilder md5StrBuff = new StringBuilder();

        for (int i = 0; i < byteArray.length; i++) {
            if (Integer.toHexString(0xFF & byteArray[i]).length() == 1)
                md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));
            else
                md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));
        }
        return md5StrBuff.toString().toUpperCase();
    }
}
