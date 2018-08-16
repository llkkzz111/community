package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.os.RemoteException;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.community.equity.adapter.NewFriendsAdapter;
import com.community.equity.adapter.OnRecyclerViewListener;
import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.entity.NewFriendItem;
import com.community.equity.service.IMServiceConnector;
import com.community.equity.service.IMServiceConnectorAIDL;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Contact;
import com.community.imsdk.db.bean.SessionInfo;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.NotificationInfo;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.ResponseCode;
import com.community.imsdk.dto.request.AcceptFriendRequest;
import com.community.imsdk.dto.request.AddFriendRequest;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.response.BaseResponse;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.SendMessageQueue;
import com.community.imsdk.imutils.callback.IReceiver;
import com.community.imsdk.utils.Logger;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dufeng on 16/7/15.<br/>
 * Description: NewFriendsActivity
 */
public class NewFriendsActivity extends BaseActivity implements IReceiver, OnRecyclerViewListener, View.OnClickListener {

    private final String TAG = "===NewFriendsActivity===";

    private RecyclerView rvContent;
    private NewFriendsAdapter newFriendsAdapter;

    //----server----
    private IMServiceConnectorAIDL connectorAIDL;
    private IMServiceConnector imServiceConnector = new IMServiceConnector() {


        @Override
        public void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL) {
            connectorAIDL = imServiceConnectorAIDL;
            if (connectorAIDL != null) {
                try {
                    connectorAIDL.cancelNotificationById(NotificationInfo.NO_CONTENT_MSG, -2);
                } catch (RemoteException e) {
                    Logger.e(TAG, e.getMessage());
                }
            }
        }

        @Override
        public void onIMServiceDisconnected() {

        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        imServiceConnector.bindService(this);
        IMMessageDispatcher.bindMessageType(MessageType.LOCAL_LOAD_FRIEND_END, this);

        setContentView(R.layout.activity_newfriends);
        initView();
        DBHelper.getInstance().clearNewFriendNumber();
    }

    @Override
    protected void onDestroy() {

        imServiceConnector.unbindService(this);
        IMMessageDispatcher.unbindMessageType(MessageType.LOCAL_LOAD_FRIEND_END, this);
        super.onDestroy();
    }

    private void initView() {
        TopView topView = (TopView) findViewById(R.id.topview);
        topView.setTitle(R.string.text_new_friends);
        topView.getLeftView().setOnClickListener(this);

        rvContent = (RecyclerView) findViewById(R.id.rv_activity_friends);

        rvContent.setLayoutManager(new LinearLayoutManager(mContext));
        newFriendsAdapter = new NewFriendsAdapter(mContext);
        rvContent.setAdapter(newFriendsAdapter);
        newFriendsAdapter.setOnRecyclerViewListener(this);


    }

    @Override
    protected void onResume() {
        super.onResume();
        IMMessageDispatcher.bindMessageType(MessageType.ACCEPT_FRIEND_REQUEST, this);
        if (ConstantUtils.isLogin) {
            loadDBData();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        IMMessageDispatcher.unbindMessageType(MessageType.ACCEPT_FRIEND_REQUEST, this);
    }

    private void loadDBData() {
        List<SessionInfo> newFriendSessionList = DBHelper.getInstance().loadNewFriendSession();
        List<NewFriendItem> newFriendItemList = new ArrayList<>();
        newFriendItemList.add(new NewFriendItem(NewFriendItem.VIEW_HEADER));

        if (newFriendSessionList.size() > 0) {
            for (SessionInfo sessionInfo : newFriendSessionList) {

                NewFriendItem friendItem = new NewFriendItem(NewFriendItem.VIEW_CONTENT);
                friendItem.setSessionInfo(sessionInfo);
                friendItem.setContent(sessionInfo.getLastMessage());

                Contact contact = DBHelper.getInstance().queryUniqueContact(sessionInfo.getTargetId());
                if (contact != null) {
                    friendItem.setAction(NewFriendItem.ADDED);
                } else {
                    friendItem.setAction(NewFriendItem.ACCEPT);
                }
                UserInfo userInfo = DBHelper.getInstance().queryUniqueUserInfo(sessionInfo.getTargetId());
                if (userInfo != null) {
                    friendItem.setName(userInfo.showName());
                    friendItem.setHeadImgUrl(userInfo.getHeadImgUrl());
                }
                newFriendItemList.add(friendItem);
            }
        }
        newFriendsAdapter.setNewFriendItems(newFriendItemList);
    }

    private BaseDialogFragment dialog = new BaseDialogFragment();

    @Override
    public void onItemClick(int position, View view) {
        Intent intent;
        switch (view.getId()) {
            case R.id.ll_header_new_friend_search:
                intent = new Intent(this, NewFriendsSearchActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_header_mobile_contacts:
                intent = new Intent(this, MobileContactsActivity.class);
                startActivity(intent);
                break;
            case R.id.tv_item_new_friend_action:
                dialog.addProgress();
                dialog.show(getSupportFragmentManager(), "loadingContacts");
                NewFriendItem newFriendItem = newFriendsAdapter.getItemData(position);
                SendMessageQueue.getInstance().addSendMessage(MessageType.ACCEPT_FRIEND_REQUEST,
                        new AcceptFriendRequest(newFriendItem.getSessionInfo().getTargetId(), newFriendItem.getContent().getId()));
                break;
            default:
                intent = new Intent(this, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, newFriendsAdapter.getItemData(position).getSessionInfo().getTargetId());
                intent.putExtra(IntentKeys.FRIEND_REQUEST_ID, newFriendsAdapter.getItemData(position).getContent().getId());
                startActivity(intent);
                break;
        }
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        return false;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                finish();
                break;
        }
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case LOCAL_LOAD_FRIEND_END:
                if (dialog.isShow())
                    dialog.dismissAllowingStateLoss();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        loadDBData();
                    }
                });
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        switch (messageType) {
            case ACCEPT_FRIEND_REQUEST:
                dialog.dismissAllowingStateLoss();
                final AcceptFriendRequest acceptFriendRequest = (AcceptFriendRequest) request;
                BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);

                if (baseResponse.getCode().equals(ResponseCode.FRIEND_REQUEST_EXPIRED)) {
                    BaseDialogFragment dialogFragment = new BaseDialogFragment();
                    dialogFragment.addContent("朋友请求已过期，请主动添加对方")
                            .addButton(1, "取消", null)
                            .addButton(2, "添加", new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    String verificationStr = "我是" + DBHelper.getInstance().queryMyInfo().getName();
                                    SendMessageQueue.getInstance().addSendMessage(MessageType.ADD_FRIEND,
                                            new AddFriendRequest(acceptFriendRequest.showUserId(), verificationStr));
                                }
                            }).show(getSupportFragmentManager(), "dialog");
                } else {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(mContext, "添加好友失败", Toast.LENGTH_SHORT).show();
                        }
                    });
                }
                break;
        }
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        switch (messageType) {
            case ACCEPT_FRIEND_REQUEST:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialog.dismissAllowingStateLoss();
                        Toast.makeText(mContext, "添加好友超时", Toast.LENGTH_SHORT).show();

                    }
                });
                break;
        }
    }
}
