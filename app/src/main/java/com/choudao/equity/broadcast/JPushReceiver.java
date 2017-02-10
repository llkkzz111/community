package com.choudao.equity.broadcast;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.choudao.equity.MainActivity;
import com.choudao.equity.WebViewActivity;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import cn.jpush.android.api.JPushInterface;


/**
 * 自定义接收器
 * <p/>
 * 如果不定义这个 Receiver，则：
 * 1) 默认用户会打开主界面
 * 2) 接收不到自定义消息
 */
public class JPushReceiver extends BroadcastReceiver {
    private static final String TAG = "JPush";
    private static String url = "";
    private static String action = "";
    private static int actionType = -1;
    private Context mContext;

    /**
     * 在正式使用时会替换掉 printBundle
     *
     * @param bundle
     */
    private static void getData(Bundle bundle) {
        action = "";
        actionType = -1;
        if (bundle.containsKey(JPushInterface.EXTRA_EXTRA)) {
            try {
                JSONObject json = new JSONObject(bundle.getString(JPushInterface.EXTRA_EXTRA));
                Iterator<String> it = json.keys();
                while (it.hasNext()) {
                    String myKey = it.next().toString();

                    if (IntentKeys.KEY_ACTION.equals(myKey)) {
                        action = json.optString(myKey);
                    }
                    if (IntentKeys.KEY_ACTION_TYPE.equals(myKey)) {
                        actionType = Integer.valueOf(json.optString(myKey));
                    }

                    if (IntentKeys.KEY_JPUSH_LINK.equals(myKey)) {
                        url = json.optString(myKey);
                    }
                }
            } catch (JSONException e) {
                Log.e(TAG, "Get message extra JSON error!");
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

    }


    @Override
    public void onReceive(Context context, Intent intent) {
        mContext = context;
        Bundle bundle = intent.getExtras();
        getData(bundle);
        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
            String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
            Log.d(TAG, "[MyReceiver] 接收Registration Id : " + regId);

        } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));

        } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 接收到推送下来的通知");
            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
            Log.d(TAG, "[MyReceiver] 接收到推送下来的通知的ID: " + notifactionId);

        } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 用户点击打开了通知");
            startNotificationActivity(bundle);

        } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
            //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..

        } else if (JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
            boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
            Log.w(TAG, "[MyReceiver]" + intent.getAction() + " connected state change to " + connected);
        } else {
            Log.d(TAG, "[MyReceiver] Unhandled intent - " + intent.getAction());
        }
    }

    private void startNotificationActivity(Bundle bundle) {
        //打开自定义的Activity
        Intent intent = new Intent();
        if (!TextUtils.isEmpty(url)) {
            intent.putExtra(IntentKeys.KEY_URL, url);
        }
        if (actionType != -1 && !action.isEmpty()) {
            intent.putExtra(IntentKeys.KEY_ACTION, action);
            intent.putExtra(IntentKeys.KEY_ACTION_TYPE, actionType);
        }
        intent.putExtra(IntentKeys.KEY_JPUSH_PUSH, true);
        if (TextUtils.isEmpty(url) || !Utils.isForeground(mContext, "com.choudao.equity")) {
            intent.setClass(mContext, MainActivity.class);
        } else {
            intent.setClass(mContext, WebViewActivity.class);
        }
        intent.putExtras(bundle);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);

        mContext.startActivity(intent);
        clear();
    }

    private void clear() {
        url = "";
        action = "";
        actionType = -1;
    }

}
