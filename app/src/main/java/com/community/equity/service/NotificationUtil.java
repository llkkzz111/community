package com.community.equity.service;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationCompat.Builder;

import com.community.equity.R;
import com.community.equity.utils.PackageUtils;
import com.community.equity.utils.params.ProgressAsyncTask;

public class NotificationUtil {

    private static NotificationManager nm;
    private String URL = "http://app.qndn.qingju.com/community_v2.0.0_2016_07_21.apk";
    private static final String TITLE = "更新提示";

    public static void notifyPtogressNotification(Context context, int notifyId, String url, String filePath) {
        if (nm == null) {
            nm = (NotificationManager) context
                    .getSystemService(Context.NOTIFICATION_SERVICE);
        }
        final Builder mBuilder = new NotificationCompat.Builder(context);

        Intent intent = PackageUtils.initInstall(filePath);
        PendingIntent pi = PendingIntent.getActivity(context, 0, intent,
                PendingIntent.FLAG_CANCEL_CURRENT);
        mBuilder.setContentIntent(pi);
        mBuilder.setContentTitle(TITLE).setContentText("下载进度：");
        setNotificationIcon(context, mBuilder);


        new ProgressAsyncTask(url, filePath, nm, mBuilder, notifyId)
                .execute();
    }

    /**
     * 设置Notification的icon,<br>
     * 如果不设置图标则无法显示Notification,并且LargeIcon,SmallIcon都需要设置
     *
     * @param context
     * @param mBuilder
     */
    private static void setNotificationIcon(Context context,
                                            final Builder mBuilder) {
        // 如果不设置小图标则无法显示Notification
        mBuilder.setLargeIcon(BitmapFactory.decodeResource(
                context.getResources(), R.mipmap.ic_launcher));
        mBuilder.setSmallIcon(R.mipmap.ic_launcher);
    }

}
