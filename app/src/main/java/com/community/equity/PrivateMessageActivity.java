package com.community.equity;

import android.content.Intent;
import android.view.View;

import com.alibaba.fastjson.JSON;
import com.community.equity.utils.params.IntentKeys;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Message;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.NotificationInfo;
import com.community.imsdk.dto.constants.ContentType;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.ResponseCode;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.response.BaseResponse;
import com.community.imsdk.imutils.TransformUtils;

/**
 * Created by dufeng on 16/5/10.<br/>
 * Description: PrivateMessageActivity
 */
public class PrivateMessageActivity extends BaseMessageActivity {

    private static final String TAG = "===PrivateMessageActivity===";
    private UserInfo userInfo;


    @Override
    protected int showSessionType() {
        return SessionType.PRIVATE_CHAT.code;
    }

    @Override
    protected String showNotifyTag() {
        return NotificationInfo.PRIVATE_MSG;
    }

    @Override
    protected void updateViewData() {
        userInfo = DBHelper.getInstance().queryUniqueUserInfo(nowChatId);
        String title;
        if (userInfo == null) {
            title = "USER" + nowChatId;
        } else {
            title = userInfo.showName();
        }
        tvTitle.setText(title);
    }

    @Override
    protected boolean isShowMemberName() {
        return false;
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        super.receiverMessageFail(messageType, request, response);
        switch (messageType) {
            case SEND_MESSAGE:
                BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                if (baseResponse.getCode() != null && baseResponse.getCode().equals(ResponseCode.CHECK_FRIENDSHIP_FAIL)) {
                    sendLocalTextMsg("很抱歉，你们还不是好友关系，请先发送好友验证请求，对方验证通过后，才能聊天。<发送好友验证|community://friend/verification?id=" + nowChatId + "&msg=我是" + DBHelper.getInstance().queryMyInfo().getName() + " />");
                }
                break;
        }
    }


    private void sendLocalTextMsg(String str) {
        if (!str.isEmpty()) {
//            int count = messageAdapter.getItemCount();
//            if (count > 0) {
//                rvContent.smoothScrollToPosition(count - 1);
//            }
            Message message = new Message();
            message.setChatId(nowChatId);
            message.setSendUserId(-1L);
            message.setTimestamp(System.currentTimeMillis());
            message.setContent(str);
            message.setContentType(ContentType.LOCAL.code);
            message.setSessionType(nowSessionType);
            message.setMsgId(-message.getTimestamp());
            message.setSendStatus(Message.SUCCESS);
            TransformUtils.saveSendMessage(message);


            android.os.Message msg = handler.obtainMessage();
            msg.what = ADD_MSG;
            msg.obj = message;
            handler.sendMessageDelayed(msg, 150);
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.iv_activity_message_setting:
                if (userInfo != null) {
                    Intent intent = new Intent(this, PrivateMessageDetailActivity.class);
                    intent.putExtra(IntentKeys.KEY_TARGET_ID, nowChatId);
                    startActivityForResult(intent, MESSAGE_DETAIL);
                }
                break;
        }
    }
}
