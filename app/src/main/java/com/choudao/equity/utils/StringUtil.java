package com.choudao.equity.utils;

import android.text.TextUtils;

public class StringUtil {

    public static String getUrlFileName(String fileUrl) {
        int index = fileUrl.lastIndexOf("/");
        System.out.println("index:" + index);
        if (index != -1) {
            String result = fileUrl.substring(index + 1);
            if (TextUtils.isEmpty(result)) {
                return MD5Util.getMD5Str(fileUrl);
            }
            return result;
        } else {
            return MD5Util.getMD5Str(fileUrl);
        }
    }

    public static   int getStringLength(String value) {
        int valueLength = 0;
        String chinese = "[\u4e00-\u9fa5]";
        for (int i = 0; i < value.length(); i++) {
            String temp = value.substring(i, i + 1);
            if (temp.matches(chinese)) {
                valueLength += 2;
            } else {
                valueLength += 1;
            }
        }
        return valueLength;
    }

}
