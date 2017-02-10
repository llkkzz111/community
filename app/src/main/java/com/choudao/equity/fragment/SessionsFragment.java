package com.choudao.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.choudao.equity.GroupMessageActivity;
import com.choudao.equity.PrivateMessageActivity;
import com.choudao.equity.R;
import com.choudao.equity.adapter.OnRecyclerViewListener;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseFragment;
import com.choudao.equity.entity.SessionItem;
import com.choudao.equity.fragment.adapter.SessionAdapter;
import com.choudao.equity.popup.GroupChatPopupWindow;
import com.choudao.equity.utils.NineImageUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.NetworkTool;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.Contact;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.SessionConfig;
import com.choudao.imsdk.db.bean.SessionInfo;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.dto.constants.StatusType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.StatusManager;
import com.choudao.imsdk.imutils.callback.IMStatusListener;
import com.choudao.imsdk.imutils.callback.IReceiver;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;


/**
 * Created by /**
 * Created by dufeng on 16/5/1.<br/>
 * Description: PrivateMessageActivity
 */
public class SessionsFragment extends BaseFragment implements IReceiver, IMStatusListener, OnRecyclerViewListener, View.OnClickListener {

    private static final String TAG = "===SessionsFragment===";
    private final int LOADED_DB_DATA = 2;
    private final int STATUS_CHANGE = 3;
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.rl_content) RelativeLayout rlContent;
    @BindView(R.id.rv_fragment_sessions) RecyclerView rvContent;

    private SessionAdapter sessionAdapter;
    private Handler handler = new Handler() {

        public void handleMessage(android.os.Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case LOADED_DB_DATA:
                    List<SessionItem> sessionItemList = (List<SessionItem>) msg.obj;
                    sessionAdapter.setSessionItems(sessionItemList);
                    showContentView();
                    break;
                case STATUS_CHANGE:
                    updateStatus((MessageStatus) msg.obj);
                    break;
            }
        }
    };

    private MessageType[] msgTypeArray = {
            MessageType.PUSH_MESSAGE,
            MessageType.PULL_OFFLINE_RECORD,
            MessageType.PULL_MESSAGE,
            MessageType.LOCAL_LOAD_FRIEND_END,
            MessageType.LOCAL_GROUP_MEMBER_CHANGED,
            MessageType.LOCAL_GROUP_KICK_OUT,
            MessageType.LOCAL_GROUP_INFO_CHANGED,
            MessageType.GET_GROUP_INFO_AND_MEMBER,
            MessageType.GET_GROUP_INFO,
    };

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        StatusManager.getInstance().addIMStatusReceiver(this);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);

        View view = inflater.inflate(R.layout.fragment_sessions_layout, null);
        ButterKnife.bind(this, view);
        setParentView(view);
        initView();
        return view;
    }

    /**
     * 初始化view
     */
    private void initView() {
        setSubContentView(rlContent);
        showLoadView();
        initAdapter();
        topView.setRightImage(R.drawable.img_top_add);
        rvContent.setLayoutManager(new LinearLayoutManager(getActivity()));
    }

    private void initAdapter() {
        if (sessionAdapter == null) {
            sessionAdapter = new SessionAdapter(getActivity());
            rvContent.setAdapter(sessionAdapter);
            sessionAdapter.setOnRecyclerViewListener(this);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        loadDBData();
        checkNetWork();
    }

    private void loadDBData() {
        List<SessionInfo> sessionInfoList = DBHelper.getInstance().loadShowSession();
        List<SessionItem> sessionItemList = new ArrayList<>();
        if (sessionInfoList.size() > 0) {
//            tvEmpty.setVisibility(View.GONE);

            for (SessionInfo sessionInfo : sessionInfoList) {
                SessionItem sessionItem = sessionInfoToSessionItem(sessionInfo);
                if (sessionItem != null) {
                    sessionItemList.add(sessionItem);
                }
            }
            Collections.sort(sessionItemList);
        }
        android.os.Message message = handler.obtainMessage();
        message.what = LOADED_DB_DATA;
        message.obj = sessionItemList;
        handler.sendMessage(message);
    }

    private void checkNetWork() {
        //网络判断
        if (NetworkTool.isNetworkAvailable(getActivity())) {
            if (StatusManager.getInstance().getSocketStatus() == StatusType.LOGIN_SERVER_SUCCESS) {
                topView.setTitle("消息");
            } else {
                topView.setTitle("连接中...");
            }
            sessionAdapter.setNoNetwork(false);
        } else {
            topView.setTitle("消息(未连接)");
            sessionAdapter.setNoNetwork(true);
        }
    }

    private SessionItem sessionInfoToSessionItem(SessionInfo sessionInfo) {
        SessionItem sessionItem = new SessionItem();
        sessionItem.setItemType(SessionItem.ITEM_CONTENT);
        sessionItem.setSessionInfo(sessionInfo);

        switch (SessionType.of(sessionInfo.getSessionType())) {
            case PRIVATE_CHAT:
                Contact contact = DBHelper.getInstance().queryUniqueContact(sessionInfo.getTargetId());
                if (contact != null) {
                    UserInfo userInfo = DBHelper.getInstance().queryUniqueUserInfo(sessionInfo.getTargetId());
                    //一般情况下用户信息表里会有对应联系人的数据,
                    //但如果某用户注册APP账号后卸载了APP,并在此期间产生了大量的离线消息
                    //这时用户再次安装APP并登陆其账号,拉下来了联系人后并正在拉取对应的用户信息,同时离线消息拉取完准备展示时
                    //就会在展示离线消息的时候出现 用户信息表里没有对应联系人的数据
                    //所以这时先不做离线消息的显示,待联系人的用户信息拉取完后再去展示离线消息
                    if (userInfo == null) {
                        return null;
                    }
                    sessionItem.setName(userInfo.showName());
                    sessionItem.setHeadImgUrl(userInfo.getHeadImgUrl());
                } else {
                    //如果不是联系人就不展示在会话里,也可能是联系人出问题了
                    //DBHelper.getInstance().deleteContacts(sessionInfo.getTargetId());

                    return null;
                }
                break;
            case GROUP_CHAT:
                GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(sessionInfo.getTargetId());
                if (groupInfo == null) {
//                    DBHelper.getInstance().deleteSession(sessionInfo.getTargetId(), sessionInfo.getSessionType());
                    return null;
                }
                sessionItem.setName(groupInfo.showName());
                sessionItem.setHeadImgUrl(groupInfo.getHeadImgUrl());
                break;
        }

        //会话配置
        SessionConfig sessionConfig = DBHelper.getInstance().queryUniqueSessionConfig(sessionInfo.getTargetId(),
                sessionInfo.getSessionType());
        if (sessionConfig != null) {
            sessionItem.setTop(sessionConfig.getIsTop());
            sessionItem.setTopTime(sessionConfig.getTopTime());
            sessionItem.setMute(sessionConfig.getIsMute());
        }
        return sessionItem;
    }


    @Override
    public void onItemClick(int position, View view) {
        SessionItem sessionItem = sessionAdapter.getSessionItems().get(position);
        Intent intent;
        switch (sessionItem.getItemType()) {
            case SessionItem.HEAD_NO_NETWORK:
                intent = new Intent(Settings.ACTION_SETTINGS);
                startActivity(intent);
                break;
            case SessionItem.ITEM_CONTENT:
                SessionInfo sessionInfo = sessionItem.getSessionInfo();
                switch (SessionType.of(sessionInfo.getSessionType())) {
                    case PRIVATE_CHAT:
                        intent = new Intent(getActivity(), PrivateMessageActivity.class);
                        intent.putExtra(IntentKeys.KEY_TARGET_ID, sessionInfo.getTargetId());
                        intent.putExtra(IntentKeys.KEY_LAST_MSG_ID, sessionInfo.getLastMessageId());
                        intent.putExtra(IntentKeys.KEY_NO_READ_COUNT, sessionInfo.getCount());
                        startActivity(intent);
                        break;
                    case GROUP_CHAT:
                        intent = new Intent(getActivity(), GroupMessageActivity.class);
                        intent.putExtra(IntentKeys.KEY_TARGET_ID, sessionInfo.getTargetId());
                        intent.putExtra(IntentKeys.KEY_LAST_MSG_ID, sessionInfo.getLastMessageId());
                        intent.putExtra(IntentKeys.KEY_NO_READ_COUNT, sessionInfo.getCount());
                        startActivity(intent);
                        break;
                }

                break;
        }
        ((BaseActivity) getActivity()).animLeftToRight();
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        return false;
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case PUSH_MESSAGE:
                Message message = (Message) response;
                if (message.getSessionType() == SessionType.PRIVATE_CHAT.code ||
                        message.getSessionType() == SessionType.GROUP_CHAT.code) {
                    loadDBData();
                }
                break;
            case PULL_OFFLINE_RECORD:
                int pullSize = (int) response;

                if (pullSize > 0) {
                    android.os.Message msg = handler.obtainMessage();
                    msg.what = STATUS_CHANGE;
                    msg.obj = MessageStatus.PULL_IN;
                    handler.sendMessage(msg);
                }
                break;
            case PULL_MESSAGE:
                android.os.Message msg1 = handler.obtainMessage();
                msg1.what = STATUS_CHANGE;
                msg1.obj = MessageStatus.NORMAL;
                handler.sendMessage(msg1);
            case LOCAL_LOAD_FRIEND_END:
            case LOCAL_GROUP_KICK_OUT:
            case LOCAL_GROUP_INFO_CHANGED:
            case GET_GROUP_INFO:
                loadDBData();
                break;
            case GET_GROUP_INFO_AND_MEMBER:
            case LOCAL_GROUP_MEMBER_CHANGED:
                //TODO 暂时先在群成员变动和全量拉取群信息时生成头像，不严谨
                long groupId = (long) response;
                NineImageUtils nineImage = new NineImageUtils(getActivity(), groupId);
                if (!nineImage.isExists()) {
                    nineImage.saveGroupHead();
                }
                loadDBData();
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {

    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

    }

    @OnClick(R.id.iv_right)
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_right:
                GroupChatPopupWindow chatPopupWindow = new GroupChatPopupWindow(getContext());
                chatPopupWindow.popShow(topView.getRightView());
                break;
        }
    }

    @Override
    public void notifyNetStatus(StatusType statusType) {
        android.os.Message msg = handler.obtainMessage();
        msg.what = STATUS_CHANGE;
        switch (statusType) {
            case NETWORK_UNAVAILABLE:
                msg.obj = MessageStatus.NETWORK_UNAVAILABLE;
                handler.sendMessage(msg);
                break;
            case NETWORK_CONNECTED:
                msg.obj = MessageStatus.CONNECTING;
                handler.sendMessage(msg);
                break;
        }
    }

    @Override
    public void notifySocketStatus(StatusType statusType) {
        android.os.Message msg = handler.obtainMessage();
        msg.what = STATUS_CHANGE;
        switch (statusType) {
            case LOGIN_SERVER_SUCCESS:
                msg.obj = MessageStatus.NORMAL;
                handler.sendMessage(msg);
                break;
//            case SOCKET_DISCONNECTED:
//                if (StatusManager.getInstance().getSocketStatus() != StatusType.LOGIN_SERVER_SUCCESS) {
//                    msg.obj = MessageStatus.CONNECTING;
//                    handler.sendMessage(msg);
//                }
//                break;
        }
    }

    private void updateStatus(MessageStatus msgStatus) {
        if (topView != null) {
            switch (msgStatus) {
                case NORMAL:
                    topView.setTitle("消息");
                    sessionAdapter.setNoNetwork(false);

                    break;
                case CONNECTING:
                    topView.setTitle("连接中...");
                    sessionAdapter.setNoNetwork(false);
                    break;
                case NETWORK_UNAVAILABLE:
                    topView.setTitle("消息(未连接)");
                    sessionAdapter.setNoNetwork(true);
                    break;
                case PULL_IN:
                    topView.setTitle("拉取中...");
                    sessionAdapter.setNoNetwork(false);
                    break;
            }
        }
    }

    @Override
    public void onDestroyView() {
        StatusManager.getInstance().removeIMStatusReceiver(this);
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
        super.onDestroyView();
    }


    private enum MessageStatus {
        NORMAL,
        CONNECTING,
        NETWORK_UNAVAILABLE,
        PULL_IN
    }

}
