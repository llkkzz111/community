package com.community.imsdk.imutils;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.community.imsdk.dto.constants.StatusType;
import com.community.imsdk.imutils.callback.IMStatusListener;
import com.community.imsdk.utils.Logger;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Created by dufeng on 16/5/23.<br/>
 * Description: StateManager
 */
public class StatusManager {

    private static final String TAG = "===StatusManager===";

    private StatusManager() {
    }

    private static StatusManager instance;

    public static synchronized StatusManager getInstance() {
        if (instance == null) {
            instance = new StatusManager();
        }
        return instance;
    }

    private StatusType socketStatus = StatusType.SOCKET_DISCONNECTED;
    private StatusType netStatus = StatusType.NETWORK_CONNECTED;

    public StatusType getSocketStatus() {
        return socketStatus;
    }

    public StatusType getNetStatus() {
        return netStatus;
    }

    private List<IMStatusListener> imStatusListenerList = new CopyOnWriteArrayList<>();

    public void addIMStatusReceiver(IMStatusListener imStatusListener) {
        imStatusListenerList.add(imStatusListener);
    }

    public void removeIMStatusReceiver(IMStatusListener imStatusListener) {
        imStatusListenerList.remove(imStatusListener);
    }


    private BroadcastReceiver connectionChangeReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            Logger.i(TAG, "--ConnectivityReceiver.onReceive()...");
            String action = intent.getAction();
            Logger.i(TAG, "--action = " + action);

            if (action.equals(ConnectivityManager.CONNECTIVITY_ACTION)) {

                ConnectivityManager connectivityManager = (ConnectivityManager) context
                        .getSystemService(Context.CONNECTIVITY_SERVICE);


                NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();

                if (networkInfo != null && networkInfo.isAvailable()) {
                    Logger.i(TAG, "--Network Type  = " + networkInfo.getTypeName());
                    Logger.i(TAG, "--Network State = " + networkInfo.getState());
                    //TODO 不去检查state，android提供的状态可能不准确，这块需要看看
//                    if (networkInfo.isConnected() && netStatus != StatusType.NETWORK_CONNECTED) {
                    if (netStatus != StatusType.NETWORK_CONNECTED) {
                        onNetStatusChange(StatusType.NETWORK_CONNECTED);
                    }
                } else {
                    onNetStatusChange(StatusType.NETWORK_UNAVAILABLE);
                    onSocketStatusChange(StatusType.SOCKET_DISCONNECTED);
                }

            }
        }
    };

    public void onNetStatusChange(StatusType netStatus) {
        Logger.i(TAG, "===onNetStatusChange--> " + netStatus);
        this.netStatus = netStatus;
        for (IMStatusListener listener : imStatusListenerList) {
            listener.notifyNetStatus(netStatus);
        }
    }

    public void onSocketStatusChange(StatusType socketStatus) {
        Logger.i(TAG, "===onSocketStatusChange--> " + socketStatus);
        this.socketStatus = socketStatus;
        for (IMStatusListener listener : imStatusListenerList) {
            listener.notifySocketStatus(socketStatus);
        }
    }

    public void registerReceiver(Context context) {
        if (context == null) {
            return;
        }
        IntentFilter filter = new IntentFilter();
        filter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
        context.registerReceiver(connectionChangeReceiver, filter);
    }

    public void unregisterReceiver(Context context) {
        if (context == null) {
            return;
        }
        context.unregisterReceiver(connectionChangeReceiver);
    }
}
