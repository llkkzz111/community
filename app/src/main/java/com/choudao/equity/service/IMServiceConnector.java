package com.choudao.equity.service;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;

import com.choudao.imsdk.utils.Logger;


/**
 * Created by dufeng on 16-4-15.<br/>
 * IMService绑定
 * 供上层使用（activity）
 * manager层没有必要使用。
 */
public abstract class IMServiceConnector {

    private static final String TAG = "===IMServiceConnector===";
    private IMServiceConnectorAIDL imServiceConnectorAIDL;
    private boolean isBinded = false;
    private ServiceConnection imServiceConnection = new ServiceConnection() {

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Logger.i(TAG, " --> onServiceDisconnected");
            imServiceConnectorAIDL = null;
            isBinded = false;
            onIMServiceDisconnected();
        }

        @Override
        public void onServiceConnected(ComponentName name, IBinder iBinder) {
            Logger.i(TAG, " --> onServiceConnected");
            imServiceConnectorAIDL = IMServiceConnectorAIDL.Stub.asInterface(iBinder);
            isBinded = true;
            onIMServiceConnected(imServiceConnectorAIDL);
        }
    };

    public abstract void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL);

    public abstract void onIMServiceDisconnected();

    public boolean isBinded() {
        return isBinded;
    }

    public boolean bindService(Context ctx) {
        Logger.d(TAG, " --> bindService");

        Intent intent = new Intent();
        intent.setClass(ctx, IMService.class);

        if (!ctx.bindService(intent, imServiceConnection, android.content.Context.BIND_AUTO_CREATE)) {
            Logger.e(TAG, " --> bindService(imService) failed");
            return false;
        } else {
            Logger.i(TAG, " --> bindService(imService) ok");
            return true;
        }
    }

    public void unbindService(Context ctx) {
        Logger.d(TAG, " --> unbindService");
        try {
            ctx.unbindService(imServiceConnection);
        } catch (IllegalArgumentException exception) {
            Logger.e(TAG, " --> got exception becuase of unmatched bind/unbind, we sould place to onStop next version.e:" + exception.getMessage());
        }
        Logger.i(TAG, " --> unbindService ok");
    }

}
