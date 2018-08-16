package com.community.imsdk.dto.request;

import com.community.imsdk.utils.IMDigestUtils;


/**
 * Created by dufeng on 16-4-14.<br/>
 * Description: LoginDTO
 */
public class LoginRequest extends BaseRequest {
    private long userId;
    /** android设备  */
    private int deviceType = 1;

    private String deviceId;

    private String sign;
    private String appVersion;

    private long timestamp;

    public LoginRequest() {
    }

    public LoginRequest(long userId, String deviceId, String token, String appVersion, long timestamp) {
        this.userId = userId;
        this.deviceId = deviceId;
        this.timestamp = timestamp;
        this.appVersion = appVersion;
        this.sign = encryptToken(token);
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(int deviceType) {
        this.deviceType = deviceType;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getAppVersion() {
        return appVersion;
    }

    public void setAppVersion(String appVersion) {
        this.appVersion = appVersion;
    }


    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    private String encryptToken(String token) {
//        Logger.e("====Login===", "token - >" + token);
//        Logger.e("====Login===", "before sign - >" + appVersion + deviceId + deviceType + timestamp + userId + IMDigestUtils.sha256Hex(token));
        return IMDigestUtils.sha256Hex(appVersion + deviceId + deviceType + timestamp + userId + IMDigestUtils.sha256Hex(token));
    }
}
