package com.community.imsdk.dto.constants;

/**
 * Created by dingkangjian on 16/5/18.
 */
public enum MessageType {

    LOCAL_GROUP_INFO_CHANGED(-5),
    LOCAL_GROUP_KICK_OUT(-4),
    LOCAL_GROUP_MEMBER_CHANGED(-3),
    LOCAL_LOAD_FRIEND_END(-2),
    UNKNOWN(-1),

    HEART_BEAT(0),

    LOGIN(1001),

    SEND_MESSAGE(1011),
    PULL_MESSAGE(1012),
    ACK_MESSAGE(1013),

    PULL_OFFLINE_RECORD(1031),
    ACK_OFFLINE_RECORD(1032),

    SET_SESSION_CONFIG(1041),
    PULL_SESSION_CONFIG(1042),
    DELETE_SESSION_CONFIG(1043),

    SET_USER_CONFIG(1051),
    GET_USER_CONFIG(1052),
    DELETE_USER_CONFIG(1053),

    ADD_FRIEND(1071),
    DELETE_FRIEND(1072),
    PULL_FRIENDS_LIST(1073),
    SET_FRIEND_REMARK(1074),
    GET_FRIEND_REMARK(1075),
    CHECK_FRIENDS_LIST(1076),
    ACCEPT_FRIEND_REQUEST(1077),
    GET_FRIEND_CONFIRMATION(1078),

    CREATE_GROUP(1081),
    GET_GROUP_INFO(1082),
    UPDATE_GROUP_INFO(1083),
    LEAVE_GROUP(1084),
    GET_GROUP_INFO_AND_MEMBER(1085),

    ADD_GROUP_MEMBER(1091),
    REMOVE_GROUP_MEMBER(1092),
    PULL_GROUP_MEMBER(1093),

    KICK_OUT(2001),
    PUSH_MESSAGE(2002),
    SYNC_FLAG(2004),
    FRIENDS_LIST_CHANGED(2005),
    PUSH_ACTION_EVENT(2006);

    public final short code;

    MessageType(int code) {
        this.code = (short) code;
    }

    public static MessageType of(int code)  {
        if (code >= 0 && code <= Short.MAX_VALUE) {
            for (MessageType type : MessageType.values()) {
                if (type.code == code) {
                    return type;
                }
            }
        }
        return UNKNOWN;
    }

}
