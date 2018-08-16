package com.community.imsdk.dto.constants;

/**
 * Created by dufeng on 16/8/24.<br/>
 * Description: ContentType
 */
public enum ContentType {
    UNKNOWN(-2),
    LOCAL(-1),

    TEXT(1),
    FRIEND_REQUEST(2),
    CHANGE_LOG(3),
    GROUP_KICK_OUT_INFO(5),
    ;

    public final int code;

    ContentType(int code) {
        this.code = code;
    }

    public static ContentType of(int code) {
        for (ContentType type : ContentType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
