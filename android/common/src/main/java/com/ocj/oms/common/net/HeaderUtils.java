package com.ocj.oms.common.net;

import android.text.TextUtils;

import com.ocj.oms.utils.AntiEmulator;
import com.ocj.oms.utils.DeviceUtils;
import com.ocj.oms.utils.Installation;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.UIManager;
import com.ocj.oms.utils.system.AppUtil;
import com.ocj.oms.utils.system.TelephoneUtil;

/**
 * Created by liuzhao on 2017/6/24.
 */

public class HeaderUtils {
    private static String regionCd;

    /**
     * .header("x-access-token", authToken)
     * .header("X-device-id", TelephoneUtil.getIMEI())
     * .header("X-msale-way", "ADR")
     * .header("X-msale-code", "TM")
     * .addHeader("Accept", "application/json")
     * .addHeader("Content-type", "application/json")
     */
    public static String getAccessToken() {
        return OCJPreferencesUtils.getAccessToken();
    }

    public static String getDeviceId() {
        if (AntiEmulator.checkPipes()) {
            return String.valueOf(DeviceUtils.getBuildTime());
        } else {
            if (TextUtils.isEmpty(TelephoneUtil.getIMEI())) {
                return Installation.id(UIManager.getInstance().getBaseContext());
            } else
                return TelephoneUtil.getIMEI();
        }
    }

    public static String getMsaleWay() {
        return "ADR";
    }

    public static String getMsaleCode() {
        return "TM";
    }

    public static String getAccept() {
        return "application/json";
    }

    public static String getContentType() {
        return "application/json";
    }

    public static String getNetWorkTypeName() {
        return NetUtils.getNetworkTypeName(UIManager.getInstance().getBaseContext());
    }


    public static String getVersionInfo() {
        return AppUtil.getVersionName(UIManager.getInstance().getBaseContext());
    }

    public static String getSubstationCode() {
        return OCJPreferencesUtils.getSubstation();
    }

    public static String getSelReginCd() {
        return OCJPreferencesUtils.getSelRegion();
    }

    public static String getRegionCd() {
        return OCJPreferencesUtils.getRegion();
    }

    public static String getJpushCode() {
        return OCJPreferencesUtils.getJpushCode();
    }
}
