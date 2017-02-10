package com.choudao.imsdk.dto.constants;

/**
 * Created by dufeng on 16/6/16.<br/>
 * Description: ActionType
 */
public enum ActionType {

    UNKNOWN(-1),
    MSG(1);

    public final int code;

    ActionType(int code) {
        this.code = code;
    }

    public static ActionType of(int code)  {
        for (ActionType type : ActionType.values()) {
            if (type.code == code) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
