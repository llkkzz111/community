package com.choudao.imsdk.imutils;

import android.database.sqlite.SQLiteException;

import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.IMApplication;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.constants.ChangeLogType;
import com.choudao.imsdk.dto.constants.ContentType;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.PullType;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.dto.push.ChangeLogContent;
import com.choudao.imsdk.dto.push.GroupKickOutInfoContent;
import com.choudao.imsdk.dto.request.PullMessageRequest;
import com.choudao.imsdk.utils.DefaultThreadFactory;
import com.choudao.imsdk.utils.GroupInfoRequestUtils;
import com.choudao.imsdk.utils.Logger;
import com.choudao.imsdk.utils.UserInfoProvider;

import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by dufeng on 16/11/1.<br/>
 * Description: MessageContentUtils
 */

public class MessageContentUtils {

    private static final String TAG = "===MessageContentUtils===";


    private static ThreadPoolExecutor threadPool = new ThreadPoolExecutor(2, 4, 3, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(200),
            new DefaultThreadFactory("MessageContent"), new ThreadPoolExecutor.CallerRunsPolicy());

    private static ThreadLocal<Boolean> threadTracePullBefore = new ThreadLocal<>();
    private static ThreadLocal<Message[]> threadTraceMessages = new ThreadLocal<>();

    public static void transformArray(final Message[] beforeArrayMessage, Message[] afterArrayMessage) {
        final String traceId = Logger.getTraceId();
        final Message[] arrayMessage;
        if (afterArrayMessage == null) {
            arrayMessage = beforeArrayMessage;
        } else {
            arrayMessage = new Message[beforeArrayMessage.length + afterArrayMessage.length];
            System.arraycopy(beforeArrayMessage, 0, arrayMessage, 0, beforeArrayMessage.length);
            System.arraycopy(afterArrayMessage, 0, arrayMessage, beforeArrayMessage.length, arrayMessage.length - beforeArrayMessage.length);
        }
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Logger.setTraceId(traceId);
                threadTraceMessages.set(arrayMessage);
                threadTracePullBefore.set(false);
                for (Message message : arrayMessage) {
                    Boolean flag = threadTracePullBefore.get();
                    if (flag) {//有断层要拉取
                        Logger.e(TAG, " -> transformArray 触发熔断机制");
                        return;
                    }
                    transformTask(message);
                }
            }
        };
        threadPool.execute(runnable);
    }

    /**
     * @param message
     */
    public static void transform(final Message message) {
        final String traceId = Logger.getTraceId();
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Logger.setTraceId(traceId);
                threadTraceMessages.set(new Message[]{message});
                transformTask(message);
            }
        };
        threadPool.execute(runnable);

    }

    private static void transformTask(Message message) {
        switch (SessionType.of(message.getSessionType())) {
            case GROUP_CHAT:
                GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(message.getChatId());
                if (groupInfo == null || groupInfo.getIsKickOut()) {
                    loadGroupInfo(message.getChatId());
                }
                break;
            case PERSONAL_GROUP_NOTICE:
                if (message.getContentType() == ContentType.GROUP_KICK_OUT_INFO.code) {
                    GroupKickOutInfoContent groupKickOutContent = JSON.parseObject(message.getSrcContent(), GroupKickOutInfoContent.class);
                    groupKickOut(message, groupKickOutContent);
                }
                break;
            case GROUP_MEMBER_CHANGE_LOG:
                if (message.getContentType() == ContentType.CHANGE_LOG.code) {
                    ChangeLogContent changeLogContent = JSON.parseObject(message.getSrcContent(), ChangeLogContent.class);
                    groupMemberChange(message, changeLogContent);
                }
                break;
            case GROUP_INFO_CHANGE_LOG:
                if (message.getContentType() == ContentType.CHANGE_LOG.code) {
                    ChangeLogContent changeLogContent = JSON.parseObject(message.getSrcContent(), ChangeLogContent.class);
                    groupInfoChange(message, changeLogContent);
                }
                break;
        }
    }

    private static void groupMemberChange(Message message, ChangeLogContent changeLogContent) {
        List<Long> userIds = JSON.parseArray(changeLogContent.getData(), Long.class);
        switch (ChangeLogType.of(changeLogContent.getType())) {
            case ADD_GROUP_MEMBER:
                addGroupMembers(message, userIds);
                break;
            case DELETE_GROUP_MEMBER:
                deleteGroupMembers(message, userIds);
                break;
        }

    }

    /** ================================ 添加群成员 ================================ */

    /**
     * 添加新成员到群成员表
     *
     * @param message
     * @param addUserIdList
     */
    private static void addGroupMembers(Message message, List<Long> addUserIdList) {
        long groupId = message.getChatId();
        int version = (int) message.getMsgId();
        try {
            int rowCount = DBHelper.getInstance().updateGroupMemberCount(groupId, version, addUserIdList.size());//更新群成员数量、群成员version
            if (rowCount > 0) {
                DBHelper.getInstance().addGroupMembers(groupId, addUserIdList);
                saveAddMemberMessage(message, addUserIdList);
            } else {//更新失败，可能没有groupInfo，可能群成员version不连续
                if (checkCanContinueRun(groupId, SessionType.GROUP_MEMBER_CHANGE_LOG, version)) {
                    saveAddMemberMessage(message, addUserIdList);
                }
            }
        } catch (SQLiteException e) {
            Logger.e(TAG, "addGroupMembers -- " + e.getMessage());
        }
    }

    /**
     * 生成local信息并入库
     */
    private static void saveAddMemberMessage(Message message, List<Long> addUserIdList) {
        long sponsor = message.getSendUserId();
        addUserIdList.add(sponsor);//检查不存在的userInfo时将操作者也加入检查列表里
        UserInfoProvider.checkAndLoadUserInfos(addUserIdList);
        addUserIdList.remove(sponsor);
        StringBuilder localMsgBuilder = new StringBuilder();
        if (sponsor == IMApplication.userId) {
            localMsgBuilder.append("你邀请");
        } else {
            localMsgBuilder.append("\"").append(DBHelper.getInstance().queryUniqueUserInfo(sponsor).showName()).append("\"邀请");
        }

        //移除操作者
        addUserIdList.remove(sponsor);

        if (addUserIdList.contains(IMApplication.userId)) {
            localMsgBuilder.append("你");
            addUserIdList.remove(IMApplication.userId);
            if (addUserIdList.size() > 0) {
                localMsgBuilder.append("和\"").append(TransformUtils.createLocalNameByIds(addUserIdList)).append("\"");
            }
        } else {
            localMsgBuilder.append("\"").append(TransformUtils.createLocalNameByIds(addUserIdList)).append("\"");
        }
        localMsgBuilder.append("加入了群聊");

        String localMsg = localMsgBuilder.toString();
        Logger.i(TAG, "saveAddMemberMessage -- " + localMsg);
        createGroupLocalMessage(message, localMsg);
        IMMessageDispatcher.onSuccess(MessageType.LOCAL_GROUP_MEMBER_CHANGED, null, message.getChatId());
    }


    /** ================================ 添加群成员 ================================ */

    /** ================================ 删除群成员 ================================ */

    private static void deleteGroupMembers(Message message, List<Long> deleteUserIdList) {
        long groupId = message.getChatId();
        int version = (int) message.getMsgId();
        try {
            int rowCount = DBHelper.getInstance().updateGroupMemberCount(groupId, version, -deleteUserIdList.size());//更新群成员数量、群成员version
            if (rowCount > 0) {
                DBHelper.getInstance().deleteGroupMembers(groupId, deleteUserIdList);
                saveDeleteMemberMessage(message, deleteUserIdList);
            } else {//更新失败，可能没有groupInfo，可能群成员version不连续
                if (checkCanContinueRun(groupId, SessionType.GROUP_MEMBER_CHANGE_LOG, version)) {
                    saveDeleteMemberMessage(message, deleteUserIdList);
                }
            }
        } catch (SQLiteException e) {
            Logger.e(TAG, "deleteGroupMembers -- " + e.getMessage());
        }
    }

    private static void saveDeleteMemberMessage(Message message, List<Long> deleteUserIdList) {
        long sponsor = message.getSendUserId();
        if (sponsor == IMApplication.userId && !deleteUserIdList.contains(IMApplication.userId)) {//自己是操作者且不是自己退群
            String localMsg = "你将\"" +
                    TransformUtils.createLocalNameByIds(deleteUserIdList) +
                    "\"移出了群聊";
            Logger.i(TAG, "createDeleteMemberMessage -- " + localMsg);
            createGroupLocalMessage(message, localMsg);
        } else {
            message.setSendStatus(Message.SUCCESS);
            DBHelper.getInstance().saveMessage(message);
        }
        IMMessageDispatcher.onSuccess(MessageType.LOCAL_GROUP_MEMBER_CHANGED, null, message.getChatId());
    }


    /** ================================ 删除群成员 ================================ */


    /** ================================ 被移出群聊 ================================ */


    private static void groupKickOut(Message message, GroupKickOutInfoContent groupKickOutContent) {

        long sponsorId = groupKickOutContent.getUserId();
        UserInfo sponsorInfo = DBHelper.getInstance().queryUniqueUserInfo(sponsorId);
        if (sponsorInfo == null) {
            sponsorInfo = UserInfoProvider.loadNormalUserInfos(String.valueOf(sponsorId)).get(0);
        }
        saveGroupKickOutMessage(message, sponsorInfo);
    }

    private static void saveGroupKickOutMessage(Message message, UserInfo sponsorInfo) {

        String localMsg = "你被\""
                + sponsorInfo.showName()
                + "\"移出了群聊";
        int rowCount = DBHelper.getInstance().setGroupInfoKickOut(message.getChatId(), true);
        if (rowCount > 0) {
            createGroupLocalMessage(message, localMsg);
            IMMessageDispatcher.onSuccess(MessageType.LOCAL_GROUP_KICK_OUT, null, message.getChatId());
        }

    }

    /** ================================ 被移出群聊 ================================ */

    /** ================================ 群信信息变更 ================================ */


    private static void groupInfoChange(Message message, final ChangeLogContent logContent) {
        long groupId = message.getChatId();
        int version = (int) message.getMsgId();
        String noticeData = null;
        int rowCount = 0;
        switch (ChangeLogType.of(logContent.getType())) {
            case UPDATE_GROUP_NAME:
                rowCount = DBHelper.getInstance().updateGroupName(groupId, logContent.getData(), version);
                break;
            case UPDATE_GROUP_NOTICE:
                rowCount = DBHelper.getInstance().updateGroupNotice(groupId, logContent.getData(), version);
                noticeData = logContent.getData();
                break;
            case UPDATE_GROUP_HOLDER:
                rowCount = DBHelper.getInstance().updateGroupHolder(groupId, logContent.getData(), version);
                break;
        }
        if (rowCount > 0) {
            saveGroupInfoChangeMessage(message, logContent);
        } else {//更新失败，可能没有groupInfo，可能version不连续
            if (checkCanContinueRun(groupId, SessionType.GROUP_INFO_CHANGE_LOG, version)) {
                saveGroupInfoChangeMessage(message, logContent);
                if (noticeData != null) {
                    DBHelper.getInstance().updateGroupShowNotice(groupId, true);
                }
            }
        }

    }

    private static void saveGroupInfoChangeMessage(Message message, ChangeLogContent logContent) {
        switch (ChangeLogType.of(logContent.getType())) {
            case UPDATE_GROUP_NAME:
                long sponsorId = message.getSendUserId();
                UserInfo sponsorInfo = DBHelper.getInstance().queryUniqueUserInfo(sponsorId);
                if (sponsorInfo == null) {
                    sponsorInfo = UserInfoProvider.loadNormalUserInfos(String.valueOf(sponsorId)).get(0);
                }
                String name = sponsorInfo.getUserId() == IMApplication.userId ? "你" : "\"" + sponsorInfo.showName() + "\"";
                createGroupLocalMessage(message, name + "修改群名称为\"" + logContent.getData() + "\"");
                break;
            case UPDATE_GROUP_NOTICE:
//                createGroupLocalMessage(message, name + "更改了群公告");
            case UPDATE_GROUP_HOLDER:
                message.setSendStatus(Message.SUCCESS);
                DBHelper.getInstance().saveMessage(message);
                break;
        }
        IMMessageDispatcher.onSuccess(MessageType.LOCAL_GROUP_INFO_CHANGED, null, message.getChatId());
    }

    /** ================================ 群信信息变更 ================================ */

    /**
     * 检查群信息状态，判断是否拉全量
     *
     * @param groupId
     * @return groupInfoVersion，-1 异常状态，拉全量
     */
    private static GroupInfo loadGroupInfo(long groupId) {
        try {
            return GroupInfoRequestUtils.getGroupInfo(groupId);
        } catch (ExecutionException | InterruptedException e) {
            Logger.e(TAG, "loadGroupInfo--", e);
            return null;
        }
    }

    /**
     * 检查是否可以处理更新成功后的事情，并做相关准备
     *
     * @param groupId
     * @param sessionType
     * @param msgVersion
     * @return
     */
    private static boolean checkCanContinueRun(long groupId, SessionType sessionType, int msgVersion) {
        GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(groupId);
        if (groupInfo == null || groupInfo.getIsKickOut()) {//没有groupInfo
            if (loadGroupInfo(groupId) != null) {
                return true;
            }
        } else {//version不连续
            if (!pullBeforeChangeLog(groupId, sessionType, msgVersion, groupInfo)) {//version比数据库里的小，不用拉取
                return true;
            }
        }
        return false;
    }


    /**
     * 拉取之前断掉的记录
     *
     * @param groupId
     * @param msgVersion
     * @param oldGroupInfo 这里的groupInfo不一定就是老的，有可能更新（之前可能拉过全量）
     * @return 是否有断掉的记录需要拉取
     */
    private static boolean pullBeforeChangeLog(long groupId, SessionType sessionType, int msgVersion, GroupInfo oldGroupInfo) {

        int oldVersion = 0;
        switch (sessionType) {
            case GROUP_MEMBER_CHANGE_LOG:
                oldVersion = oldGroupInfo.getMemberVersion();
                break;
            case GROUP_INFO_CHANGE_LOG:
                oldVersion = oldGroupInfo.getInfoVersion();
                break;
        }

        int count = msgVersion - oldVersion;
        if (count > 2) {
            SendMessageQueue.getInstance().addSendMessage(MessageType.PULL_MESSAGE,
                    new PullMessageRequest(
                            groupId,
                            sessionType.code,
                            PullType.HISTORY.code,
                            oldVersion + 1,
                            msgVersion - 1,
                            count - 1,
                            threadTraceMessages.get()
                    ));
            threadTracePullBefore.set(true);
            return true;
        }
        return false;
    }

    private static void createGroupLocalMessage(Message message, String localMsg) {
        message.setContent(localMsg);
        message.setSendStatus(Message.SUCCESS);
        TransformUtils.saveSendMessage(message, SessionType.GROUP_CHAT.code, ContentType.LOCAL.code, 0);
    }

}
