package com.community.imsdk.dto.constants;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: GroupType
 */

public enum GroupType {
    UNKNOWN(-1),
    NORMAL(1);
    public final int code;

    GroupType(int code) {
        this.code = code;
    }

    public static GroupType of(int code) {
        for (GroupType type : GroupType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
