package com.community.imsdk.imutils;

import android.database.sqlite.SQLiteException;

import com.community.imsdk.IMApplication;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Contact;
import com.community.imsdk.db.bean.GroupInfo;
import com.community.imsdk.db.bean.Message;
import com.community.imsdk.db.bean.SessionConfig;
import com.community.imsdk.db.bean.SessionInfo;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.constants.ContentType;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.PullType;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.constants.UserType;
import com.community.imsdk.dto.push.MessagesBean;
import com.community.imsdk.dto.request.AckOfflineRecordRequest;
import com.community.imsdk.dto.request.GetGroupInfoAndMemberRequest;
import com.community.imsdk.dto.request.GetGroupInfoRequest;
import com.community.imsdk.dto.request.MessageAckRequest;
import com.community.imsdk.dto.request.PullGroupMemberRequest;
import com.community.imsdk.dto.request.PullMessageRequest;
import com.community.imsdk.dto.request.SendMessageRequest;
import com.community.imsdk.dto.response.GetGroupInfoAndMemberResponse;
import com.community.imsdk.dto.response.GetGroupInfoResponse;
import com.community.imsdk.dto.response.PullFriendListResponse;
import com.community.imsdk.dto.response.PullGroupMemberResponse;
import com.community.imsdk.dto.response.PullMessageResponse;
import com.community.imsdk.dto.response.PullOfflineRecordResponse;
import com.community.imsdk.dto.response.PullSessionConfigResponse;
import com.community.imsdk.utils.Logger;
import com.community.imsdk.utils.UserInfoProvider;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

/**
 * Created by dufeng on 16/5/31.<br/>
 * Description: 传输数据的转换工具类，顺便入库
 */
public class TransformUtils {

    private static final String TAG = "===TransformUtils===";
    private static List<Contact> contactList;

    /**
     * 根据sessionTyp和contentType决定消息怎么展示
     * 用于填充showSessionType和showType
     *
     * @param content
     * @param message
     */
    private static void fullMessage(String content, Message message) {
        switch (SessionType.of(message.getSessionType())) {
            case PRIVATE_CHAT:
            case GROUP_CHAT:
            case FRIEND_REQUEST:
                message.setContent(content);
                message.setSendStatus(Message.SUCCESS);
                message.setShowSessionType(message.getSessionType());
                break;
            case PERSONAL_GROUP_NOTICE:
            case GROUP_MEMBER_CHANGE_LOG:
            case GROUP_INFO_CHANGE_LOG:
                message.setSrcContent(content);
                message.setSendStatus(Message.NEED_CONVERT);
                message.setShowSessionType(SessionType.GROUP_CHAT.code);
                break;
        }
        switch (ContentType.of(message.getContentType())) {
            case TEXT:
            case FRIEND_REQUEST:
                message.setShowType(ContentType.TEXT.code);
                break;
            case LOCAL:
            case CHANGE_LOG:
            case GROUP_KICK_OUT_INFO:
                message.setShowType(ContentType.LOCAL.code);
                break;
            case UNKNOWN:
                message.setShowType(message.getContentType());
                break;
        }
    }

    public static Message savePushMessage(MessagesBean pp) {

//        if (pp.getFrom() == pp.getTargetId()) {
//            return null;
//        }

        /**添加到消息表*/
        Message message = new Message();
        int sessionTypeCode = pp.getSessionType();
        if (!changeMessageInfo(sessionTypeCode, pp.getFrom(), pp.getTo(), message)) {
            return null;
        }
        message.setSendUserId(pp.getFrom());
        message.setContentType(pp.getContentType());
        message.setSessionType(pp.getSessionType());
        message.setMsgId(pp.getMsgId());
        message.setTimestamp(pp.getTimestamp());
        fullMessage(pp.getContent(), message);


        /**更新会话表*/
        SessionInfo sessionInfo = new SessionInfo();
        sessionInfo.setTargetId(message.getChatId());
        sessionInfo.setSessionType(message.getSessionType());
        if (sessionInfo.getTargetId() == IMApplication.nowChatId &&
                sessionInfo.getSessionType() == IMApplication.nowSessionType) {
            sessionInfo.setCount(0);
        } else {
            sessionInfo.setCount(1);
        }
        sessionInfo.setLastMessage(message.showTextContent());
        sessionInfo.setLastMessageId(message.getMsgId());
        sessionInfo.setLastTime(message.getTimestamp());

        try {
            showGroupLastMsgName(sessionInfo, pp.getFrom());
            DBHelper.getInstance().saveMessage(message, sessionInfo);
        } catch (SQLiteException e) {
            Logger.e(TAG, "savePushMessage: " + e.getMessage());
            return null;
        } catch (Exception e) {
            Logger.e(TAG, "savePushMessage: " + e.getMessage());
            return null;
        }

        SendMessageQueue.getInstance().addSendMessage(MessageType.ACK_MESSAGE,
                new MessageAckRequest(message.getChatId(),
                        message.getSessionType(),
                        pp.getMsgId()));
        MessageContentUtils.transform(message);
        return message;
    }

    /**
     * 发送回执的处理
     *
     * @param spRequest  发送的request
     * @param msgId      服务器返回的msgId，如果为-1则是发送失败的，不更新msgId
     * @param sendStatus 发送状态
     * @return
     */
    public static Message updateMessage(SendMessageRequest spRequest, long msgId, int sendStatus) {
        long localMsgId = Long.valueOf(spRequest.getExtra());
        Message message = DBHelper.getInstance().queryUniquePrivateMsg(spRequest.getTargetId(), spRequest.getSessionType(), localMsgId);
        if (message != null) {
            if (msgId != -1) {
                message.setMsgId(msgId);
            }
            message.setSendStatus(sendStatus);
            saveSendMessage(message);
        } else {
            Logger.e(TAG, "------privateMessage is null------");
        }
        return message;
    }

    public static SessionInfo saveSendMessage(Message message) {
        return saveSendMessage(message, message.getSessionType(), message.getContentType(), 0);
    }

    public static SessionInfo saveSendMessage(Message message, int showSessionType, int showType, int count) {
        message.setShowSessionType(showSessionType);
        message.setShowType(showType);

        String strSendStatus = "";
        switch (message.getSendStatus()) {
            case Message.SENDING:
                strSendStatus = "(发送中)";
                break;
            case Message.SEND_FAIL:
                strSendStatus = "(发送失败)";
                break;
        }

        /**更新会话表*/
        SessionInfo sessionInfo = new SessionInfo();
        sessionInfo.setTargetId(message.getChatId());
        sessionInfo.setSessionType(showSessionType);
        sessionInfo.setCount(count);
        sessionInfo.setLastMessage(strSendStatus + message.showTextContent());
        sessionInfo.setLastMessageId(message.getMsgId());
        sessionInfo.setLastTime(message.getTimestamp());

        try {
            DBHelper.getInstance().saveMessage(message, sessionInfo);
        } catch (SQLiteException e) {
            Logger.e(TAG, "saveSendMessage: ", e);
        }

        return sessionInfo;
    }

    /**
     * 转换离线会话
     */
    public static void saveOfflineRecords(List<PullOfflineRecordResponse.RecordBean> sessionsBeanList) {
        for (PullOfflineRecordResponse.RecordBean sessionsBean : sessionsBeanList) {

            //倒着拉取时endIndex应该是firstMsgId
            SendMessageQueue.getInstance().addSendMessage(MessageType.PULL_MESSAGE,
                    new PullMessageRequest(
                            sessionsBean.getTargetId(),
                            sessionsBean.getSessionType(),
                            PullType.OFFLINE.code,
                            sessionsBean.getLastMsgId(),
                            sessionsBean.getFirstMsgId(),
                            -sessionsBean.getCount(),
                            sessionsBean.getId()
                    ));
        }
    }

    /**
     * @param sessionTypeCode
     * @param sourceId
     * @param targetId
     * @param message
     * @return 是否可以处理的消息
     */
    private static boolean changeMessageInfo(int sessionTypeCode, long sourceId, long targetId, Message message) {
        switch (SessionType.of(sessionTypeCode)) {
            case PRIVATE_CHAT:
                if (sourceId == IMApplication.userId) {//发送者是自己说明是多设备同步
                    message.setChatId(targetId);
                } else {
                    message.setChatId(sourceId);
                }
                break;
            case GROUP_CHAT:
                message.setChatId(targetId);//groupId
                break;
            case FRIEND_REQUEST:
                message.setChatId(sourceId);//发送者的userId
                break;
            case PERSONAL_GROUP_NOTICE:
                message.setChatId(sourceId);//groupId 属于哪个群的通知
                break;
            case GROUP_MEMBER_CHANGE_LOG:
                message.setChatId(targetId);//groupId 属于哪个群的成员变动
                break;
            case GROUP_INFO_CHANGE_LOG:
                message.setChatId(targetId);//groupId 属于哪个群的信息变动
                break;
            case UNKNOWN:
                return false;
        }

        return true;
    }

    /**
     * 拉取消息
     *
     * @param fpRequest
     * @param fpResponse
     */
    public static List<Message> savePullMessage(PullMessageRequest fpRequest, PullMessageResponse fpResponse) {

        List<Message> messageList = new ArrayList<>();
        for (MessagesBean messagesBean : fpResponse.getMessages()) {
            /**添加到消息表*/
            Message message = new Message();
            int sessionTypeCode = messagesBean.getSessionType();
            if (!changeMessageInfo(sessionTypeCode, messagesBean.getFrom(), messagesBean.getTo(), message)) {
                continue;
            }
            message.setSendUserId(messagesBean.getFrom());
            message.setContentType(messagesBean.getContentType());
            message.setSessionType(sessionTypeCode);
            message.setMsgId(messagesBean.getMsgId());
            message.setTimestamp(messagesBean.getTimestamp());
            fullMessage(messagesBean.getContent(), message);
            messageList.add(message);
        }
        if (messageList.size() == 0) {
            return messageList;
        }
        //不在这里做了，count数在插入时按插入成功的message条数算
//        int msgCount = messageList.size();
//        SessionInfo updateSessionInfo = fpRequest.loadRecordSessionInfo();
//        updateSessionInfo.setCount(msgCount);

        //排序以便找到非连续的msgId,按照msgId正序排
        Message[] arrayMessage = messageList.toArray(new Message[messageList.size()]);
        Arrays.sort(arrayMessage, new Comparator<Message>() {
            @Override
            public int compare(Message o1, Message o2) {
                return o1.getMsgId() > o2.getMsgId() ? 1 : -1;
            }
        });
        MessageContentUtils.transformArray(arrayMessage, fpRequest.loadAfterMessage());
        //存储消息和会话
        try {

            if (fpRequest.loadAckId() != -1) {//是离线消息
                Message lastMessage = arrayMessage[arrayMessage.length - 1];
                SessionInfo recordSessionInfo = new SessionInfo();
                recordSessionInfo.setTargetId(lastMessage.getChatId());
                recordSessionInfo.setSessionType(lastMessage.getSessionType());
                recordSessionInfo.setLastMessage(lastMessage.showTextContent());
                recordSessionInfo.setLastMessageId(lastMessage.getMsgId());
                recordSessionInfo.setLastTime(lastMessage.getTimestamp());

                showGroupLastMsgName(recordSessionInfo, lastMessage.getSendUserId());
                DBHelper.getInstance().saveMessageList(messageList, recordSessionInfo);
            } else {//sessionInfo为null说明是单独拉取的不需要给ack，这里可以直接返回了
                DBHelper.getInstance().saveMessageList(messageList);
                return messageList;
            }
        } catch (SQLiteException e) {
            Logger.e(TAG, "savePullMessage: " + e.getMessage());
            return null;
        }


        //如果第一条丢失就不发送receive
        long endContinuousMsgId = fpRequest.getEndIndex();
        if (arrayMessage.length > 0 && endContinuousMsgId == arrayMessage[0].getMsgId()) {

            //找出连续消息的最后一个msgId
            for (int i = 1; i < arrayMessage.length; i++) {
                Message msg = arrayMessage[i];
                if (endContinuousMsgId + 1 != msg.getMsgId()) {
                    break;
                }
                endContinuousMsgId = msg.getMsgId();
            }

            //连续msgId条数
            long continuousCount = endContinuousMsgId - fpRequest.getEndIndex() + 1;
            SendMessageQueue.getInstance().addSendMessage(MessageType.ACK_OFFLINE_RECORD,
                    new AckOfflineRecordRequest(
                            fpRequest.loadAckId(),
                            continuousCount, endContinuousMsgId));
        }
        return messageList;

    }

    /**
     * 给群session的展示消息加上名字
     *
     * @param sessionInfo
     * @param sendUserId
     */
    private static void showGroupLastMsgName(SessionInfo sessionInfo, Long sendUserId) {
        if (sessionInfo.getSessionType() == SessionType.GROUP_CHAT.code) {
            UserInfo userInfo = DBHelper.getInstance().queryUniqueUserInfo(sendUserId);
            if (userInfo == null) {
                List<UserInfo> infoList = UserInfoProvider.loadNormalUserInfos(String.valueOf(sendUserId));
                if (infoList.size() > 0)
                    userInfo = infoList.get(0);
            }
            if (userInfo != null)
                sessionInfo.setLastMessage(userInfo.showName() + ":" + sessionInfo.getLastMessage());
        }
    }

    public static void saveSessionConfigs(List<PullSessionConfigResponse.ConfigBean> configList) {
        for (PullSessionConfigResponse.ConfigBean configRequest : configList) {
            SessionConfig sessionConfig = new SessionConfig();
            sessionConfig.setTargetId(configRequest.getTargetId());
            sessionConfig.setSessionType(configRequest.getSessionType());
            sessionConfig.setIsMute(configRequest.isMute());
            sessionConfig.setIsTop(configRequest.isTop());
            DBHelper.getInstance().saveSessionConfig(sessionConfig);
        }
    }

    public static void saveFriendList(PullFriendListResponse pflResponse) {
        List<PullFriendListResponse.FriendsBean> friendsBeanList = pflResponse.getFriends();
        long index = pflResponse.showMinId();
        if (contactList == null) {
            contactList = new ArrayList<>();
        }
        for (PullFriendListResponse.FriendsBean friendsBean : friendsBeanList) {
            if (friendsBean.getFriendUserId() != IMApplication.userId) {
                Contact contact = new Contact();
                contact.setUserId(friendsBean.getFriendUserId());
                contact.setUserType(friendsBean.getFriendUserType());
                contact.setRemark(friendsBean.getRemark());
                contact.setCreateTime(friendsBean.getCreateTime());
                contactList.add(contact);
            }
        }
        if (friendsBeanList.size() == IMMessageManager.BIG_COUNT && index > 1) {
            IMMessageManager.getInstance().sendPullFriendsList(index - 1);
        } else {
            try {
                //保存联系人信息
                DBHelper.getInstance().replaceUserList(contactList);

            } catch (SQLiteException e) {
                Logger.e(TAG, e.getMessage());
            } finally {
                contactList = null;
            }
            pflResponse.getFriends().add(new PullFriendListResponse.FriendsBean(IMApplication.userId, UserType.NORMAL.code));
        }
    }

    public static void saveNoFriendMessage(long groupId, List<Long> allUserIds, List<Long> addUserIds) {

        allUserIds.removeAll(addUserIds);
        if (allUserIds.size() > 0) {
            String content = "你和" + createLocalNameByIds(allUserIds) + "不是双向好友，请先添加好友";
            Message message = new Message();
            message.setChatId(groupId);
            message.setSendUserId(groupId);
            message.setTimestamp(System.currentTimeMillis());
            message.setContent(content);
            message.setContentType(ContentType.LOCAL.code);
            message.setSessionType(SessionType.GROUP_CHAT.code);
            message.setMsgId(-message.getTimestamp());
            message.setSendStatus(Message.SUCCESS);
            saveSendMessage(message);
        }

    }

    public static String createLocalNameByIds(List<Long> userIds) {
        String localName = "";
        for (long userId : userIds) {
            UserInfo userInfo = DBHelper.getInstance().queryUniqueUserInfo(userId);
            localName += userInfo.showName() + "、";
        }
        if (localName.length() > 0) {
            localName = localName.substring(0, localName.length() - 1);
        }
        Logger.i(TAG, "createLocalNameByIds -- " + localName);
        return localName;
    }

    public static String createGroupLocalName(long groupId) {
        String localName = "";
        List<UserInfo> memberInfos = DBHelper.getInstance().queryGroupMemberInfo(groupId, false);
        for (UserInfo userInfo : memberInfos) {
            localName += userInfo.showName() + "、";
        }
        if (localName.length() > 0) {
            localName = localName.substring(0, localName.length() - 1);
        } else {
            localName = "群聊";
        }
        Logger.i(TAG, "createGroupLocalName " + groupId + "-- " + localName);
        return localName;
    }

    public static void savePullGroupMember(PullGroupMemberRequest pgmRequest, PullGroupMemberResponse pgmResponse) {
        long groupId = pgmRequest.getGroupId();
        DBHelper.getInstance().insertGroupMembers(groupId, pgmResponse.showMemberIds());
//        int rowId = DBHelper.getInstance().savePullGroupMembers(groupId, pgmResponse.showMemberIds(), pgmResponse.getVersion());
//        if (rowId == 0) {
//            SendMessageQueue.getInstance().addSendMessage(MessageType.GET_GROUP_INFO, new GetGroupInfoRequest(groupId));
//        }

    }

    public static void saveGetGroupInfo(GetGroupInfoRequest ggiRequest, GetGroupInfoResponse ggiResponse) {
        GroupInfo groupInfo = new GroupInfo();
        groupInfo.setGroupId(ggiRequest.getId());
        groupInfo.setHolder(ggiResponse.getInfo().getHolder());
        groupInfo.setType(ggiResponse.getInfo().getType());
        groupInfo.setLocalName(createGroupLocalName(ggiRequest.getId()));
        groupInfo.setName(ggiResponse.getInfo().getName());
        groupInfo.setNotice(ggiResponse.getInfo().getNotice());
        groupInfo.setMemberVersion(ggiResponse.getInfo().getMemberVersion());
        groupInfo.setInfoVersion(ggiResponse.getInfo().getInfoVersion());
        groupInfo.setMemberVersion(ggiResponse.getInfo().getMemberVersion());
        groupInfo.setMemberCount(ggiResponse.getInfo().getMemberCount());
        groupInfo.setIsKickOut(false);
        groupInfo.setIsNewNotice(ggiRequest.isShowNotice());
        DBHelper.getInstance().saveGroupInfo(groupInfo);
    }

    public static void saveGetGroupInfoAndMember(GetGroupInfoAndMemberRequest ggiamRequest, GetGroupInfoAndMemberResponse ggiamResponse) {
        UserInfoProvider.checkAndLoadUserInfos(ggiamResponse.getMemberIds());

        //这里没有直接插入localName是因为群成员表还没插入信息
        GroupInfo groupInfo = new GroupInfo();
        groupInfo.setGroupId(ggiamRequest.getGroupId());
        groupInfo.setHolder(ggiamResponse.getInfo().getHolder());
        groupInfo.setType(ggiamResponse.getInfo().getType());
        groupInfo.setName(ggiamResponse.getInfo().getName());
        groupInfo.setNotice(ggiamResponse.getInfo().getNotice());
        groupInfo.setMemberVersion(ggiamResponse.getInfo().getMemberVersion());
        groupInfo.setInfoVersion(ggiamResponse.getInfo().getInfoVersion());
        groupInfo.setMemberVersion(ggiamResponse.getInfo().getMemberVersion());
        groupInfo.setMemberCount(ggiamResponse.getInfo().getMemberCount());
        groupInfo.setIsKickOut(false);
        groupInfo.setIsNewNotice(false);
        DBHelper.getInstance().replaceGroupInfo(groupInfo, ggiamResponse.getMemberIds());
    }
}
