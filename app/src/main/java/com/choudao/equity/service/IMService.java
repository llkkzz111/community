package com.choudao.equity.service;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteException;
import android.os.IBinder;
import android.os.RemoteException;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;

import com.alibaba.fastjson.JSON;
import com.choudao.equity.R;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseApplication;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.imsdk.IMApplication;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.SessionConfig;
import com.choudao.imsdk.db.bean.SessionInfo;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.ContentType;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.ResponseCode;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.dto.constants.StatusType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.CheckFriendsListRequest;
import com.choudao.imsdk.dto.request.GetUserConfigRequest;
import com.choudao.imsdk.dto.request.LoginRequest;
import com.choudao.imsdk.dto.request.SetFriendRemarkRequest;
import com.choudao.imsdk.dto.request.SetUserConfigRequest;
import com.choudao.imsdk.dto.response.FriendResponse;
import com.choudao.imsdk.dto.response.GetUserConfigResponse;
import com.choudao.imsdk.dto.response.LoginResponse;
import com.choudao.imsdk.dto.response.PullFriendListResponse;
import com.choudao.imsdk.http.ApiService;
import com.choudao.imsdk.http.ServiceGenerator;
import com.choudao.imsdk.http.entity.FriendsInfoEntity;
import com.choudao.imsdk.imutils.HeartBeatManager;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.IMMessageManager;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.SocketManager;
import com.choudao.imsdk.imutils.StatusManager;
import com.choudao.imsdk.imutils.TransformUtils;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.choudao.imsdk.utils.Logger;
import com.choudao.imsdk.utils.Pinyin4jUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import cn.jpush.android.api.JPushInterface;
import retrofit2.Call;

/**
 * Created by dufeng on 16/4/25.<br/>
 * Description: 初始化并管理im的服务
 */
public class IMService extends Service implements IReceiver {

    private final String TAG = "===IMService===";
    public Context context;
    private SocketManager socketManager = SocketManager.getInstance();
    private HeartBeatManager heartBeatManager = HeartBeatManager.getInstance();
    private StatusManager statusManager = StatusManager.getInstance();
    private IMMessageManager imMessageManager = IMMessageManager.getInstance();
    private IMNotificationManager imNotificationManager = IMNotificationManager.getInstance();
    private DBHelper dbHelper = DBHelper.getInstance();
    private final IMServiceConnectorAIDL.Stub binder = new IMServiceConnectorAIDL.Stub() {
        @Override
        public void loginIMServer(int userId) throws RemoteException {
            IMService.this.loginIMServer(userId);
        }

        @Override
        public void logoutIMServer() throws RemoteException {
            IMService.this.logoutIMServer();
        }

        @Override
        public void setKickOut(boolean kickOut) throws RemoteException {
            socketManager.setKickOut(kickOut);
        }

        @Override
        public void cancelNotificationById(String tag, int id) {
            imNotificationManager.cancelNotificationById(tag, id);
        }
    };

    private MessageType[] msgTypeArray = {
            MessageType.LOGIN,
            MessageType.PUSH_MESSAGE,
            MessageType.PULL_FRIENDS_LIST,
            MessageType.GET_USER_CONFIG,
            MessageType.SET_USER_CONFIG,
            MessageType.KICK_OUT,
            MessageType.DELETE_FRIEND,
            MessageType.SET_FRIEND_REMARK
    };

    @Override
    public void onCreate() {
        Logger.e(TAG, " --> onCreate");
        context = getApplicationContext();
        imNotificationManager.setContext(context);
        statusManager.registerReceiver(context);
        socketManager.init();
        imMessageManager.init();
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        super.onCreate();
    }

    @Override
    public IBinder onBind(Intent intent) {

        return binder;
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Logger.e(TAG, " --> onStartCommand");

//        if (ConstantUtils.USER_ID != -1) {
//            loginIMServer(ConstantUtils.USER_ID);
//        }
        return START_STICKY;
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Logger.e(TAG, " --> onTaskRemoved");
        this.stopSelf();
    }

    @Override
    public void onDestroy() {
        logoutIMServer();
        if (statusManager != null) {
            statusManager.unregisterReceiver(context);
        }
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
        Logger.e(TAG, " -> onDestroy");
        super.onDestroy();
    }

    public void loginIMServer(int userId) {
        Logger.i(TAG, " -> loginIMServer");
        BaseApplication.token = PreferencesUtils.getAccessToken();
        BaseApplication.isCanConnect = true;
        BaseApplication.userId = userId;
        dbHelper.init(userId);
        imMessageManager.startTimeoutTimer();
        socketManager.login();
    }

    public void logoutIMServer() {
        Logger.i(TAG, " -> logoutIMServer");
        heartBeatManager.closeHB();
        IMApplication.isCanConnect = false;
        imMessageManager.stopTimeoutTimer();
        BaseApplication.userId = -1;
        socketManager.logout();
        imNotificationManager.cancelAllNotification();
//        imMessageManager.onDestroyManager();
    }


    private void loadMyFriends(final PullFriendListResponse pflResponse) {

        ApiService service = ServiceGenerator.createService(ApiService.class);
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("user_id_list", pflResponse.showAllUserId());
        Call<FriendsInfoEntity> call = service.getFriendsInfo(params);
        call.enqueue(new BaseCallBack<FriendsInfoEntity>() {
            @Override
            protected void onSuccess(FriendsInfoEntity friendsInfoEntity) {
                List<UserInfo> userInfoList = new ArrayList<>();
                Map<Long, PullFriendListResponse.FriendsBean> friendsBeanMap = new HashMap<>();
                for (PullFriendListResponse.FriendsBean friendsBean : pflResponse.getFriends()) {
                    friendsBeanMap.put(friendsBean.getFriendUserId(), friendsBean);
                }

                for (FriendsInfoEntity.DataSourceBean dataSourceBean : friendsInfoEntity.getDataSource()) {
                    PullFriendListResponse.FriendsBean friendsBean = friendsBeanMap.get(dataSourceBean.getId());
                    UserInfo userIfo = new UserInfo();
                    userIfo.setUserId(friendsBean.getFriendUserId());
                    userIfo.setUserType(friendsBean.getFriendUserType());
                    userIfo.setRemark(friendsBean.getRemark());
                    userIfo.setRemarkPinYin(Pinyin4jUtil.nameHanziToPinyin(friendsBean.getRemark()));
                    userIfo.setHeadImgUrl(dataSourceBean.getImg());
                    userIfo.setName(dataSourceBean.getName());
                    userIfo.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(dataSourceBean.getName()));
                    userIfo.setTitle(dataSourceBean.getTitle());
                    userIfo.setPhone(dataSourceBean.getPhone());
                    userIfo.setFollowersCount(dataSourceBean.getFollowers_count());
                    userIfo.setFollowingCount(dataSourceBean.getFollowing_count());
                    userIfo.setAnswerCount(dataSourceBean.getAnswers_counter());
                    userIfo.setQuestionCount(dataSourceBean.getQuestions_count());
                    userIfo.setAddress(dataSourceBean.getAddress());
                    userIfo.setDesc(dataSourceBean.getDesc());
                    userIfo.setShareUrl(dataSourceBean.getShare_url());
                    userInfoList.add(userIfo);
                }
                Logger.e(TAG, "userInfoList --> " + JSON.toJSONString(userInfoList));
                try {
                    //保存联系人信息
                    dbHelper.saveUserInfoList(userInfoList);

                } catch (SQLiteException e) {
                    Logger.e(TAG, e.getMessage());
                    return;
                }


                List<PullFriendListResponse.FriendsBean> friendsBeanList = pflResponse.getFriends();
                long index = pflResponse.showMinId();
                //如果完成拉取
                if (friendsBeanList.size() != IMMessageManager.BIG_COUNT || index <= 1) {

                    //保存联系人版本号
                    PreferencesUtils.setContactsVersion(pflResponse.getVersion());
                    //通知拉取好友的队列解锁
                    imMessageManager.notifyPFLTask();
                    List<SessionInfo> sessionInfoList = dbHelper.loadShowSession();
                    if (!PreferencesUtils.getHaveWelcome() && sessionInfoList.size() == 0) {
                        PreferencesUtils.setHaveWelcome(true);
                        createWelcomeMsg();
                    }
                    //分发联系人拉完的消息
                    IMMessageDispatcher.onSuccess(MessageType.LOCAL_LOAD_FRIEND_END, null, null);
                }
            }

            @Override
            protected void onFailure(int errCode, String msg) {
                imMessageManager.notifyPFLTask();
                Logger.e(TAG, errCode + msg);
            }
        });

    }

    private void createWelcomeMsg() {
        UserInfo userInfo = dbHelper.queryContactByName("筹小道");
        if (userInfo == null) {
            return;
        }

        Message message = new Message();
        message.setChatId(userInfo.getUserId());
        message.setSendUserId(userInfo.getUserId());
        message.setTimestamp(System.currentTimeMillis());
        message.setContent(getString(R.string.text_chouxiaodao_greet));
        message.setContentType(ContentType.TEXT.code);
        message.setSessionType(SessionType.PRIVATE_CHAT.code);
        message.setMsgId(-message.getTimestamp());
        message.setSendStatus(Message.SUCCESS);
        TransformUtils.saveSendMessage(message, message.getSessionType(), message.getContentType(), 1);
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            /** 登录成功 */
            case LOGIN:
                Logger.e(TAG, "login -> ");
                dbHelper.init(BaseApplication.userId);
                statusManager.onSocketStatusChange(StatusType.LOGIN_SERVER_SUCCESS);
                heartBeatManager.startHB();
                SendMessageQueue.getInstance().addSendMessage(MessageType.GET_USER_CONFIG,
                        new GetUserConfigRequest());
                //检查联系人版本
                int version = PreferencesUtils.getContactsVersion();
                if (version == -1) {
                    imMessageManager.addPFLTask();
                } else {
                    SendMessageQueue.getInstance().addSendMessage(MessageType.CHECK_FRIENDS_LIST,
                            new CheckFriendsListRequest(version));
                }
                imMessageManager.sendPullSessionConfig(0);
                imMessageManager.addPOSTask();
                break;
            /** 接到消息推送 */
            case PUSH_MESSAGE:
                Message message = (Message) response;
                switch (SessionType.of(message.getSessionType())) {
                    case GROUP_CHAT:
                    case PRIVATE_CHAT:
                    case FRIEND_REQUEST:
                        //TODO 多设备判断是不是自己发送的消息 这里判断自己的在将来可能会有问题
                        //这里都是需要通知的消息
                        if (imNotificationManager != null && message.getSendUserId() != ConstantUtils.USER_ID) {
                            SessionConfig sessionConfig = dbHelper.queryUniqueSessionConfig(message.getChatId(), message.getSessionType());
                            if (sessionConfig == null || !sessionConfig.getIsMute()) {
                                imNotificationManager.loadNotificationData(message);
                            }
                        }
                        break;
                }
                break;
            case PULL_FRIENDS_LIST:
                PullFriendListResponse pflResponse = (PullFriendListResponse) response;
                loadMyFriends(pflResponse);
                Logger.e(TAG, "showAllUserId: " + pflResponse.showAllUserId());
                break;
            case GET_USER_CONFIG:
                GetUserConfigResponse gpcResponse = (GetUserConfigResponse) response;
                PreferencesUtils.setMessagePromptState(gpcResponse.isAccept());
                PreferencesUtils.setNotifyDetailsState(gpcResponse.isShowDetail());
                PreferencesUtils.setFriendConfirmationState(gpcResponse.isFriendConfirmation());
                break;
            case SET_USER_CONFIG:
                SetUserConfigRequest spcRequest = (SetUserConfigRequest) request;
                PreferencesUtils.setMessagePromptState(spcRequest.isAccept());
                PreferencesUtils.setNotifyDetailsState(spcRequest.isShowDetail());
                PreferencesUtils.setFriendConfirmationState(spcRequest.isFriendConfirmation());
                break;
            case KICK_OUT:
                kickOutUser();
                break;
            case DELETE_FRIEND:
                FriendResponse delResponse = (FriendResponse) response;
                PreferencesUtils.setContactsVersion(delResponse.getVersion());
                break;
            case SET_FRIEND_REMARK:
                FriendResponse updateRemarkResponse = (FriendResponse) response;
                SetFriendRemarkRequest updateRemarkRequest = (SetFriendRemarkRequest) request;
                long userId = updateRemarkRequest.getFriendUserId();
                String remark = updateRemarkRequest.getRemark();
                String remarkPinYin = Pinyin4jUtil.nameHanziToPinyin(remark);

                dbHelper.updateRemark(userId, remark, remarkPinYin);

                PreferencesUtils.setContactsVersion(updateRemarkResponse.getVersion());
                break;
        }
    }

    public void kickOutUser() {
        if (!socketManager.isKickOut()) {
            socketManager.setKickOut(true);

            PreferencesUtils.setLoginState(false);
            PreferencesUtils.setAccessToken("");
            ConstantUtils.isLogin = false;

            CookieSyncManager.createInstance(getApplicationContext());
            CookieManager.getInstance().removeAllCookie();

            logoutIMServer();
            JPushInterface.setAlias(getBaseContext(), "", null);
            Logger.e(TAG, MessageType.KICK_OUT.toString());
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {

        switch (messageType) {
            case LOGIN:
                LoginResponse loginResponse = JSON.parseObject(response.getBody(), LoginResponse.class);
                if (loginResponse.getCode() == null) {
                    return;
                }
                switch (loginResponse.getCode()) {
                    case ResponseCode.LOGIN_FAIL:
                        kickOutUser();
                        break;
                    case ResponseCode.LOGIN_TIME_INCORRECT:
                        SendMessageQueue.getInstance().addSendMessage(MessageType.LOGIN,
                                new LoginRequest(IMApplication.userId, IMApplication.phoneMark, IMApplication.token, IMApplication.appVersion, loginResponse.getTimestamp()));
                        break;
                    default:
                        try {
                            Thread.sleep(30 * 1000);
                            SendMessageQueue.getInstance().addSendMessage(MessageType.LOGIN,
                                    new LoginRequest(IMApplication.userId, IMApplication.phoneMark, IMApplication.token, IMApplication.appVersion, System.currentTimeMillis()));
                        } catch (Exception e) {
                            Logger.e(TAG, e.getMessage());
                        }
                        break;
                }
                break;
        }

    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

        switch (messageType) {
            case LOGIN:
                if (!socketManager.isKickOut()) {
                    statusManager.onSocketStatusChange(StatusType.SOCKET_DISCONNECTED);
                }
                break;
        }
    }


}
