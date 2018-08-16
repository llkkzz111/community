package com.community.imsdk.imutils;


import com.community.imsdk.IMApplication;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.SocketAction;
import com.community.imsdk.dto.constants.StatusType;
import com.community.imsdk.dto.request.LoginRequest;
import com.community.imsdk.imutils.callback.IMStatusListener;
import com.community.imsdk.utils.Logger;

import java.io.IOException;
import java.net.Socket;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * Created by dufeng on 16-4-14.
 * Description: socket管理
 */
public class SocketManager extends BaseManager implements IMStatusListener {

    private static final String TAG = "===SocketManager===";
    private volatile boolean isLoggingIn = false;
    private volatile boolean isKickOut = false;
    private volatile boolean isDestroy = false;


    private Socket socket;
    private SendMessageThread sendMessageThread;
    private Thread socketActionThread = new Thread() {
        @Override
        public void run() {
            for (; ; ) {
                try {

                    switch (socketActionQueue.take()) {
                        case CONNECT:
                            Logger.e(TAG, "CONNECT1 --> socketStatus:" + socketStatus + "  netStatus --> " + netStatus + " isCanConnect --> " + IMApplication.isCanConnect);

                            if (netStatus == StatusType.NETWORK_CONNECTED && IMApplication.isCanConnect) {
                                /**如果已经重连成功，不再重连*/
                                if (socketStatus == StatusType.LOGIN_SERVER_SUCCESS || socketStatus == StatusType.SOCKET_CONNECTED) {
                                    break;
                                }
                                Logger.e(TAG, "CONNECT2 --> socketStatus:" + socketStatus + "  netStatus --> " + netStatus);
                                connectMsgServer();
                            }
                            break;
                        case DESTROY:
                            disconnectMsgServer();
                            break;
                    }

                } catch (Exception e) {
                    Logger.e(TAG, "init -> ", e);
                }
            }
        }
    };

    private SocketManager() {
        sendMessageThread = new SendMessageThread();
        StatusManager.getInstance().addIMStatusReceiver(this);
    }

    public boolean isKickOut() {
        return isKickOut;
    }

    public void setKickOut(boolean kickOut) {
        isKickOut = kickOut;
    }

    public boolean isDestroy() {
        return isDestroy;
    }

    public void setDestroy(boolean destroy) {
        isDestroy = destroy;
    }


    /**
     * 自身状态
     */
    private StatusType socketStatus = StatusType.SOCKET_DISCONNECTED;
    private StatusType netStatus = StatusType.NETWORK_CONNECTED;


    private static SocketManager instance;
//    private static final Object lock = new Object();


    public static synchronized SocketManager getInstance() {
        if (instance == null) {
            instance = new SocketManager();
        }
        return instance;
    }


    private BlockingQueue<SocketAction> socketActionQueue = new ArrayBlockingQueue<SocketAction>(100);

    public void addSocketAction(SocketAction action) {
        if (netStatus == StatusType.NETWORK_CONNECTED && socketActionQueue.size() < 100) {
            socketActionQueue.add(action);
        }
    }

    public void init() {
        if (socketActionThread.getState() == Thread.State.NEW) {
            socketActionThread.start();
        }
    }

    /**
     * 登录socket服务器
     */
    public void login() {
        isDestroy = false;
        addSocketAction(SocketAction.CONNECT);
    }

    public void logout() {
        isDestroy = true;
        addSocketAction(SocketAction.DESTROY);
    }


    private void connectMsgServer() {
        if (isLoggingIn) {
            return;
        }
        isLoggingIn = true;
        Logger.e(TAG, "isKickOut -> " + isKickOut + " -- isDestroy -> " + isDestroy + " -- userId -> " + IMApplication.userId);
        if (IMApplication.userId != -1 && !isKickOut && !isDestroy) {

            /**断开上一次连接，如果有*/
            if (socket != null && !socket.isClosed()) {
                try {
                    socket.close();
                    Logger.i(TAG, "[" + socket.getLocalPort() + "] ===socket.close=== " + socket.isClosed());
                    socket = null;
                } catch (IOException e) {
                    Logger.e(TAG, "connectMsgServer -> ", e);
                }
            }

            /**连接地址和端口*/
            String serverAddress = IMApplication.serverAddress;
            int serverPort = IMApplication.serverPort;
//            String serverAddress = "10.241.60.34";
//            int serverPort = 9999;
            Logger.i(TAG, "connectMsgServer -> " + serverAddress + ":" + serverPort);

            /**开始连接*/
            try {
                socket = new Socket(serverAddress, serverPort);
                /**连接成功后*/
                Logger.i(TAG, "info -> " + socket.toString());

                new ReceiveMessageThread(socket).start();

                sendMessageThread.setOutputStream(socket);
                if (sendMessageThread.getState() == Thread.State.NEW) {
                    sendMessageThread.start();
                }

                StatusManager.getInstance().onSocketStatusChange(StatusType.SOCKET_CONNECTED);
                SendMessageQueue.getInstance().addSendMessage(MessageType.LOGIN,
                        new LoginRequest(IMApplication.userId, IMApplication.phoneMark, IMApplication.token, IMApplication.appVersion, System.currentTimeMillis()));

            } catch (IOException e) {
                /**socket连接失败,sleep 30~32 秒后再次重连*/
                Logger.e(TAG, "connectMsgServer:IOException --> sleep start");
                long interval = 30 * 1000 + (long) (2 * (Math.random() * 1000));
                try {
                    Thread.sleep(interval);
                    addSocketAction(SocketAction.CONNECT);
                } catch (InterruptedException ie) {
                    Logger.e(TAG, "connectMsgServer:InterruptedException -> ", e);
                }
                Logger.e(TAG, "connectMsgServer:IOException --> sleep end:", e);
            }
        }
        isLoggingIn = false;
//        }

    }


    /**
     * 断开与服务器的链接
     */
    public void disconnectMsgServer() {
        Logger.i(TAG, "disconnectMsgServer");
        if (socket != null && !socket.isClosed()) {
            try {
                socket.close();
                Logger.i(TAG, "[" + socket.getLocalPort() + "] ===socket.close=== " + socket.isClosed());
                StatusManager.getInstance().onSocketStatusChange(StatusType.DESTROY);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    @Override
    public void notifyNetStatus(StatusType status) {
        netStatus = status;
        switch (status) {
            case NETWORK_CONNECTED:
                addSocketAction(SocketAction.CONNECT);
                break;
            case NETWORK_UNAVAILABLE:
                if (socketActionThread != null) {
                    socketActionThread.interrupt();
                }
                break;
        }
    }

    @Override
    public void notifySocketStatus(StatusType status) {
        socketStatus = status;
        if (status == StatusType.SOCKET_DISCONNECTED) {
            HeartBeatManager.getInstance().closeHB();
            IMMessageManager.getInstance().stopTimeoutTimer();
            addSocketAction(SocketAction.CONNECT);
        }
    }

//    public void reconnectMsg() {
//        synchronized (SocketManager.class) {
//            if (connectInfo != null) {
//                connectMsgServer(connectInfo);
//            } else {
//                disconnectMsgServer();
////                IMLoginManager.getInstance().relogin();
//            }
//        }
//    }


}
