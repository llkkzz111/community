package com.choudao.imsdk.imutils;


import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.StatusType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.utils.Logger;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * Created by dufeng on 16-4-13.
 * Description: 发送消息队列
 */
public class SendMessageQueue {

    public static final String TAG = "===SendMessageQueue===";

    private SendMessageQueue() {

    }

    private static SendMessageQueue instance;

    public static synchronized SendMessageQueue getInstance() {
        if (instance == null) {
            instance = new SendMessageQueue();
        }
        return instance;
    }

    public final short VERSION = 2;

    private IMMessageManager imMessageManager = IMMessageManager.getInstance();

    private BlockingQueue<MessageDTO> writeMessageQueue = new ArrayBlockingQueue<MessageDTO>(200);

    public BlockingQueue<MessageDTO> getWriteMessageQueue() {
        return writeMessageQueue;
    }

    public MessageDTO getSendMessage() throws InterruptedException {
        return writeMessageQueue.take();
    }


    public synchronized void addSendMessage(MessageType msgType, BaseRequest baseRequest) {

        if (msgType == MessageType.LOGIN && StatusManager.getInstance().getSocketStatus() != StatusType.SOCKET_CONNECTED) {
            return;
        }

        MessageDTO request = new MessageDTO(VERSION, msgType.code, JSON.toJSONString(baseRequest));

        imMessageManager.putRequest(request.getSeq(), baseRequest, request.msgTypeEnum());

        /**
         * 如果socket登录成功且不是发送登录请求，
         * 或者socket连接成功且发送的是登录请求
         * 则入发送队列
         *
         //        switch (StatusManager.getInstance().getSocketStatus()) {
         //            case LOGIN_SERVER_SUCCESS:
         //                if (msgType != MessageType.LOGIN) {
         //                    writeMessageQueue.add(request);
         //                }
         //                break;
         //            case SOCKET_CONNECTED:
         //                if (msgType == MessageType.LOGIN) {
         //                    writeMessageQueue.add(request);
         //                }
         //                break;
         //        }
         */
        if ((StatusManager.getInstance().getSocketStatus() == StatusType.LOGIN_SERVER_SUCCESS && msgType != MessageType.LOGIN)
                || (StatusManager.getInstance().getSocketStatus() == StatusType.SOCKET_CONNECTED && msgType == MessageType.LOGIN)) {
            if (writeMessageQueue.size() < 200) {
                writeMessageQueue.add(request);
            } else {
                Logger.e(TAG, "writeMessageQueue >= 200");
            }
        } else {
            imMessageManager.addTimeoutMessageTask(request.getSeq());
            Logger.e(TAG, "msgType --> " + msgType +
                    "\nsocketStatus --> " + StatusManager.getInstance().getSocketStatus() +
                    "\nrequest --> " + JSON.toJSONString(request)
            );
        }
    }


}
