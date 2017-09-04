package com.ocj.oms.mobile.utils;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.NotificationCompat;

import com.lzy.imagepicker.ImagePickerProvider;
import com.ocj.oms.mobile.R;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by liutao on 2017/7/6.
 */

public class NotificationUtils {

    private Context mContext;
    private String apkUrl;
    private String savePath;
    private String saveFileName;
    private int progress = 0;
    private int lastProgress = 0;

    private static final int DOWNLOADING = 1;
    private static final int DOWNLOADED = 2;
    private static final int DOWNLOAD_FAILED = 3;

    private boolean cancelFlag = false;
    private NotificationCompat.Builder builder;

    public NotificationUtils(Context context) {
        mContext = context;
    }

    public void sendNotification() {
        builder = new NotificationCompat.Builder(mContext);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setContentTitle("正在下载...");
        builder.setProgress(100, 0, false);
        builder.setOngoing(true);
        ((NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE)).notify(1, builder.build());
        downloadAPK();
    }

    public void setApkUrl(String apkUrl) {
        this.apkUrl = apkUrl;
    }

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case DOWNLOADING:
                    if (progress - lastProgress >= 1) {
                        builder.setProgress(100, progress, false);
                        lastProgress = progress;
                        ((NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE)).notify(1, builder.build());
                    }
                    break;
                case DOWNLOADED:
                    builder.setOngoing(false);
                    ((NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE)).cancel(1);
                    installApk(mContext, saveFileName);
                    cancelFlag = true;
                    break;
                case DOWNLOAD_FAILED:
                    builder.setOngoing(false);
                    builder.setContentTitle("下载失败");
                    builder.setProgress(100, progress, false);
                    ((NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE)).notify(1, builder.build());
                    cancelFlag = true;
                    break;
                default:
                    break;
            }
        }
    };


    private void downloadAPK() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    URL url = new URL(apkUrl);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.connect();

                    int length = conn.getContentLength();
                    InputStream is = conn.getInputStream();

                    savePath = "/sdcard/Download/" + "/updateAPK/";

                    File file = new File(savePath);
                    if (!file.exists()) {
                        file.mkdir();
                    }

                    saveFileName = savePath + "apkName.apk";

                    String apkFile = saveFileName;
                    File ApkFile = new File(apkFile);
                    FileOutputStream fos = new FileOutputStream(ApkFile);

                    int count = 0;
                    byte buf[] = new byte[1024];

                    do {
                        int numread = is.read(buf);
                        count += numread;
                        progress = (int) (((float) count / length) * 100);
                        //更新进度
                        mHandler.sendEmptyMessage(DOWNLOADING);
                        if (numread <= 0) {
                            //下载完成通知安装
                            mHandler.sendEmptyMessage(DOWNLOADED);
                            break;
                        }
                        fos.write(buf, 0, numread);
                    } while (!cancelFlag);

                    fos.close();
                    is.close();
                } catch (Exception e) {
                    mHandler.sendEmptyMessage(DOWNLOAD_FAILED);
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private boolean installApk(Context context, String filePath) {
        File file = new File(filePath);
        if (!file.exists() || !file.isFile() || file.length() <= 0) {
            return false;
        }
        Intent i = new Intent(Intent.ACTION_VIEW);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            i.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            Uri contentUri = ImagePickerProvider.getUriForFile(context, "com.ocj.oms.mobile.fileProvider", file);
            i.setDataAndType(contentUri, "application/vnd.android.package-archive");
        } else {
            i.setDataAndType(Uri.parse("file://" + filePath), "application/vnd.android.package-archive");
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        context.startActivity(i);
        return true;
    }

}
