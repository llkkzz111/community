package com.community.imsdk.utils;

import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.GroupInfo;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.GetGroupInfoAndMemberRequest;
import com.community.imsdk.imutils.SendMessageQueue;

import java.util.concurrent.Callable;

/**
 * Created by dufeng on 16/11/17.<br/>
 * Description: GetGroupInfoAndMemberCallable
 */

public class GetGroupInfoAndMemberCallable implements Callable<GroupInfo> {
    private static String TAG = "===GetGroupInfoAndMemberCallable===";

    private final Object lock = new Object();

    private long groupId;

    public GetGroupInfoAndMemberCallable(long groupId) {
        this.groupId = groupId;
    }

    @Override
    public GroupInfo call() throws Exception {
        synchronized (lock) {
            GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(groupId);
            if (groupInfo != null && !groupInfo.getIsKickOut()) {
                return groupInfo;
            } else {
                SendMessageQueue.getInstance().addSendMessage(MessageType.GET_GROUP_INFO_AND_MEMBER,
                        new GetGroupInfoAndMemberRequest(groupId));
                Logger.e(TAG, "groupId--" + groupId);
                lock.wait();
                return DBHelper.getInstance().queryUniqueGroupInfo(groupId);
            }
        }
    }

    public void notifyTask() {
        synchronized (lock) {
            lock.notify();
        }
    }
}
