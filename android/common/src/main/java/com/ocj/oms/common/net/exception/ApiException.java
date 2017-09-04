package com.ocj.oms.common.net.exception;

import android.net.ParseException;

import com.google.gson.JsonParseException;
import com.ocj.oms.common.net.mode.ApiCode;
import com.ocj.oms.common.net.mode.ApiResult;

import org.json.JSONException;

import java.io.IOException;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

import retrofit2.HttpException;


/**
 * @Description: API异常统一管理
 * @author: jeasinlee
 * @date: 2016-12-30 17:59
 */
public class ApiException extends IOException {

    private final int code;
    private String message;

    public ApiException(Throwable throwable, int code) {
        super(throwable);
        this.code = code;
        this.message = throwable.getMessage();
    }

    public ApiException(String msg, int code) {
        super(new Throwable());
        this.code = code;
        this.message = msg;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public ApiException setMessage(String message) {
        this.message = message;
        return this;
    }

    public String getDisplayMessage() {
        return message + "(code:" + code + ")";
    }

    public static boolean isSuccess(ApiResult apiResult) {
        if (apiResult == null) {
            return false;
        }
        return apiResult.getCode() == ApiCode.Response.HTTP_SUCCESS && ignoreSomeIssue(apiResult.getCode());
    }

    private static boolean ignoreSomeIssue(int code) {
        switch (code) {
            case ApiCode.Response.HTTP_SUCCESS:
            case ApiCode.Response.TIMESTAMP_ERROR://时间戳过期
            case ApiCode.Response.ACCESS_TOKEN_EXPIRED://AccessToken错误或已过期
            case ApiCode.Response.REFRESH_TOKEN_EXPIRED://RefreshToken错误或已过期
            case ApiCode.Response.OTHER_PHONE_LOGINED: //帐号在其它手机已登录
            case ApiCode.Response.SIGN_ERROR://签名错误
                return true;
            default:
                return false;
        }
    }

    public static ApiException handleException(Throwable e) {
        ApiException ex;
        if (e instanceof HttpException) {
            HttpException httpException = (HttpException) e;
            ex = new ApiException(e, ApiCode.Request.HTTP_ERROR);
            switch (httpException.code()) {
                case ApiCode.Http.UNAUTHORIZED:
                    ex.message = "用户未登录！";
                    break;
                case ApiCode.Http.FORBIDDEN:
                    ex.message = "不需要更新";
                    break;
                case ApiCode.Http.NOT_FOUND:
                    ex.message = "找不到相关接口";
                    break;
                case ApiCode.Http.REQUEST_TIMEOUT:
                    ex.message = "请求超时";
                    break;
                case ApiCode.Http.GATEWAY_TIMEOUT:
                    ex.message = "请求超时";
                    break;
                case ApiCode.Http.INTERNAL_SERVER_ERROR:
                    ex.message = "服务器异常";
                    break;
                case ApiCode.Http.BAD_GATEWAY:
                    ex.message = "无效网关";
                    break;
                case ApiCode.Http.SERVICE_UNAVAILABLE:
                    ex.message = "服务器异常";
                    break;
                default:
                    ex.message = "未知异常";
                    break;
            }
            return ex;
        } else if (e instanceof JsonParseException || e instanceof JSONException || e instanceof ParseException) {
            ex = new ApiException(e, ApiCode.Request.PARSE_ERROR);
            ex.message = "数据解析异常";
            return ex;
        } else if (e instanceof ConnectException) {
            ex = new ApiException(e, ApiCode.Request.NETWORK_ERROR);
            ex.message = "网络错误";
            return ex;
        } else if (e instanceof javax.net.ssl.SSLHandshakeException) {
            ex = new ApiException(e, ApiCode.Request.SSL_ERROR);
            ex.message = "证书出错";
            return ex;
        } else if (e instanceof SocketTimeoutException) {
            ex = new ApiException(e, ApiCode.Request.TIMEOUT_ERROR);
            ex.message = "请求超时";
            return ex;
        } else if (e instanceof UnknownHostException) {
            ex = new ApiException(e, ApiCode.Request.UNKNOW_HOST_ERROR);
            ex.message = "服务器连接异常";
            return ex;
        } else {
            ex = new ApiException(e, ApiCode.Request.UNKNOWN);
            ex.message = "未知异常";
            return ex;
        }
    }

}
