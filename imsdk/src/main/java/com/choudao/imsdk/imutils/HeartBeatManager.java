package com.choudao.imsdk.imutils;


import android.os.Handler;

import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.StatusType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.choudao.imsdk.utils.Logger;


/**
 * Created by dufeng on 16-4-19.<br/>
 * Description: HaertBeatManager
 */
public class HeartBeatManager extends BaseManager implements IReceiver {

    private static final String TAG = "===HaertBeatManager===";

    private static int HBOutTimeCount;
    //发送心跳的时间最好大于或等于超时时间
    private int HB_SEND_TIME = 40 * 1000;


    private volatile boolean stopFlag = false;
    private volatile boolean hasTask = false;
    private Handler timerHandler = new Handler();


    private HeartBeatManager() {
    }

    private static HeartBeatManager instance;

    public static synchronized HeartBeatManager getInstance() {
        if (instance == null) {
            instance = new HeartBeatManager();
        }
        return instance;
    }

    /** ===================消息超时Timer===================== */

    private void startTimer() {
        if (!stopFlag && !hasTask) {
            hasTask = true;
            timerHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    timerImpl();
                    hasTask = false;
                    startTimer();
                }
            }, HB_SEND_TIME);
        }
    }

    private void timerImpl() {
        if (HBOutTimeCount >= 2) {
            Logger.e(TAG, "IM服务器连接断开");
            StatusManager.getInstance().onSocketStatusChange(StatusType.SOCKET_DISCONNECTED);
        } else {
            if (!stopFlag) {
                SendMessageQueue.getInstance().addSendMessage(MessageType.HEART_BEAT, new BaseRequest());
                Logger.i(TAG, "==HBOutTimeCount==" + String.valueOf(HBOutTimeCount) + " --> " + Thread.currentThread().getName());
            }
        }
    }

    /** ===================消息超时Timer===================== */


    public void startHB() {
        stopFlag = false;
        HBOutTimeCount = 0;
        IMMessageDispatcher.bindMessageType(MessageType.HEART_BEAT, this);
        startTimer();
    }

    public void closeHB() {
        stopFlag = true;
        HBOutTimeCount = 0;
        IMMessageDispatcher.unbindMessageType(MessageType.HEART_BEAT, this);
    }


    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        HBOutTimeCount = 0;
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
//        HBOutTimeCount++;
//        Logger.e(TAG, "receiverFail --> " + HBOutTimeCount);
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        HBOutTimeCount++;
        Logger.e(TAG, "receiverTimeout --> " + HBOutTimeCount);
    }
}
