package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Toast;

import com.community.equity.entity.NoticeInfo;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.params.IntentKeys;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.GroupInfo;
import com.community.imsdk.dto.NotificationInfo;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.google.gson.Gson;

/**
 * Created by dufeng on 16/10/25.<br/>
 * Description: GroupMessageActivity
 */

public class GroupMessageActivity extends BaseMessageActivity {

    private static final String TAG = "===GroupMessageActivity===";
    private GroupInfo groupInfo;
    private long memberCount;

    private MessageType[] msgTypeArray = {
            MessageType.LOCAL_GROUP_MEMBER_CHANGED,
            MessageType.LOCAL_GROUP_KICK_OUT,
            MessageType.LOCAL_GROUP_INFO_CHANGED,
            MessageType.GET_GROUP_INFO_AND_MEMBER
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);

        tvMemberCount.setVisibility(View.VISIBLE);
        llNotice.setOnClickListener(this);
        ivSetting.setImageResource(R.drawable.icon_groupsetting);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }

    @Override
    protected int showSessionType() {
        return SessionType.GROUP_CHAT.code;
    }

    @Override
    protected String showNotifyTag() {
        return NotificationInfo.GROUP_MSG;
    }

    @Override
    protected void updateViewData() {
        groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(nowChatId);
        String title;
        if (groupInfo != null && !TextUtils.isEmpty(groupInfo.getName())) {
            title = groupInfo.getName();
        } else {
            title = "群聊";
        }
        tvTitle.setText(title);
        NoticeInfo info = null;
        if (groupInfo != null && groupInfo.getNotice() != null) {
            info = new Gson().fromJson(groupInfo.getNotice(), NoticeInfo.class);
            tvNotice.setText(TextUtils.isEmpty(info.getData()) ? "暂无公告" : info.getData());
        } else {
            tvNotice.setText("暂无公告");
        }
        if (groupInfo == null || groupInfo.getIsKickOut()) {
            ivSetting.setVisibility(View.INVISIBLE);
            ivNotice.setVisibility(View.INVISIBLE);
            ivSetting.setOnClickListener(null);
            ivNotice.setOnClickListener(null);
        } else {
            ivSetting.setVisibility(View.VISIBLE);
            ivNotice.setVisibility(View.VISIBLE);
            ivSetting.setOnClickListener(this);
            ivNotice.setOnClickListener(this);
        }
        if (groupInfo == null) {
            return;
        }

        memberCount = DBHelper.getInstance().queryGroupMemberCount(nowChatId);
        tvMemberCount.setText("(" + memberCount + ")");
        if (groupInfo.getIsNewNotice() && info != null && !TextUtils.isEmpty(info.getData())) {
            ivNotice.setImageResource(R.drawable.icon_notice_open);
            llNotice.setVisibility(View.VISIBLE);
        } else {
            ivNotice.setImageResource(R.drawable.icon_notice_close);
            llNotice.setVisibility(View.GONE);
        }
    }

    @Override
    protected boolean isShowMemberName() {
        return memberCount > 20;
    }


    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        super.receiverMessageSuccess(messageType, request, response);
        switch (messageType) {
            case LOCAL_GROUP_MEMBER_CHANGED:
            case LOCAL_GROUP_KICK_OUT:
            case LOCAL_GROUP_INFO_CHANGED:
            case GET_GROUP_INFO_AND_MEMBER:
                long groupId = (long) response;
                if (groupId == nowChatId) {
                    loadDBData();
                }
                break;
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        Intent intent;
        switch (v.getId()) {
            case R.id.iv_activity_message_setting:
                intent = new Intent(this, GroupChatDetailActivity.class);
                intent.putExtra(IntentKeys.KEY_TARGET_ID, nowChatId);
                startActivityForResult(intent, MESSAGE_DETAIL);
                break;
            case R.id.iv_activity_message_notice:
                if (groupInfo == null) {
                    return;
                }
                if (groupInfo.getIsNewNotice()) {
                    groupInfo.setIsNewNotice(false);
                    DBHelper.getInstance().saveGroupInfo(groupInfo);
                    ivNotice.setImageResource(R.drawable.icon_notice_close);
                    llNotice.setVisibility(View.GONE);
                } else {
                    groupInfo.setIsNewNotice(true);
                    DBHelper.getInstance().saveGroupInfo(groupInfo);
                    ivNotice.setImageResource(R.drawable.icon_notice_open);
                    llNotice.setVisibility(View.VISIBLE);
                }
                break;
            case R.id.ll_activity_message_notice:
                if (groupInfo == null) {
                    return;
                }
                groupInfo.setIsNewNotice(false);
                DBHelper.getInstance().saveGroupInfo(groupInfo);
                ivNotice.setImageResource(R.drawable.icon_notice_close);
                llNotice.setVisibility(View.GONE);
                if (groupInfo.getHolder() == ConstantUtils.USER_ID || !TextUtils.isEmpty(groupInfo.getNotice())) {
                    intent = new Intent(mContext, GroupChatNoticeActivity.class);
                    intent.putExtra(IntentKeys.KEY_GROUP_ID, groupInfo.getGroupId());
                    startActivity(intent);
                } else {
                    Toast.makeText(mContext, "只有群主可以编辑群公告", Toast.LENGTH_SHORT).show();
                }
                break;
        }
    }
}
