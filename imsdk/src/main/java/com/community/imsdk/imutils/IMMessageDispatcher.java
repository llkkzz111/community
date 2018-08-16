package com.community.imsdk.imutils;


import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.imutils.callback.IReceiver;
import com.community.imsdk.utils.Logger;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Created by dufeng on 16-4-15.<br/>
 * Description: 消息接收分发管理
 */
public class IMMessageDispatcher {
    private static final String TAG = "===IMMessageDispatcher===";


    /**
     * 管理分发器类型的map
     */
    private static Map<MessageType, List<IReceiver>> dispatcherMap = new HashMap<>();

    static {
        for (MessageType type : MessageType.values()) {
            dispatcherMap.put(type, new CopyOnWriteArrayList<IReceiver>());
        }
    }

    public static void bindMessageTypeArray(MessageType[] msgTypeArray, IReceiver receiver) {
        for (MessageType msgType : msgTypeArray) {
            dispatcherMap.get(msgType).add(receiver);
        }
    }

    public static void unbindMessageTypeArray(MessageType[] msgTypeArray, IReceiver receiver) {
        for (MessageType msgType : msgTypeArray) {
            dispatcherMap.get(msgType).remove(receiver);
        }
    }

    public static void bindMessageType(MessageType msgType, IReceiver receiver) {
        dispatcherMap.get(msgType).add(receiver);
    }

    public static void unbindMessageType(MessageType msgType, IReceiver receiver) {
        dispatcherMap.get(msgType).remove(receiver);
    }


    public static void onSuccess(final MessageType messageType, final BaseRequest request, final Object result) {
//        Logger.e(TAG, messageType.name() + " -> onSuccess start - " + getDispatcher(messageType).receiverList.size());
        for (final IReceiver receiver : dispatcherMap.get(messageType)) {
            if (receiver != null) {
                receiver.receiverMessageSuccess(messageType, request, result);
            } else {
                Logger.e(TAG, "onSuccess -> receiver is null");
            }
//            Logger.e(TAG, messageType.name() + " -> onSuccess iterator - " + JSON.toJSON(request));
        }
//        Logger.e(TAG, messageType.name() + " -> onSuccess end - " + JSON.toJSON(request));
    }

    public static void onFail(final MessageType messageType, final BaseRequest request, final MessageDTO response) {
        for (final IReceiver receiver : dispatcherMap.get(messageType)) {

            if (receiver != null) {
                receiver.receiverMessageFail(messageType, request, response);
            } else {
                Logger.e(TAG, "onFail -> receiver is null");
            }
        }
    }

    public static void onTimeout(final MessageType messageType, final BaseRequest request) {
        for (final IReceiver receiver : dispatcherMap.get(messageType)) {

            if (receiver != null) {
                receiver.receiverMessageTimeout(messageType, request);
            } else {
                Logger.e(TAG, "onTimeout -> receiver is null");
            }
        }

    }
}
