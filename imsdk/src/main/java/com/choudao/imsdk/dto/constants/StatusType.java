package com.choudao.imsdk.dto.constants;

/**
 * Created by dufeng on 16/4/26.<br/>
 * Description: SocketStatus
 */
public enum StatusType {

    /** Net */
    NETWORK_CONNECTED,
    NETWORK_UNAVAILABLE,

    /** Socket */
    SOCKET_CONNECTED,
    SOCKET_DISCONNECTED,
    LOGIN_SERVER_SUCCESS,
    DESTROY
//    LOGIN_SERVER_FAILED,
//    LOGIN_SERVER_TIMEOUT

}
