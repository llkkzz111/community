package com.community.imsdk.dto.constants;

/**
 * Created by dingkangjian on 16/5/10.
 */
public enum SessionType {
    UNKNOWN(-1),
    PRIVATE_CHAT(1),
    GROUP_CHAT(2),
    FRIEND_REQUEST(3),
    PERSONAL_GROUP_NOTICE(4),
    GROUP_MEMBER_CHANGE_LOG(5),
    GROUP_INFO_CHANGE_LOG(6);

    public final int code;

    SessionType(int code) {
        this.code = code;
    }

    public static SessionType of(int code)  {
        for (SessionType type : SessionType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }

}
