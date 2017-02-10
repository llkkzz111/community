package com.choudao.imsdk.dto.constants;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: ChangeLogType
 */

public enum ChangeLogType {

    UNKNOWN(-1),

    ADD_GROUP_MEMBER(11),
    DELETE_GROUP_MEMBER(12),
    UPDATE_GROUP_NAME(21),
    UPDATE_GROUP_NOTICE(22),
    UPDATE_GROUP_HOLDER(23);

    public final int code;

    ChangeLogType(int code) {
        this.code = code;
    }

    public static ChangeLogType of(int code) {
        for (ChangeLogType type : ChangeLogType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
