package com.community.imsdk.dto.constants;

/**
 * Created by dufeng on 16/10/21.<br/>
 * Description: ResponseCode
 */

public class ResponseCode {

    public static final String SUCCESS = "00";//请求成功

    public static final String LOGIN_FAIL = "1000";//认证失败

    public static final String LOGIN_TIME_INCORRECT = "1001";//登录时间不正确

    public static final String CHECK_FRIENDSHIP_FAIL = "1101";//非好友关系

    public static final String FRIEND_REQUEST_EXPIRED = "1301";//好友请求已过期

    public static final String NO_TWO_WAY_FRIEND = "1401";//没有双向好友

    public static final String NOT_GROUP_MEMBER = "1402";//非群组成员

    public static final String OPERATION_DONE_BY_OTHER = "1403";//此操作已被其他人完成

}
