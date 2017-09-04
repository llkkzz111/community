package com.ocj.oms.common;

/**
 * Created by Jixiang_Li on 2017/2/7.
 */

public class JConfig {

    public static final int IL_LOADING_RES = R.drawable.icon_dougou_def;//默认加载中的资源id
    public static final int IL_ERROR_RES = R.drawable.icon_dougou_def;//默认加载失败的资源id
    public static final String CACHE_SP_NAME = "sp_cache";//默认SharedPreferences缓存目录
    public static final String CACHE_DISK_DIR = "disk_cache";//默认磁盘缓存目录
    public static final String CACHE_HTTP_DIR = "http_cache";//默认HTTP缓存目录


    public static final String COOKIE_PREFS = "Cookies_Prefs";//默认Cookie缓存目录

    public static final long CACHE_MAX_SIZE = 10 * 1024 * 1024;//默认最大缓存大小

    public static String RNReturnUrl = "";
}
