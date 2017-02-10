package com.choudao.equity.service;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.support.v4.app.NotificationCompat;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.choudao.equity.R;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseApplication;
import com.choudao.equity.broadcast.NotificationClickReceiver;
import com.choudao.equity.entity.UserInfoEntity;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.TextConverters;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.NotificationInfo;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.imutils.BaseManager;
import com.choudao.imsdk.utils.Logger;

import java.util.IdentityHashMap;
import java.util.Map;

import retrofit2.Call;

/**
 * Created by dufeng on 16/9/23.<br/>
 * Description: NotificationManager
 */

public class IMNotificationManager extends BaseManager {

    private final String TAG = "===IMNotificationManager===";
    private final int SHOW_MSG_NOTIFICATION = 1;
    private final int SHOW_PROMPT_NOTIFICATION = 2;
    private final int CHANGE_NOTIFY_ACTION = 3;
    private final int NEW_FRIEND_NOTIFICATION = 4;

    private boolean isNotifyAction = true;
    private Handler notifyHandler = new Handler() {

        public void handleMessage(android.os.Message msg) {
            NotificationInfo info = (NotificationInfo) msg.obj;
            switch (msg.what) {
                case SHOW_MSG_NOTIFICATION:
                    showMsgNotification(info);
                    break;
                case SHOW_PROMPT_NOTIFICATION:
                    showPromptNotification(info);
                    break;
                case NEW_FRIEND_NOTIFICATION:
                    showNewFriendNotification(info);
                    break;
                case CHANGE_NOTIFY_ACTION:
                    isNotifyAction = true;
                    break;
            }
        }
    };

    private NotificationManager notifyMgr;
    private Context context;

    private IMNotificationManager() {
    }

    private static IMNotificationManager instance;

    public static synchronized IMNotificationManager getInstance() {
        if (instance == null) {
            instance = new IMNotificationManager();
        }
        return instance;
    }

    public void setContext(Context context) {
        this.context = context;
    }


    /**
     * @param ppMessage
     */
    public void loadNotificationData(Message ppMessage) {
        Logger.e(TAG, "loadNotificationData -- isMsgActivityShow:" + BaseApplication.isMsgActivityShow);
        if (BaseApplication.isMsgActivityShow &&
                ppMessage.getChatId() == BaseApplication.nowChatId &&
                ppMessage.getSessionType() == BaseApplication.nowSessionType) {
            return;
        }
        switch (SessionType.of(ppMessage.getSessionType())) {
            case PRIVATE_CHAT:
                fillPrivateNotificationData(ppMessage);
                break;
            case GROUP_CHAT:
                fillGroupChatNotificationData(ppMessage);
                break;
            case FRIEND_REQUEST:
                fillNotificationData(ppMessage, null, null);
                break;
        }
    }

    private void fillGroupChatNotificationData(final Message ppMessage) {
        final UserInfo userinfo = DBHelper.getInstance().queryUniqueUserInfo(ppMessage.getSendUserId());
        if (userinfo != null) {
            ppMessage.setContent(userinfo.showName() + ":" + ppMessage.getContent());
            fillGroupNotificationData(ppMessage);
        } else {
            Map<String, Object> params = new IdentityHashMap<>();
            params.put("user_id", ppMessage.getChatId());
            ApiService service = ServiceGenerator.createService(ApiService.class);
            Call<UserInfoEntity> repos = service.getUserInfo(params);
            repos.enqueue(new BaseCallBack<UserInfoEntity>() {
                @Override
                protected void onSuccess(UserInfoEntity userInfoEntity) {
                    final UserInfo userInfo = Utils.userInfoEntityToUserInfo(userInfoEntity);
                    DBHelper.getInstance().saveUserInfo(userInfo);

                    ppMessage.setContent(userinfo.showName() + ":" + ppMessage.getContent());
                    fillGroupNotificationData(ppMessage);
                }

                @Override
                protected void onFailure(int code, String msg) {
                }
            });
        }
    }

    private void fillPrivateNotificationData(final Message ppMessage) {
        final UserInfo localUserInfo = DBHelper.getInstance().queryUniqueUserInfo(ppMessage.getSendUserId());
        if (localUserInfo != null) {//如果数据库里面没有这条记录就去拉

            fillNotificationData(ppMessage, localUserInfo.getHeadImgUrl(), localUserInfo.showName());

        } else {

            Map<String, Object> params = new IdentityHashMap<>();
            params.put("user_id", ppMessage.getChatId());
            ApiService service = ServiceGenerator.createService(ApiService.class);
            Call<UserInfoEntity> repos = service.getUserInfo(params);
            repos.enqueue(new BaseCallBack<UserInfoEntity>() {
                @Override
                protected void onSuccess(UserInfoEntity userInfoEntity) {
                    final UserInfo userInfo = Utils.userInfoEntityToUserInfo(userInfoEntity);
                    DBHelper.getInstance().saveUserInfo(userInfo);

                    fillNotificationData(ppMessage, userInfo.getHeadImgUrl(), userInfo.getName());
                }

                @Override
                protected void onFailure(int code, String msg) {
                }
            });
        }
    }

    private void fillGroupNotificationData(Message ppMessage) {
        GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(ppMessage.getChatId());
        if (groupInfo != null) {
            fillNotificationData(ppMessage, groupInfo.getHeadImgUrl(), groupInfo.showName());
        } else {
            //TODO 再拉一遍群信息？
        }
    }


    private void fillNotificationData(Message ppMessage, String imgUrl, String name) {
        if (PreferencesUtils.getMessagePromptState()) {
            if (PreferencesUtils.getNotifyDetailsState()) {

                NotificationInfo info = new NotificationInfo();
                android.os.Message msg = notifyHandler.obtainMessage();
                msg.obj = info;
                switch (SessionType.of(ppMessage.getSessionType())) {
                    case PRIVATE_CHAT:
                        info.type = NotificationInfo.PRIVATE_MSG;
                        info.imgUrl = imgUrl;
                        info.title = name;
                        info.content = ppMessage.getContent();
                        info.data.put(IntentKeys.KEY_TARGET_ID, ppMessage.getChatId());
                        msg.what = SHOW_MSG_NOTIFICATION;
                        notifyHandler.sendMessage(msg);
                        break;
                    case GROUP_CHAT:
                        info.type = NotificationInfo.GROUP_MSG;
                        info.imgUrl = imgUrl;
                        info.title = name;
                        info.content = ppMessage.getContent();
                        info.data.put(IntentKeys.KEY_TARGET_ID, ppMessage.getChatId());
                        msg.what = SHOW_MSG_NOTIFICATION;
                        notifyHandler.sendMessage(msg);
                        break;
                    case FRIEND_REQUEST:
                        info.type = NotificationInfo.NO_CONTENT_MSG;
                        msg.what = NEW_FRIEND_NOTIFICATION;
                        notifyHandler.sendMessage(msg);
                        break;
                }
            } else {
                NotificationInfo info = new NotificationInfo();
                info.type = NotificationInfo.NO_CONTENT_MSG;
                android.os.Message msg = notifyHandler.obtainMessage();
                msg.obj = info;
                msg.what = SHOW_PROMPT_NOTIFICATION;
                notifyHandler.sendMessage(msg);
            }
        }
    }

    private void showNewFriendNotification(NotificationInfo info) {
        showInNotificationBar(context.getString(R.string.app_name),
                "您收到一条好友请求",
                BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher),
                -2,
                info
        );
    }

    private void showPromptNotification(NotificationInfo info) {
        showInNotificationBar(context.getString(R.string.app_name),
                "您收到一条新消息",
                BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher),
                -1,
                info
        );
    }

    private void showMsgNotification(final NotificationInfo info) {
        Glide.with(context).load(info.imgUrl).bitmapTransform(new CropSquareTransformation(context)).into(new SimpleTarget<GlideDrawable>() {
            @Override
            public void onResourceReady(GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) {

                Drawable drawable = resource.getCurrent();
                Bitmap bitmap;
                if (drawable instanceof GifDrawable) {
                    bitmap = ((GifDrawable) drawable).getFirstFrame();
                } else {
                    GlideBitmapDrawable bd = (GlideBitmapDrawable) drawable.getCurrent();
                    bitmap = bd.getBitmap();
                }
                showInNotificationBar(info.title,
                        TextConverters.convertSysText(info.content),
                        bitmap,
                        (int) ((long) info.data.get(IntentKeys.KEY_TARGET_ID)),
                        info
                );
            }
        });
    }

    public void cancelNotificationById(String tag, int id) {
        if (notifyMgr != null) {
            notifyMgr.cancel(tag, id);
        }
    }

    public void cancelAllNotification() {
        if (notifyMgr != null) {
            notifyMgr.cancelAll();
        }
    }


    /**
     * 发送通知
     *
     * @param title
     * @param ticker
     * @param iconBitmap
     * @param notificationId
     * @param info
     */
    private void showInNotificationBar(String title, String ticker, Bitmap iconBitmap, int notificationId, NotificationInfo info) {
        Logger.d(TAG, "showInNotificationBar -> " + title + " -- " + ticker);

        notifyMgr = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (notifyMgr == null) {
            return;
        }


        NotificationCompat.Builder builder = new NotificationCompat.Builder(context);
        builder.setContentTitle(title);
        builder.setContentText(ticker);
        builder.setSmallIcon(R.drawable.ic_small_icon);
        builder.setTicker(ticker);
        builder.setWhen(System.currentTimeMillis());
        builder.setAutoCancel(true);


        if (isNotifyAction) {
            isNotifyAction = false;
            if (PreferencesUtils.getNotifyVibrateState()) {
                long[] vibrate = {0, 200, 250, 200};
                builder.setVibrate(vibrate);
            }
            if (PreferencesUtils.getNotifyVoiceState()) {
                builder.setDefaults(Notification.DEFAULT_SOUND);
            }
            android.os.Message msg = notifyHandler.obtainMessage();
            msg.what = CHANGE_NOTIFY_ACTION;
            notifyHandler.sendMessageDelayed(msg, 2000);
        }
        if (iconBitmap != null) {
            builder.setLargeIcon(iconBitmap);
        }


        Intent clickIntent = new Intent(context, NotificationClickReceiver.class);
        clickIntent.putExtra("info", info);
        clickIntent.setAction(NotificationClickReceiver.MSG_ACTION);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, notificationId, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        builder.setContentIntent(pendingIntent);
        Notification notification = builder.build();

        notifyMgr.notify(info.type, notificationId, notification);

    }

}
