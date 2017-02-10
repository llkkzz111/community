package com.choudao.imsdk.imutils;

import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.StatusType;
import com.choudao.imsdk.utils.Logger;
import com.choudao.imsdk.utils.SocketUtils;

import java.io.IOException;
import java.net.Socket;

/**
 * Created by dufeng on 16/4/26.<br/>
 * Description: SocketThread
 */
public class ReceiveMessageThread extends Thread {

    private static final String TAG = "===ReceiveMessageThread===";

    private Socket socket;

    private IMMessageManager imMessageManager = IMMessageManager.getInstance();


    public ReceiveMessageThread(Socket socket) {
        super("Thread-ReceiveMessage");
        this.socket = socket;
    }

    @Override
    public void run() {
        for (; ; ) {

            MessageDTO receiveMsg = receiveMessage();

            if (receiveMsg == null) {
                Logger.e(TAG, "read -> receiveMsg is null");
                break;
            }
            Logger.setTraceId(String.valueOf(System.currentTimeMillis()));

            Logger.i(TAG, "[" + socket.getLocalPort() + "] read -> " + receiveMsg.toString());

            imMessageManager.addReceiveMessageTask(receiveMsg);


        }
    }


    /**
     * 接收消息
     *
     * @return
     * @throws IOException
     */
    private MessageDTO receiveMessage() {


        MessageDTO receiveMsg = new MessageDTO();

        byte[] msgLen = new byte[4];

        if (read(msgLen) != -1) {
            receiveMsg.setMsgLength(SocketUtils.byteArray2Int(msgLen));
        } else {
            return null;
        }


        int msgLength = receiveMsg.getMsgLength();
        if (msgLength == 0) {
            return null;
        }
        byte[] msg = new byte[msgLength];
        int readLen = read(msg);
        if (readLen != -1 && msg.length > 0) {
            int index = 0;
            receiveMsg.setHeaderLength(SocketUtils.byteArray2Short(msg, index));
            index += 2;
            receiveMsg.setVersion(SocketUtils.byteArray2Short(msg, index));
            index += 2;
            receiveMsg.setMsgType(SocketUtils.byteArray2Short(msg, index));
            index += 2;
            receiveMsg.setSeq(SocketUtils.byteArray2Short(msg, index));
            index += 2;
            receiveMsg.setBody(SocketUtils.byteArray2String(msg, index, msgLength - index));
        } else {
            return null;
        }

        return receiveMsg;
    }


    private int read(byte[] b) {
        int i;
        int readLen = 0;
        int arrLen = b.length;
        try {
            do {
                i = socket.getInputStream().read(b, readLen, arrLen - readLen);
                readLen += i;
                if (i == -1) {
                    Logger.e(TAG, "IM服务器连接断开");
                    StatusManager.getInstance().onSocketStatusChange(StatusType.SOCKET_DISCONNECTED);
                    return -1;
                }
            } while (readLen < arrLen);

        } catch (IOException e) {
            Logger.e(TAG, "IOException--IM服务器连接断开");
            Logger.e(TAG, "IOException:" + e.getMessage());
            StatusManager.getInstance().onSocketStatusChange(StatusType.SOCKET_DISCONNECTED);
        }
        Logger.d(TAG, "readByte -> " + JSON.toJSONString(b));

        return readLen;
    }

}
