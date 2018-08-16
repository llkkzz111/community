package com.community.equity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.RemoteException;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.adapter.MessageAdapter;
import com.community.equity.adapter.OnRecyclerViewListener;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApplication;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.dialog.MessageMenuDialog;
import com.community.equity.service.IMServiceConnector;
import com.community.equity.service.IMServiceConnectorAIDL;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Message;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.ContentType;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.request.PullMessageRequest;
import com.community.imsdk.dto.request.SendMessageRequest;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.SendMessageQueue;
import com.community.imsdk.imutils.TransformUtils;
import com.community.imsdk.imutils.callback.IReceiver;
import com.community.imsdk.utils.Logger;

import java.util.ArrayList;
import java.util.List;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by dufeng on 16/10/26.<br/>
 * Description: BaseMessageActivity
 */

public abstract class BaseMessageActivity extends BaseActivity implements IReceiver, View.OnClickListener, OnRecyclerViewListener {

    protected static final int MESSAGE_DETAIL = 1;
    private static final String TAG = "===BaseMessageActivity===";
    protected final int queryCount = 20;
    protected final int ADD_MSG = 1;
    protected final int UPDATE_MSG = 2;
    protected final int LOADED_DB_DATA = 3;
    protected final int DELETE_MSG = 4;
    //    private final int CHANGE = 5;
    protected final int SCROLL_BOTTOM = 6;
    protected long nowChatId;
    protected int nowSessionType;
    protected MessageAdapter messageAdapter;
    protected ImageView ivNotice, ivSetting;
    protected TextView tvTitle, tvMemberCount, tvNotice;
    protected LinearLayout llNotice;
    private ImageView ivBack;
    private PtrClassicFrameLayout mPtrFrame;
    private TextView tvSend;
    private EditText etMessage;
    private LinearLayoutManager layoutManager;
    private RecyclerView rvContent;
    protected Handler handler = new Handler() {

        public void handleMessage(android.os.Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case ADD_MSG:
                    messageAdapter.addMsg((Message) msg.obj);
                    int count = messageAdapter.getItemCount();
                    if (layoutManager.findLastVisibleItemPosition() > count - 3) {
                        rvContent.scrollToPosition(count - 1);
                    }
                    break;
                case UPDATE_MSG:
                    messageAdapter.replaceMsg(msg.arg1, (Message) msg.obj);
                    break;
                case LOADED_DB_DATA:
                    updateViewData();
                    messageAdapter.setData((List<Message>) msg.obj, isShowMemberName());
                    int count1 = messageAdapter.getItemCount();
                    if (count1 > 0) {
                        rvContent.scrollToPosition(count1 - 1);
                    }
                    break;
                case DELETE_MSG:
                    messageAdapter.deleteMsg(msg.arg1);
                    break;
//                case CHANGE:
//                    layoutManager.scrollToPositionWithOffset(msg.arg1, msg.arg2);
//                    break;
                case SCROLL_BOTTOM:
                    rvContent.scrollToPosition(msg.arg1 - 1);
                    break;
            }
        }
    };
    private BaseDialogFragment dialogFragment;
    //----server----
    private IMServiceConnectorAIDL connectorAIDL;
    private IMServiceConnector imServiceConnector = new IMServiceConnector() {


        @Override
        public void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL) {
            connectorAIDL = imServiceConnectorAIDL;
            cancelNotification();
        }

        @Override
        public void onIMServiceDisconnected() {

        }
    };
    private long lastMsgId;
    private int noReadCount;
    /**
     * 拉取离线数据前数据库中的数据条数
     */
    private int msgCount;
    private int queryIndex;

    protected abstract String showNotifyTag();

    protected abstract int showSessionType();

    protected abstract void updateViewData();

    protected abstract boolean isShowMemberName();

    private MessageType[] msgTypeArray = {
            MessageType.PUSH_MESSAGE,
            MessageType.SEND_MESSAGE,
            MessageType.PULL_MESSAGE
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_private_message);


        nowChatId = getIntent().getLongExtra(IntentKeys.KEY_TARGET_ID, 0);
        nowSessionType = showSessionType();

        noReadCount = getIntent().getIntExtra(IntentKeys.KEY_NO_READ_COUNT, 0);
        lastMsgId = getIntent().getLongExtra(IntentKeys.KEY_LAST_MSG_ID, 0);

        Logger.i(TAG, nowSessionType + " -- " + nowChatId);
        BaseApplication.nowChatId = nowChatId;
        BaseApplication.nowSessionType = nowSessionType;

        imServiceConnector.bindService(this);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);

        initView();
        initPtr();
        loadDBData();
    }

    @Override
    protected void onResume() {
        super.onResume();
        BaseApplication.isMsgActivityShow = true;
        if (messageAdapter != null) {
            messageAdapter.notifyDataSetChanged();
        }
        cancelNotification();
    }

    @Override
    protected void onPause() {
        super.onPause();
        BaseApplication.isMsgActivityShow = false;
    }

    private void cancelNotification() {
        if (connectorAIDL != null) {
            try {
                connectorAIDL.cancelNotificationById(showNotifyTag(), (int) nowChatId);
            } catch (RemoteException e) {
                Logger.e(TAG, e.getMessage());
            }
        }
    }

    private void initView() {
        ivBack = (ImageView) findViewById(R.id.iv_activity_message_back);
        ivSetting = (ImageView) findViewById(R.id.iv_activity_message_setting);
        tvTitle = (TextView) findViewById(R.id.tv_activity_message_title);

        mPtrFrame = (PtrClassicFrameLayout) findViewById(R.id.ptr_activity_private_message);
        tvSend = (TextView) findViewById(R.id.tv_activity_private_message_send);
        etMessage = (EditText) findViewById(R.id.et_activity_private_message);
        rvContent = (RecyclerView) findViewById(R.id.rv_activity_private_message);
        dialogFragment = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_CANCLE_ABLE);

        ivNotice = (ImageView) findViewById(R.id.iv_activity_message_notice);
        tvMemberCount = (TextView) findViewById(R.id.tv_activity_message_count);
        tvNotice = (TextView) findViewById(R.id.tv_activity_message_notice);
        llNotice = (LinearLayout) findViewById(R.id.ll_activity_message_notice);

        layoutManager = new LinearLayoutManager(mContext);
        rvContent.setLayoutManager(layoutManager);
        messageAdapter = new MessageAdapter(mContext);
        messageAdapter.setOnRecyclerViewListener(this);
        rvContent.setAdapter(messageAdapter);

        ivBack.setOnClickListener(this);
        ivSetting.setOnClickListener(this);
        tvSend.setOnClickListener(this);

        rvContent.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                /**如果键盘弹出*/
                if (oldBottom > bottom) {
                    int count = messageAdapter.getItemCount();
                    if (count > 0) {
                        android.os.Message msg = handler.obtainMessage();
                        msg.what = SCROLL_BOTTOM;
                        msg.arg1 = count;
                        handler.sendMessage(msg);
                    }
                }
            }
        });
        rvContent.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                Utils.hideInput(v);
                return false;
            }
        });

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_activity_private_message_send:
                String str = etMessage.getText().toString().trim();
                sendTextMsg(str);
                break;
            case R.id.iv_activity_message_back:
                finishActivity();
                break;
        }
    }

    private void sendTextMsg(String str) {
        if (!str.isEmpty()) {
//            int count = messageAdapter.getItemCount();
//            if (count > 0) {
//                rvContent.smoothScrollToPosition(count - 1);
//            }
            Message message = new Message();
            message.setChatId(nowChatId);
            message.setSendUserId(BaseApplication.userId);
            message.setTimestamp(System.currentTimeMillis());
            message.setContent(str);
            message.setContentType(ContentType.TEXT.code);
            message.setSessionType(nowSessionType);
            message.setMsgId(-message.getTimestamp());
            message.setSendStatus(Message.SENDING);
            TransformUtils.saveSendMessage(message);

            SendMessageQueue.getInstance().addSendMessage(MessageType.SEND_MESSAGE,
                    new SendMessageRequest(
                            nowChatId,
                            message.getContent(),
                            message.getContentType(),
                            message.getSessionType(),
                            String.valueOf(message.getMsgId())));

            etMessage.setText("");
            android.os.Message msg = handler.obtainMessage();
            msg.what = ADD_MSG;
            msg.obj = message;
            handler.sendMessage(msg);
        }
    }

    private void deleteMsg(int position) {
        Message message = messageAdapter.getMsgByPosition(position);
        DBHelper.getInstance().deleteUniquePrivateMsg(
                message.getChatId(),
                message.getSessionType(),
                message.getMsgId());

        android.os.Message msg = handler.obtainMessage();
        msg.what = DELETE_MSG;
        msg.arg1 = position;
        handler.sendMessage(msg);
    }


    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setHeaderView(LayoutInflater.from(mContext).inflate(R.layout.frame_ptr_header, null));
        mPtrFrame.setPtrHandler(new PtrHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, rvContent, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                Logger.e(TAG, "onRefreshBegin -> " + queryIndex);
                if (queryIndex > 0) {
                    List<Message> talkMessageList;
                    if (queryIndex < queryCount) {
                        talkMessageList = DBHelper.getInstance().loadMoreMessage(nowChatId, nowSessionType, 0, queryIndex);
                        queryIndex = 0;
                    } else {
                        queryIndex -= queryCount;
                        talkMessageList = DBHelper.getInstance().loadMoreMessage(nowChatId, nowSessionType, queryIndex, queryCount);
                    }

                    for (int i = 0; i < talkMessageList.size(); i++) {
                        talkMessageList.get(i).setMessageIndex(queryIndex);
                    }

                    messageAdapter.addDataToHead(talkMessageList);
                } else {
                    Toast.makeText(mContext, "没有更多了", Toast.LENGTH_SHORT).show();
                }
                mPtrFrame.refreshComplete();
            }

        });
    }

    protected void loadDBData() {
        msgCount = (int) DBHelper.getInstance().queryMessageCount(nowChatId, nowSessionType);
        List<Message> talkMessageList;
        if (msgCount < 20) {
            talkMessageList = DBHelper.getInstance().loadMoreMessage(nowChatId, nowSessionType, 0, msgCount);
        } else {
            queryIndex = msgCount - queryCount;
            talkMessageList = DBHelper.getInstance().loadMoreMessage(nowChatId, nowSessionType, queryIndex, queryCount);
        }

        android.os.Message msg = handler.obtainMessage();
        msg.what = LOADED_DB_DATA;
        msg.obj = talkMessageList;
        handler.sendMessage(msg);
        DBHelper.getInstance().updateSessionCount(nowChatId, nowSessionType, 0);
    }


    private void updateSPData(SendMessageRequest spRequest, long msgId) {
        long createTime = -Long.valueOf(spRequest.getExtra());

        for (int i = 0; i < messageAdapter.getDataSize(); i++) {
            Message message = messageAdapter.getMsgByPosition(i);
            if (message.getTimestamp() == createTime) {
                message.setMsgId(msgId);
                message.setSendStatus(Message.SUCCESS);
                android.os.Message msg = handler.obtainMessage();
                msg.what = UPDATE_MSG;
                msg.arg1 = i;
                msg.obj = message;
                handler.sendMessage(msg);
                break;
            }
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (data != null)
            switch (requestCode) {
                case MESSAGE_DETAIL:
                    boolean isClearMsg = data.getBooleanExtra("isClearMsg", false);
                    if (isClearMsg) {
                        messageAdapter.setData(new ArrayList<Message>(), isShowMemberName());
                    }
                    break;
            }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        imServiceConnector.unbindService(this);
        if (BaseApplication.nowChatId == nowChatId && BaseApplication.nowSessionType == nowSessionType) {
            BaseApplication.nowChatId = -1;
            BaseApplication.nowSessionType = -1;
        }
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case PUSH_MESSAGE:
                Message ppMessage = (Message) response;
                if (ppMessage != null && ppMessage.getChatId() == nowChatId && ppMessage.getSessionType() == nowSessionType) {
                    android.os.Message msg = handler.obtainMessage();
                    msg.what = ADD_MSG;
                    msg.obj = ppMessage;
                    handler.sendMessage(msg);
                }
                break;
            case SEND_MESSAGE:
                Message spMessage = (Message) response;
                if (spMessage != null) {
                    updateSPData((SendMessageRequest) request, spMessage.getMsgId());
                }
                break;
            case PULL_MESSAGE:
                PullMessageRequest fpRequest = (PullMessageRequest) request;
                //TODO 不准确 应该还会关心其他sessionType
                if (fpRequest.getTargetId() == nowChatId && fpRequest.getSessionType() == nowSessionType) {
                    loadDBData();
                }
                break;
        }
    }


    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        switch (messageType) {
            case SEND_MESSAGE:
                SendMessageRequest spRequest = (SendMessageRequest) request;
                long createTime = -Long.valueOf(spRequest.getExtra());
                for (int i = 0; i < messageAdapter.getDataSize(); i++) {
                    Message message = messageAdapter.getMsgByPosition(i);
                    if (message.getTimestamp() == createTime) {
                        message.setSendStatus(Message.SEND_FAIL);
                        android.os.Message msg = handler.obtainMessage();
                        msg.what = UPDATE_MSG;
                        msg.arg1 = i;
                        msg.obj = message;
                        handler.sendMessage(msg);
                        break;
                    }
                }
                break;
        }
    }


    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        if (messageType == MessageType.SEND_MESSAGE) {
            SendMessageRequest spRequest = (SendMessageRequest) request;
            long createTime = -Long.valueOf(spRequest.getExtra());

            for (int i = 0; i < messageAdapter.getDataSize(); i++) {
                Message message = messageAdapter.getMsgByPosition(i);
                if (message.getTimestamp() == createTime) {
                    message.setSendStatus(Message.SEND_FAIL);
                    android.os.Message msg = handler.obtainMessage();
                    msg.what = UPDATE_MSG;
                    msg.arg1 = i;
                    msg.obj = message;
                    handler.sendMessage(msg);
                    break;
                }
            }
        }
    }


    private void finishActivity() {
        Utils.hideInput(etMessage);
        Intent intent = new Intent();
        intent.setData(Uri.parse("community://page/jump?id=session"));
        intent.setAction("com.community.equity.action");
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
        finish();
        animRightToLeft();
    }

    @Override
    public void onBackPressed() {
        finishActivity();
        super.onBackPressed();
    }

    @Override
    public void onItemClick(final int position, View view) {
        switch (view.getId()) {
            case R.id.iv_message_fail:
                dialogFragment.addContent(getString(R.string.text_no_send_is_resend)).
                        addButton(1, getString(R.string.text_cancel), null).
                        addButton(2, getString(R.string.btn_resend), new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                Logger.e(TAG, "reSend:" + messageAdapter.getMsgByPosition(position).getContent());
                                deleteMsg(position);
                                sendTextMsg(messageAdapter.getMsgByPosition(position).getContent());
                            }
                        }).
                        show(getSupportFragmentManager(), "reSend");
                break;
        }
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        switch (view.getId()) {
            case R.id.tv_message_content:
            case R.id.ll_message_content:
                String textContent = messageAdapter.getMsgByPosition(position).getContent();
                Logger.e(TAG, "onItemLongClick:" + messageAdapter.getMsgByPosition(position).getContent());
                new MessageMenuDialog(mContext, textContent).show(getSupportFragmentManager(), "message_menu");
                break;
        }
        return false;
    }


}
