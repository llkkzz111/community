package com.choudao.equity.broadcast;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.choudao.equity.GroupMessageActivity;
import com.choudao.equity.MainActivity;
import com.choudao.equity.PrivateMessageActivity;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.imsdk.dto.NotificationInfo;

/**
 * Created by dufeng on 16/6/30.<br/>
 * Description: NotificationClickReceiver
 */
public class NotificationClickReceiver extends BroadcastReceiver {

    public static final String TAG = "===NotificationClickReceiver===";
    public static final String MSG_ACTION = "com.choudao.equity.MSG_ACTION";


    @Override
    public void onReceive(Context context, Intent intent) {

        NotificationInfo info = (NotificationInfo) intent.getSerializableExtra("info");

        Intent actionIntent;
        switch (info.type) {
            case NotificationInfo.PRIVATE_MSG:
                actionIntent = new Intent(context, PrivateMessageActivity.class);
                actionIntent.putExtra(IntentKeys.KEY_TARGET_ID, (long) info.data.get(IntentKeys.KEY_TARGET_ID));
                actionIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                context.startActivity(actionIntent);
                break;
            case NotificationInfo.GROUP_MSG:
                actionIntent = new Intent(context, GroupMessageActivity.class);
                actionIntent.putExtra(IntentKeys.KEY_TARGET_ID, (long) info.data.get(IntentKeys.KEY_TARGET_ID));
                actionIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                context.startActivity(actionIntent);
                break;
            case NotificationInfo.NO_CONTENT_MSG:
                actionIntent = new Intent(context, MainActivity.class);
                actionIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                context.startActivity(actionIntent);
                break;
        }
    }
}
