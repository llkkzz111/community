package com.community.equity.utils;

import android.content.Context;

import com.community.equity.BuildConfig;
import com.mcxiaoke.packer.helper.PackerNg;

/**
 * Created by Han on 2016/3/9.
 */
public class ConstantUtils {

    public static final String SCHEME_community = "community";
    public static final String SCHEME_HTTPS = "https";
    public static final String SCHEME_HTTP = "http";
    public static final String community_QUESTION = "question";
    public static final String community_ANSWER = "answer";
    public static final String community_USER = "user";
    public static final String community_PAGE = "page";
    public static final String PAGE_HOME = "home";
    public static final String PAGE_MESSAGE = "message";
    public static final String PAGE_ME = "me";
    public static final String PAGE_MOTION = "motion";
    public static final String PAGE_COMMUNITY = "community";
    public static final String PAGE_SESSION = "session";
    public static final int INPUT_FILE_REQUEST_CODE = 1;
    public static final int ADD_LINK_REQUEST_CODE = 2;
    public static final int ADD_IMAGE_REQUEST_CODE = 3;

    public static final int QUESTION_TITLE_MAX_LENGTH = 50;
    public static final int QUESTION_CONTENT_MAX_LENGTH = 3000;
    public static final int ANSWER_CONTENT_MAX_LENGTH = 30000;
    public static final int COMMENT_CONTENT_MAX_LENGTH = 1000;

    /**
     * API by nie
     * http://api.staging.community.com/
     */
    public static final String BASE_API_URL = BuildConfig.BASE_API_URL;
    public static final int MAX_SHOW_MSG = 99;
    /**
     * 微信APPID
     */
    public static final String WEIXIN_APPID = "wxaf7984b99d0d5be4";
    /**
     * 微信AppSecret
     */
    public static final String WEIXIN_APPSECRET = "d4624c36b6795d1d99dcf0547af5443d";
    public static final String WX_LOG_ACTION = "com.community.equity.wxapi.WXEntryActivity";
    public static final String WX_RESP_STATE = "com.community.equity";
    public static boolean isLogin = false;
    public static int USER_ID = -1;
    public static int SCREEN_WIDTH = 0;
    public static int SCREEN_HEIGHT = 0;
    public static float DENSITYDPI = 0;
    public static float DENSITY = 0;
    /**
     * BASE_API by Alex
     * https://staging.community.com/
     */
    private static String BASE_URL = BuildConfig.BASE_URL;
    public static final String URL_HOME = BASE_URL;
    public static final String URL_ME = BASE_URL + "login";
    public static final String BASE_HTTP_URL = BASE_URL + "news/api/";
    public static final String BASE_EDIT_URL = BASE_URL + "news/editor";
//    public static String BASE_EDIT_URL = "http://192.168.88.25:3000/news/editor";

    /**
     * 我投资的项目
     */
    public static final String HTTPS_community_INVESMENTS = BASE_URL + "users/investments?s=community";
    /**
     * 我发起的项目
     */
    public static final String HTTPS_community_LAUNCHED_PITCHES = BASE_URL + "users/launched_pitches?s=community";
    /**
     * 我的约谈记录
     */
    public static final String HTTPS_community_REQUEST_CALL = BASE_URL + "users/request_calls?s=community";
    /**
     * 我的领投记录
     */
    public static final String HTTPS_community_LEAD_INVESTORS = BASE_URL + "users/lead_investors?s=community";
    /**
     * 投资托管账户
     */
    public static final String HTTPS_community_ACCOUNT_PAY = BASE_URL + "user/account";

    /**
     * 盛付通帮助
     */
    public static final String HTTPS_community_HELP_SHENGFU_PAY = BASE_URL + "topic/pages/help-shengpay-mobile";
    /**
     * 常用股权投资术语
     */
    public static final String HTTPS_community_HELP_TERM = BASE_URL + "topic/pages/financing-terms";
    /**
     * 常用QA
     */
    public static final String HTTPS_community_HELP_QA = BASE_URL + "topic/pages/used-qa";
    /**
     * 银行汇款帮助
     */
    public static final String HTTPS_community_HELP_BANK = BASE_URL + "topic/pages/help-remittance";
    /**
     * 银行汇款帮助
     */
    public static final String HTTPS_community_COMMUNITY_ITERM = BASE_URL + "topic/pages/community-community-iterm";
    /**
     * 交易中心
     */
    public static final String HTTPS_community_TRADING_CENTER = BASE_URL + "pitches/search";
    /**
     * 创投咨询
     */
    public static final String HTTPS_community_VC_INFORMATIONS = BASE_URL + "topic/pages";


    /**
     * 根据渠道以及编译类型判断推送环境
     *
     * @return
     */
    public static String getEnvironmentType(Context mContext) {
        if (BuildConfig.BUILD_TYPE.equals("release")) {
            if (PackerNg.getMarket(mContext).equals("beta")) {
                //根据不同渠道来判断是否是正式包
                return "dev_";
            } else {
                return "";
            }
        } else {
            return "dev_";
        }

    }
}
