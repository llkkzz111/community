package com.choudao.imsdk.dto.constants;

/**
 * Created by dufeng on 16/8/30.<br/>
 * Description: PullType
 */
public enum PullType {
    UNKNOWN(-1),

    OFFLINE(1),
    HISTORY(2);

    public final int code;

    PullType(int code) {
        this.code = code;
    }

    public static PullType of(int code)  {
        for (PullType type : PullType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
