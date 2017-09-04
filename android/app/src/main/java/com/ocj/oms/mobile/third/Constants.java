package com.ocj.oms.mobile.third;

/**
 * Created by Administrator on 2017/4/21 0021.
 */

public class Constants {
    //-------------------------微博------------------------------
    public static final String WEIBO_APP_KEY = "3028957123";
    public static final String WEIBO_REDIRECT_URL = "http://www.ocj.com.cn/main/index.jsp";
    public static final String WEIBO_SCOPE = "email,direct_messages_read,direct_messages_write,"
            + "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
            + "follow_app_official_microblog," + "invitation_write";
    //-------------------------支付宝----------------------------
    //支付宝网关地址
    public static final String ALIPAY_SERVER_URL = "https://openapi.alipay.com/gateway.do";
    //应用ID
    public static final String ALIPAY_APPID = "2015022600032698";
    //返回结果格式：xml、json;
    public static final String ALIPAY_RESULT_FORMAT = "json";
    //手机支付宝登录使用，对就的公钥在  PID和KEY>无线账户授权V1>查看密钥
    public static final String ALIPAY_RSA_PRIVATE = "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAPSkj/X2B5HZ+vYAlyfnqnhE5gSL6LOlX5djf1iRyZZg/qxuIXzMZBY9s5DZkbHNVzgvGaavna8LPpi3CnCtytgGJK5LabunhGOE+YPJfORpRwzC3tZC4sxuR1qD/S+lbWeoDReykOfh1gBEFv2laaD9lFkOzA6NmfW3q34p/kAlAgMBAAECgYEAnJGhTOHrkE24jq5sDu72K8i0iV5dTHPfTM0x2CZdpK9o7kQBjJRmzdEpVd/Ynbl0Q5HpUcN9IGUK58Plm52uffh6AIZIux8V2RwBcc7vtH2qkp+hPQugtC5JMIrRuVIdLqpAyOhVZ2VxZDOuqvX7Fmv/smbxz8etiGGNF3e1+dUCQQD+Rrk+Cz4c6T/JBjL6e4KsZvwj+61+4IFk8ylyUvGUU7TlN5Q/BwR0NDnpWnD9By+wUdUC6+eS12Rd7n0QT2J/AkEA9k0e496kwGcTSszMJwC54fEJfAGtx9AfksWVfXz6VkZN3gERNgNjAUcEgyLzTYVoPl9jnU2Kj8T9klI3i4FDWwJBAPygl3qlANkIhG7c0dk6zOEskGXPrtfXhbceP5duAMY1RAxX49maxzoMiVzmlktN0HuFUfTNHA4wIW+Ren+x31ECQQCJI/neMVsU0o/YZ14JHYtitf5s8NZdWpIp/CA3pj4RicXTpk55/7rBvFRT3EMS2ARqLlzd+o37bVkvft30rH3fAkBuN0Mlgp+ZXU2RwzBBeco5gpFk9JEKzC5vfcO4SS1R8BsLYgUvkOS0dqAoo2x8od6a3OzWVbE99H99l3Z5A1Yr";
    //支付宝联合登录得到auth_code使用，第一次加签名使用，对应 的公钥在   PID和KEY>合作伙伴密钥管理>查看密钥
    public static final String ALIPAY_RSA_PRIVATE_LOGIN = "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOCfwj3HPJhM31H/8fqZDl4dFGOqPPPyBvAvDGaj6V04qpjrukc7g3LdxZO0CYV1kFAovn4WfzskavA06kIkm6hXb3MvaP5WeTkEXM64gVE4mc7JZB8tspAICtYV+2keajfiM1zhUTsj5eT0GyTkOZy8M/ojPvO/fpjnZv+AAkexAgMBAAECgYEA0I9FWPsOphJqH8bXNGi8UGILtmYwZghIrOXiS8LRQL8Glyn4MX9uk06azoORe5smvWa3SHc29wDfUdyvzW4UH0IRhy34Z3PsVh7q8h0hy+PX3tF7l/TwMqG6dwdvdJzi6VJCrMURC748t/8KmiEfjso3VqtJ6ydJ/mIpONaU6qkCQQD7bQotHzvIaJ9SoS6HxUdpYAZHEfAJ1dedNXr6gxsg5fJnj7kvp62iPoNJ32+lml9ExNT4OPQZKB8kTCHvyxkbAkEA5LXlLaxTWA4vcZiNIczAvh7sK78Mbfb9uY9SZisnvyLkzd0JS7WDpeqztlJjN2VGh44bAEtDDOBCKS/WdEgbIwJBAKa25siErV92AC8KMZBVf8Sfp4n4mvHqmc3kaGc0CAkIcHO7GVBAHyI10Vhqj91/PyyaV51AJpuHvx6SXO5j/YECQBEZmH0FuWWICfwQT90LFg4g+b97lU5TfTz2fk6tQ1eDIGBT+nHyrFknZzBmkIx/wfo4ocQv3F+GFOxHa11eVskCQQCXw7XrBrYVWt0KTCw30ilnMHpP9K/8xMIJ9ipL6M659HbB5iBbcBxOk6HlNfFtK3xpfMAQFla6XTF8OYFo9chi";
    public static final String ALIPAY_PID = "2088101165910954";
    public static final String ALIPAY_TARGET_ID = "";
    //---------------------------QQ----------------------------
    public static final String QQ_APPID = "100846439";
    public static final String QQ_SCOPE_ALL = "all";
    public static final String QQ_SCOPE_USER_INFO = "get_simple_userinfo";
    public static final String QQ_SCOPE_ADD_TOPIC = "add_topic";
    //---------------------------微信----------------------------
    public static final String WEIXIN_APP_ID = "wx6013c8f57b63e8f5";
    public static final String WEIXIN_SCOPE = "snsapi_userinfo";
    public static final String WEIXIN_TOKEN_API = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";

    //人工热线
    public static final String HOT_LINE = "4008898000";

    /**
     * 第三方平台唯一ID
     */
    public static String OPEN_ID = "";
    /**
     * 平台
     */
    public static String PLATFROM = "";

    public static String CARD_NO = "";
    public static String CARD_NO_Query = "";


    public final static int VIDEO_PLAYING = 1;//正在播放
    public final static int VIDEO_TO_PLAY = 2;//即将播出
    public final static int VIDEO_REPLAY = 3;//精彩回放


}
