package com.ocj.oms.mobile.utils;

import android.util.Base64;

/**
 * Created by liutao on 2017/7/19.
 */

public class HexUtils {
    //将 BASE64 编码的字符串 s 进行解码
    public static String getFromBASE64(String s) {
        if (s == null) return null;
        return new String(Base64.decode(s, Base64.DEFAULT));
    }
}
