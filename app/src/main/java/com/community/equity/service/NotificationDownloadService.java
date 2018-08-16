package com.community.equity.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import com.community.equity.utils.params.IntentKeys;

public class NotificationDownloadService extends Service {
    public NotificationDownloadService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        int id = intent.getIntExtra("id", -1);
        String filePath = intent.getStringExtra(IntentKeys.KEY_FILE_PATH);
        String downloadUrl = intent.getStringExtra(IntentKeys.KEY_DOWNLOAD_URL);
        NotificationUtil.notifyPtogressNotification(this, id, downloadUrl,filePath);
        return super.onStartCommand(intent, flags, startId);
    }
}
