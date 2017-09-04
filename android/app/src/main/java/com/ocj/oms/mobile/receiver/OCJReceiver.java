package com.ocj.oms.mobile.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.google.gson.Gson;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.bean.ExtrasKey;
import com.ocj.oms.mobile.bean.NoticeExtraBean;
import com.ocj.oms.mobile.ui.LoadingActivity;
import com.ocj.oms.mobile.ui.rn.RouteConfigs;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.webview.WebViewActivity;
import com.ocj.oms.mobile.utils.HexUtils;
import com.orhanobut.logger.Logger;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import cn.jpush.android.api.JPushInterface;

/**
 * 自定义接收器
 * <p>
 * 如果不定义这个 Receiver，则：
 * 1) 默认用户会打开主界面
 * 2) 接收不到自定义消息
 */
public class OCJReceiver extends BroadcastReceiver {
    private static final String TAG = "JPush";
    private Context context;

    @Override
    public void onReceive(Context context, Intent intent) {
        this.context = context;
        try {
            Bundle bundle = intent.getExtras();
            Logger.d(TAG, "[OCJReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));

            if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
                String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
                Logger.d(TAG, "[OCJReceiver] 接收Registration Id : " + regId);
                //send the Registration Id to your server...

            } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
                Logger.d(TAG, "[OCJReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));
            } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
                Logger.d(TAG, "[OCJReceiver] 接收到推送下来的通知");
                int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
                Logger.d(TAG, "[OCJReceiver] 接收到推送下来的通知的ID: " + notifactionId);

            } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
                Logger.d(TAG, "[OCJReceiver] 用户点击打开了通知");
                if (bundle.containsKey(JPushInterface.EXTRA_EXTRA)) {
                    try {
                        String extrasKey = bundle.getString(JPushInterface.EXTRA_EXTRA);
                        ExtrasKey key = new Gson().fromJson(extrasKey, ExtrasKey.class);
                        if (key.getUrl()!=null){
                            if (key.getUrl().matches("^(http(s)?:\\/\\/)?[^.\\s!\\*'\\(\\);:@&=\\+\\$,\\/\\?#\\[\\]]*(\\.[^.\\s]*)+$")) {
                                startWebViewActivity(context, key);
                                return;
                            }
                        }
                        String aa = HexUtils.getFromBASE64(key.getExtraskey());
                        NoticeExtraBean bean = new Gson().fromJson(aa, NoticeExtraBean.class);
                        if (TextUtils.isEmpty(bean.getToPage())) {
                            return;
                        }

                        NoticeExtraBean.ParamKey paramKey = bean.getParams();
                        WritableMap param = Arguments.createMap();
                        WritableMap params = Arguments.createMap();
                        if (!TextUtils.isEmpty(paramKey.getId())) {
                            params.putString("id", paramKey.getId());
                        }

                        if (!TextUtils.isEmpty(paramKey.getUrl())) {
                            params.putString("url", paramKey.getUrl());
                        }

                        if (!TextUtils.isEmpty(paramKey.getOrderNo())) {
                            params.putString("orderNo", paramKey.getOrderNo());
                        }
                        RouterModule.invokePayResult(RouteConfigs.ResetToHome);

                        param.putMap("param", params);
                        param.putString("page", bean.getToPage());
                        RouterModule.sendNotificationToRN(param);
                    } catch (Exception e) {
                        startNotificationActivity(bundle);
                    }
                } else {
                    startNotificationActivity(bundle);
                }
            } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
                Logger.d(TAG, "[OCJReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
                //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..

            } else if (JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
                boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
                Logger.w(TAG, "[OCJReceiver]" + intent.getAction() + " connected state change to " + connected);
            } else {
                Logger.d(TAG, "[OCJReceiver] Unhandled intent - " + intent.getAction());
            }
        } catch (Exception e) {

        }

    }

    private void startWebViewActivity(Context context, ExtrasKey key) {
        Intent intent = new Intent();
        intent.setClass(context, WebViewActivity.class);
        intent.putExtra(IntentKeys.URL,key.getUrl());
        context.startActivity(intent);
    }

    private void startNotificationActivity(Bundle bundle) {
        Intent intent = new Intent();
        intent.setClass(context, LoadingActivity.class);
        context.startActivity(intent);
    }

    // 打印所有的 intent extra 数据
    private static String printBundle(Bundle bundle) {
        StringBuilder sb = new StringBuilder();
        for (String key : bundle.keySet()) {
            if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)) {
                sb.append("\nkey:" + key + ", value:" + bundle.getInt(key));
            } else if (key.equals(JPushInterface.EXTRA_CONNECTION_CHANGE)) {
                sb.append("\nkey:" + key + ", value:" + bundle.getBoolean(key));
            } else if (key.equals(JPushInterface.EXTRA_EXTRA)) {
                if (TextUtils.isEmpty(bundle.getString(JPushInterface.EXTRA_EXTRA))) {
                    Logger.i(TAG, "This message has no Extra data");
                    continue;
                }

                try {
                    JSONObject json = new JSONObject(bundle.getString(JPushInterface.EXTRA_EXTRA));
                    Iterator<String> it = json.keys();

                    while (it.hasNext()) {
                        String myKey = it.next().toString();
                        sb.append("\nkey:" + key + ", value: [" +
                                myKey + " - " + json.optString(myKey) + "]");
                    }
                } catch (JSONException e) {
                    Logger.e(TAG, "Get message extra JSON error!");
                }

            } else {
                sb.append("\nkey:" + key + ", value:" + bundle.getString(key));
            }
        }
        return sb.toString();
    }


}
