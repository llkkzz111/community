package com.community.imsdk.imutils;

import android.database.sqlite.SQLiteException;
import android.os.Handler;

import com.alibaba.fastjson.JSON;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Message;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.ResponseCode;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.push.MessagesBean;
import com.community.imsdk.dto.request.AddGroupMemberRequest;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.request.CreateGroupRequest;
import com.community.imsdk.dto.request.DeleteFriendRequest;
import com.community.imsdk.dto.request.DeleteSessionConfigRequest;
import com.community.imsdk.dto.request.GetGroupInfoAndMemberRequest;
import com.community.imsdk.dto.request.GetGroupInfoRequest;
import com.community.imsdk.dto.request.LeaveGroupRequest;
import com.community.imsdk.dto.request.PullFriendListRequest;
import com.community.imsdk.dto.request.PullGroupMemberRequest;
import com.community.imsdk.dto.request.PullMessageRequest;
import com.community.imsdk.dto.request.PullOfflineRecordRequest;
import com.community.imsdk.dto.request.PullSessionConfigRequest;
import com.community.imsdk.dto.request.RemoveGroupMemberRequest;
import com.community.imsdk.dto.request.SendMessageRequest;
import com.community.imsdk.dto.response.AddGroupMemberResponse;
import com.community.imsdk.dto.response.BaseResponse;
import com.community.imsdk.dto.response.CheckFriendsListResponse;
import com.community.imsdk.dto.response.CreateGroupResponse;
import com.community.imsdk.dto.response.FriendResponse;
import com.community.imsdk.dto.response.GetFriendConfirmationResponse;
import com.community.imsdk.dto.response.GetGroupInfoAndMemberResponse;
import com.community.imsdk.dto.response.GetGroupInfoResponse;
import com.community.imsdk.dto.response.GetUserConfigResponse;
import com.community.imsdk.dto.response.PullFriendListResponse;
import com.community.imsdk.dto.response.PullGroupMemberResponse;
import com.community.imsdk.dto.response.PullMessageResponse;
import com.community.imsdk.dto.response.PullOfflineRecordResponse;
import com.community.imsdk.dto.response.PullSessionConfigResponse;
import com.community.imsdk.dto.response.SendMessageResponse;
import com.community.imsdk.imutils.callback.RequestInfo;
import com.community.imsdk.utils.DefaultThreadFactory;
import com.community.imsdk.utils.GroupInfoRequestUtils;
import com.community.imsdk.utils.Logger;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by dufeng on 16/5/17.<br/>
 * Description: IMMessageManager
 */
public class IMMessageManager extends BaseManager {
    private final String TAG = "===IMMessageManager===";

    private static ThreadPoolExecutor threadPool = new ThreadPoolExecutor(2, 4, 3, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(200),
            new DefaultThreadFactory("MessageDispatcher"), new ThreadPoolExecutor.CallerRunsPolicy());

    public static final int BIG_COUNT = 100;
    public static final int DEFAULT_COUNT = 20;

    private static short seq;

    public static short getSeq() {
        if (seq == Short.MAX_VALUE) {
            seq = 1;
        } else {
            seq++;
        }
        return seq;
    }

    private IMMessageManager() {
    }

    private static IMMessageManager instance;

    public static synchronized IMMessageManager getInstance() {
        if (instance == null) {
            instance = new IMMessageManager();
        }
        return instance;
    }

    public void sendPullSessionConfig(long index) {
        SendMessageQueue.getInstance().addSendMessage(MessageType.PULL_SESSION_CONFIG,
                new PullSessionConfigRequest(index, -BIG_COUNT));
    }

    public void sendPullFriendsList(long index) {
        SendMessageQueue.getInstance().addSendMessage(MessageType.PULL_FRIENDS_LIST,
                new PullFriendListRequest(index, -BIG_COUNT));
    }

    public void sendPullOfflineSession(long index) {
        SendMessageQueue.getInstance().addSendMessage(MessageType.PULL_OFFLINE_RECORD,
                new PullOfflineRecordRequest(index, -DEFAULT_COUNT));
    }

    private EntranceQueue posEntranceQueue = new EntranceQueue(new Runnable() {
        @Override
        public void run() {
            sendPullOfflineSession(0);
        }
    });

    public void addPOSTask() {
        posEntranceQueue.addTask();
    }

    private EntranceQueue pflEntranceQueue = new EntranceQueue(new Runnable() {
        @Override
        public void run() {
            sendPullFriendsList(0);
        }
    });

    public void addPFLTask() {
        pflEntranceQueue.addTask();
    }


    public void notifyPFLTask() {
        pflEntranceQueue.notifyTask();
    }

    public void init() {
        posEntranceQueue.init();
        pflEntranceQueue.init();
    }


    /**
     * ===================消息超时Timer=====================
     */
    private Map<Integer, RequestInfo> requestInfoMap = new ConcurrentHashMap<>();
    //    private Map<Integer, MessageDTO> requestConcurrentHashMap = new ConcurrentHashMap<>();
    private Handler timerHandler = new Handler();

    private volatile boolean hasTask = false;
//    private volatile boolean isRunnable = false;

    public void startTimeoutTimer() {
//        requestInfoMap.clear();
//        isRunnable = true;
        checkTimeout();
    }

    public void stopTimeoutTimer() {

        for (int seqNo : requestInfoMap.keySet()) {
            addTimeoutMessageTask(seqNo);
        }
//        isRunnable = false;
    }

    public void checkTimeout() {
        if (!hasTask) {
            hasTask = true;
            timerHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (!requestInfoMap.isEmpty()) {
                        checkImpl();
                    }
                    hasTask = false;
                    checkTimeout();
                }
            }, 2 * 1000);
        }
    }

    /**
     * 超时处理
     */
    private void checkImpl() {
        long currentTime = System.currentTimeMillis();

        for (java.util.Map.Entry<Integer, RequestInfo> entry : requestInfoMap.entrySet()) {

            RequestInfo requestInfo = entry.getValue();
            Integer seqNo = entry.getKey();
            if (requestInfo == null) {
                removeRequest(seqNo);
                continue;
            }
            long timeRange = currentTime - requestInfo.getCreateTime();

            if (timeRange >= requestInfo.getTimeOut()) {
                addTimeoutMessageTask(seqNo);
            }
        }
    }

    /**===================消息超时Timer=====================*/


    /**
     * ==================消息的发送和分发==================
     */

    public void addReceiveMessageTask(final MessageDTO response) {
        final String traceId = Logger.getTraceId();
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Logger.setTraceId(traceId);
                dispatcherMsgSuccess(response);
            }
        };
        threadPool.execute(runnable);
    }


    public void addTimeoutMessageTask(final int seqNo) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                dispatcherMsgTimeout(seqNo);
            }
        };
        threadPool.execute(runnable);
    }

    public void dispatcherMsgSuccess(MessageDTO response) {
        RequestInfo requestInfo = removeRequest(response.getSeq());
        BaseRequest request = null;
        if (requestInfo != null) {
            request = requestInfo.getRequest();
        }

        //非推送的消息
        if (response.getMsgType() < 2000 && response.msgTypeEnum() != MessageType.HEART_BEAT) {
            /** 如果已经超时后接到成功的消息响应 */
            if (request == null) {
                return;
            }

            BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
            if (baseResponse.getCode() != null && !baseResponse.getCode().equals(ResponseCode.SUCCESS)) {
                dispatcherMsgFail(requestInfo, response);
                return;
            }
        }

        Object result = response;
        long index;
        switch (response.msgTypeEnum()) {
            case GET_USER_CONFIG:
                result = JSON.parseObject(response.getBody(), GetUserConfigResponse.class);
                break;
            case PUSH_MESSAGE:
                MessagesBean ppResponse = JSON.parseObject(response.getBody(), MessagesBean.class);
                result = TransformUtils.savePushMessage(ppResponse);
                break;
            case SEND_MESSAGE:
                SendMessageResponse spResponse = JSON.parseObject(response.getBody(), SendMessageResponse.class);
                SendMessageRequest spRequest = (SendMessageRequest) request;
                result = TransformUtils.updateMessage(spRequest, spResponse.getMsgId(), Message.SUCCESS);
                break;
            case PULL_OFFLINE_RECORD:
                PullOfflineRecordResponse posResponse = JSON.parseObject(response.getBody(), PullOfflineRecordResponse.class);
                List<PullOfflineRecordResponse.RecordBean> sessionsBeanList = posResponse.getRecords();
                TransformUtils.saveOfflineRecords(sessionsBeanList);
                /** 如果返回的是20条那么可能后面还有数据，如果小于20条则拉取完了 */
                index = posResponse.showMinId();
                if (sessionsBeanList.size() == DEFAULT_COUNT && index > 1) {
                    sendPullOfflineSession(index - 1);
                } else {
                    posEntranceQueue.notifyTask();
                }
                result = sessionsBeanList.size();
                break;
            case PULL_SESSION_CONFIG:
                PullSessionConfigResponse pscResponse = JSON.parseObject(response.getBody(), PullSessionConfigResponse.class);
                List<PullSessionConfigResponse.ConfigBean> configList = pscResponse.getConfigs();
                TransformUtils.saveSessionConfigs(configList);
                index = pscResponse.showMinId();
                if (configList.size() == BIG_COUNT && index > 1) {
                    sendPullSessionConfig(index - 1);
                }
                break;
            case CHECK_FRIENDS_LIST:
                CheckFriendsListResponse cflResponse = JSON.parseObject(response.getBody(), CheckFriendsListResponse.class);
                if (cflResponse.isStatus()) {
                    addPFLTask();
                }
                break;
            case PULL_FRIENDS_LIST:
                PullFriendListResponse pflResponse = JSON.parseObject(response.getBody(), PullFriendListResponse.class);
                TransformUtils.saveFriendList(pflResponse);
                result = pflResponse;
                break;
            case PULL_MESSAGE:
                PullMessageRequest fpRequest = (PullMessageRequest) request;
                PullMessageResponse fpResponse = JSON.parseObject(response.getBody(), PullMessageResponse.class);
                result = TransformUtils.savePullMessage(fpRequest, fpResponse);
                break;
            case SYNC_FLAG:
                addPOSTask();
                break;
            case FRIENDS_LIST_CHANGED:
                addPFLTask();
                break;
            case DELETE_FRIEND:
                FriendResponse friendResponse = JSON.parseObject(response.getBody(), FriendResponse.class);
                DeleteFriendRequest delRequest = (DeleteFriendRequest) request;
                try {
                    DBHelper.getInstance().deleteContacts(delRequest.getFriendUserId());
                } catch (SQLiteException e) {
                    Logger.e(TAG, "DELETE_FRIEND: " + e.getMessage());
                    return;
                }
                SendMessageQueue.getInstance().addSendMessage(MessageType.DELETE_SESSION_CONFIG,
                        new DeleteSessionConfigRequest(delRequest.getFriendUserId(), SessionType.PRIVATE_CHAT.code));
                result = friendResponse;
                break;
            case SET_FRIEND_REMARK:
                result = JSON.parseObject(response.getBody(), FriendResponse.class);
                break;
            case GET_FRIEND_CONFIRMATION:
                result = JSON.parseObject(response.getBody(), GetFriendConfirmationResponse.class);
                break;
            case CREATE_GROUP:
                CreateGroupRequest cgRequest = (CreateGroupRequest) request;
                CreateGroupResponse cgResponse = JSON.parseObject(response.getBody(), CreateGroupResponse.class);
                TransformUtils.saveNoFriendMessage(cgResponse.getGroupId(), cgRequest.getUserIds(), cgResponse.getUserIds());
                result = cgResponse.getGroupId();
                break;
            case ADD_GROUP_MEMBER:
                AddGroupMemberRequest agmRequest = (AddGroupMemberRequest) request;
                AddGroupMemberResponse afmResponse = JSON.parseObject(response.getBody(), AddGroupMemberResponse.class);
                TransformUtils.saveNoFriendMessage(agmRequest.getGroupId(), agmRequest.getUserIds(), afmResponse.getUserIds());
                result = agmRequest.getGroupId();
                break;
            case REMOVE_GROUP_MEMBER:
                RemoveGroupMemberRequest rgmRequest = (RemoveGroupMemberRequest) request;
                result = rgmRequest.getGroupId();
                break;
            case PULL_GROUP_MEMBER:
                PullGroupMemberRequest pgmRequest = (PullGroupMemberRequest) request;
                PullGroupMemberResponse pgmResponse = JSON.parseObject(response.getBody(), PullGroupMemberResponse.class);
                TransformUtils.savePullGroupMember(pgmRequest, pgmResponse);
                break;
            case GET_GROUP_INFO:
                GetGroupInfoRequest ggiRequest = (GetGroupInfoRequest) request;
                GetGroupInfoResponse ggiResponse = JSON.parseObject(response.getBody(), GetGroupInfoResponse.class);
                TransformUtils.saveGetGroupInfo(ggiRequest, ggiResponse);
                break;
            case GET_GROUP_INFO_AND_MEMBER:
                GetGroupInfoAndMemberRequest ggiamRequest = (GetGroupInfoAndMemberRequest) request;
                GetGroupInfoAndMemberResponse ggiamResponse = JSON.parseObject(response.getBody(), GetGroupInfoAndMemberResponse.class);
                TransformUtils.saveGetGroupInfoAndMember(ggiamRequest, ggiamResponse);
                GroupInfoRequestUtils.notifyLock(ggiamRequest.getGroupId());
                result = ggiamRequest.getGroupId();
                break;
            case LEAVE_GROUP:
                LeaveGroupRequest lgRequest = (LeaveGroupRequest) request;
                DBHelper.getInstance().levaeGroup(lgRequest.getId());
                break;
        }
        if (result == null) {
            return;
        }
        if (response.getMsgType() > 2000) {
            IMMessageDispatcher.onSuccess(response.msgTypeEnum(), null, result);
        } else {
            if (requestInfo != null) {
                IMMessageDispatcher.onSuccess(response.msgTypeEnum(), request, result);
            }
        }
    }

    public void dispatcherMsgFail(RequestInfo requestInfo, MessageDTO response) {

        MessageType messageType = requestInfo.getMessageType();
        BaseRequest request = requestInfo.getRequest();
        switch (messageType) {
            case SEND_MESSAGE:
                TransformUtils.updateMessage((SendMessageRequest) request, -1, Message.SEND_FAIL);
                break;
            case PULL_OFFLINE_RECORD:
                posEntranceQueue.notifyTask();
                break;
            case PULL_FRIENDS_LIST:
                pflEntranceQueue.notifyTask();
                break;
            case GET_GROUP_INFO_AND_MEMBER:
                GetGroupInfoAndMemberRequest ggiamRequest = (GetGroupInfoAndMemberRequest) request;
                GroupInfoRequestUtils.notifyLock(ggiamRequest.getGroupId());
                break;
        }
        IMMessageDispatcher.onFail(messageType, request, response);
    }

    public void dispatcherMsgTimeout(int seqNo) {
        Logger.setTraceId("TimeOut-->" + seqNo);
        Logger.e(TAG, "dispatcherMsgTimeout --> " + seqNo);
        RequestInfo requestInfo = removeRequest(seqNo);
        if (requestInfo == null) {
            return;
        }
        MessageType messageType = requestInfo.getMessageType();
        BaseRequest request = requestInfo.getRequest();
        switch (messageType) {
            case SEND_MESSAGE:
                TransformUtils.updateMessage((SendMessageRequest) request, -1, Message.SEND_FAIL);
                break;
            case PULL_OFFLINE_RECORD:
                posEntranceQueue.notifyTask();
                break;
            case PULL_FRIENDS_LIST:
                pflEntranceQueue.notifyTask();
                break;
            case GET_GROUP_INFO_AND_MEMBER:
                GetGroupInfoAndMemberRequest ggiamRequest = (GetGroupInfoAndMemberRequest) request;
                GroupInfoRequestUtils.notifyLock(ggiamRequest.getGroupId());
                break;
        }
        IMMessageDispatcher.onTimeout(messageType, request);
    }

    /**
     * ==================消息的发送和分发==================
     */


    public void putRequest(int seqNo, BaseRequest request, MessageType messageType) {
        if (seqNo <= 0) {
            return;
        }
        requestInfoMap.put(seqNo, new RequestInfo(request, messageType));
//        if (!isRunnable) {
//            dispatcherMsgTimeout(seqNo);
//        }
    }


    public synchronized RequestInfo removeRequest(int seqNo) {
//        synchronized (IMMessageManager.this) {
//            if (requestInfoMap.containsKey(seqNo)) {
        return requestInfoMap.remove(seqNo);
//            }
//            return null;
//        }
    }


}
