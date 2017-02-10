package com.choudao.imsdk.imutils;

import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.utils.Logger;
import com.choudao.imsdk.utils.SocketUtils;

import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;

/**
 * Created by dufeng on 16/4/27.<br/>
 * Description: SendMessageThread
 */
public class SendMessageThread extends Thread {

    private static final String TAG = "===SendMessageThread===";

    private Socket socket;
    private MessageDTO currentMessage;

    private final Object lock = new Object();

    public SendMessageThread() {
        super("Thread-ReceiveMessage");
    }

    public void setOutputStream(Socket socket) {
        synchronized (lock) {
            this.socket = socket;
            lock.notify();
        }
    }


    @Override
    public void run() {
        for (; ; ) {
            try {
                if (currentMessage == null) {
                    currentMessage = SendMessageQueue.getInstance().getSendMessage();
                }
                sendMessage(currentMessage);
            } catch (Exception e) {
                Logger.e(TAG, e.getMessage());
            }
        }
    }

    /**
     * 发送消息
     *
     * @param message
     * @throws IOException
     */
    public void sendMessage(MessageDTO message) {
        int msgLength = message.getMsgLength();
        byte[] bytes = new byte[msgLength + 4];

        int index = 0;
        SocketUtils.int2ByteArray(message.getMsgLength(), bytes, index);
        index += 4;
        SocketUtils.short2ByteArray(message.getHeaderLength(), bytes, index);
        index += 2;
        SocketUtils.short2ByteArray(message.getVersion(), bytes, index);
        index += 2;
        SocketUtils.short2ByteArray(message.getMsgType(), bytes, index);
        index += 2;
        SocketUtils.short2ByteArray(message.getSeq(), bytes, index);
        index += 2;
        SocketUtils.string2ByteArray(message.getBody(), bytes, index);
        Logger.d(TAG, "writeByte -> " + JSON.toJSONString(bytes));

        synchronized (lock) {
            try {
                socket.getOutputStream().write(bytes);
                Logger.i(TAG, "[" + socket.getLocalPort() + "] write - " + currentMessage.toString());
                currentMessage = null;

            } catch (IOException e) {
                try {
                    currentMessage = message;
                    lock.wait();
                } catch (InterruptedException e1) {
                    Logger.e(TAG, "writeErr -> " + e1.getMessage() + " " + Thread.currentThread().getName());
                }
                Logger.e(TAG, "sendMessage -> " + e.getMessage() + " " + Thread.currentThread().getName());
            }

        }
    }
}
