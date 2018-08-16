package com.community.imsdk.dto.constants;


/**
 * Created by dingkangjian on 16/5/5.
 */
public enum UserType {
    UNKNOWN(-1),
    NORMAL(1),
    SYSTEM(2);
    public final int code;

    UserType(int code) {
        this.code = code;
    }

    public static UserType of(int code) {
        for (UserType type : UserType.values()) {
            if (type.code == code) {
                return type;
            }
        }

        return UNKNOWN;
    }
}
