package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.SwitchCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.community.equity.adapter.GroupMemberAdapter;
import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.entity.NoticeInfo;
import com.community.equity.popup.ReportChatPopupWindow;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.MyGridView;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.GroupInfo;
import com.community.imsdk.db.bean.SessionConfig;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.ResponseCode;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.request.LeaveGroupRequest;
import com.community.imsdk.dto.request.SetSessionConfigRequest;
import com.community.imsdk.dto.response.BaseResponse;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.SendMessageQueue;
import com.community.imsdk.imutils.callback.IReceiver;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnItemClick;

/**
 * Created by liuz on 16/10/24.<br/>
 * Description: GroupChatDetailActivity
 */
public class GroupChatDetailActivity extends BaseActivity implements IReceiver {
    BaseDialogFragment dialogFragment = new BaseDialogFragment();
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.gv_chat_menber) MyGridView gvChatMenber;
    @BindView(R.id.tv_group_name) TextView tvGroupName;
    @BindView(R.id.tv_group_notice) TextView tvGroupNotice;
    @BindView(R.id.tv_group_notice_hint) TextView tvGroupNoticeHint;
    @BindView(R.id.switch_privatemsg_top) SwitchCompat switchTop;
    @BindView(R.id.switch_privatemsg_mute) SwitchCompat switchMute;
    @BindView(R.id.tv_group_member_all) TextView tvGroupMemberAll;
    @BindView(R.id.ll_group_member_all) LinearLayout llGroupMemberAll;
    @BindView(R.id.rl_loading) RelativeLayout rlLoading;
    @BindView(R.id.tv_loading) TextView tvLoading;

    private SessionConfig sessionConfig;
    private GroupInfo groupInfo;
    private long groupID;
    private long menberCount = 0;
    private boolean isClearMsg = false;
    private List<UserInfo> userInfos = new ArrayList<>();
    private GroupMemberAdapter adapter;

    private MessageType[] msgTypeArray = {
            MessageType.LEAVE_GROUP,
            MessageType.LOCAL_GROUP_INFO_CHANGED,
            MessageType.LOCAL_GROUP_MEMBER_CHANGED
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_chat_detail);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        ButterKnife.bind(this);
        topView.setTitle("聊天详情");
        topView.setLeftImage();
        groupID = getIntent().getLongExtra(IntentKeys.KEY_TARGET_ID, 0);
        initData();
        showView();
    }

    private void initData() {
        initGroupInfo();
        initSessionConfig();
        initGroupMember();
    }

    private void initGroupInfo() {
        groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(groupID);
    }

    private void initSessionConfig() {
        sessionConfig = DBHelper.getInstance().queryUniqueSessionConfig(groupID, SessionType.GROUP_CHAT.code);
        if (sessionConfig == null) {
            sessionConfig = new SessionConfig();
            sessionConfig.setTargetId(groupID);
            sessionConfig.setSessionType(SessionType.GROUP_CHAT.code);
            sessionConfig.setIsTop(false);
            sessionConfig.setIsMute(false);
        }
    }

    private void initGroupMember() {
        List<UserInfo> groupMember = DBHelper.getInstance().queryGroupMembers(groupID, groupShowCount());
        userInfos.clear();
        userInfos.addAll(groupMember);
        userInfos.add(new UserInfo("add"));
        if (groupInfo.getHolder().intValue() == ConstantUtils.USER_ID && userInfos.size() > 2)
            userInfos.add(new UserInfo("del"));
        menberCount = DBHelper.getInstance().queryGroupMemberCount(groupID);
    }

    private int groupShowCount() {
        if (groupInfo.getHolder().intValue() == ConstantUtils.USER_ID) {
            return 38;
        } else {
            return 39;
        }
    }

    private void showView() {
        switchTop.setChecked(sessionConfig.getIsTop());
        switchMute.setChecked(sessionConfig.getIsMute());
        showGroupInfo();
        showGroupMember();
    }

    private void showGroupMember() {
        adapter = new GroupMemberAdapter(this, userInfos);
        adapter.setGroupInfo(groupInfo);
        gvChatMenber.setAdapter(adapter);
        adapter.notifyDataSetChanged();
        if (menberCount == groupShowCount()) {
            llGroupMemberAll.setVisibility(View.GONE);
        } else {
            llGroupMemberAll.setVisibility(View.VISIBLE);
        }
        tvGroupMemberAll.setText("全部群成员(" + menberCount + ")");
    }

    private void showGroupInfo() {
        tvGroupName.setText(groupInfo.getName());
        showNotice(groupInfo.getNotice());
    }

    private void showNotice(String data) {
        if (TextUtils.isEmpty(data)) return;

        NoticeInfo info = new Gson().fromJson(data, NoticeInfo.class);
        tvGroupNotice.setText(info.getData());
        if (TextUtils.isEmpty(info.getData())) {
            tvGroupNotice.setVisibility(View.GONE);
            tvGroupNoticeHint.setVisibility(View.VISIBLE);
        } else {
            tvGroupNotice.setVisibility(View.VISIBLE);
            tvGroupNoticeHint.setVisibility(View.GONE);
        }
    }

    @OnClick({R.id.iv_left, R.id.ll_group_chat_clear, R.id.ll_privatemsg_report, R.id.ll_group_name, R.id.ll_group_notice, R.id.ll_group_member_all, R.id.ll_leave_group})
    public void onClick(View v) {
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_GROUP_ID, groupID);
        intent.putExtra(IntentKeys.KEY_GROUP_NAME, groupInfo.getName());
        switch (v.getId()) {
            case R.id.iv_left:
                finishActivity();
                break;
            case R.id.ll_group_chat_clear:
                showClearMsgDialog();
                break;
            case R.id.ll_privatemsg_report:
                ReportChatPopupWindow chatPopupWindow = new ReportChatPopupWindow(mContext);
                chatPopupWindow.popShow(topView);
                break;
            case R.id.ll_group_name:
                intent.setClass(mContext, GroupChatNameChengeActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_group_notice:
                NoticeInfo noticeInfo = new Gson().fromJson(groupInfo.getNotice(), NoticeInfo.class);
                if (groupInfo.getHolder() == ConstantUtils.USER_ID || !TextUtils.isEmpty(groupInfo.getNotice()) && !TextUtils.isEmpty(noticeInfo.getData())) {
                    intent.setClass(mContext, GroupChatNoticeActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(mContext, "只有群主可以编辑群公告", Toast.LENGTH_SHORT).show();
                }
                break;
            case R.id.ll_group_member_all:
                intent.setClass(mContext, GroupChatAllMemberActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_leave_group:

                dialogFragment.addContent("退出后不会通知群聊中其他成员，且不会再接受此群聊信息").addButton(1, "取消", null).addButton(2, "确定", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialogFragment = new BaseDialogFragment();
                        dialogFragment.addProgress("正在退出群聊...").show(getSupportFragmentManager(), "leave_loading");
                        SendMessageQueue.getInstance().addSendMessage(MessageType.LEAVE_GROUP,
                                new LeaveGroupRequest(groupID));
                    }
                }).show(getSupportFragmentManager(), "kickoutgroup");

                break;
        }
    }

    private void showClearMsgDialog() {
        BaseDialogFragment dialogFragment = new BaseDialogFragment();
        dialogFragment.addContent("是否清空聊天记录")
                .addButton(1, "取消", null)
                .addButton(2, "确定", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        DBHelper.getInstance().clearChat(groupID, SessionType.GROUP_CHAT.code);
                        DBHelper.getInstance().clearSessionText(groupID, SessionType.GROUP_CHAT.code);
                        isClearMsg = true;
                        Toast.makeText(mContext, "聊天记录已清空", Toast.LENGTH_SHORT).show();
                    }
                }).show(getSupportFragmentManager(), "dialog");
    }

    @OnCheckedChanged({R.id.switch_privatemsg_mute, R.id.switch_privatemsg_top})
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.switch_privatemsg_top:
                sessionConfig.setIsTop(isChecked);
                if (isChecked) {
                    sessionConfig.setTopTime(System.currentTimeMillis());
                } else {
                    sessionConfig.setTopTime(0L);
                }
                break;
            case R.id.switch_privatemsg_mute:
                sessionConfig.setIsMute(isChecked);
                break;
        }
        long rowId = DBHelper.getInstance().saveSessionConfig(sessionConfig);

        if (rowId != -1) {
            SendMessageQueue.getInstance().addSendMessage(MessageType.SET_SESSION_CONFIG,
                    new SetSessionConfigRequest(groupID,
                            SessionType.GROUP_CHAT.code,
                            sessionConfig.getIsMute(),
                            sessionConfig.getIsTop()));
        }
    }

    @Override
    public void onBackPressed() {
        if (rlLoading.getVisibility() != View.VISIBLE) {
            finishActivity();
            super.onBackPressed();
        }
    }


    private void finishActivity() {
        Intent intent = new Intent();
        intent.putExtra("isClearMsg", isClearMsg);
        setResult(0, intent);
        finish();
    }


    @OnItemClick(R.id.gv_chat_menber)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        UserInfo info = userInfos.get(position);
        Intent intent = new Intent();
        if (!TextUtils.isEmpty(info.getState())) {
            intent.putExtra(IntentKeys.KEY_GROUP_ID, groupID);
            if (info.getState().equals("add")) {
                intent.putExtra(IntentKeys.KEY_GROUP_SELECT_TYPE, GroupSelectContactsActivity.SELECT_TYPE_ADD);
            } else if (info.getState().equals("del")) {
                intent.putExtra(IntentKeys.KEY_GROUP_SELECT_TYPE, GroupSelectContactsActivity.SELECT_TYPE_DELETE);
            }
            intent.setClass(mContext, GroupSelectContactsActivity.class);
            startActivity(intent);
        } else {
            intent.setClass(mContext, PersonalProfileActivity.class);
            intent.putExtra(IntentKeys.KEY_USER_ID, info.getUserId());
            intent.putExtra(IntentKeys.KEY_USER_NAME, info.getName());
            startActivity(intent);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }

    @Override
    public void receiverMessageSuccess(final MessageType messageType, BaseRequest request, Object response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                switch (messageType) {
                    case LOCAL_GROUP_INFO_CHANGED:
                        initGroupInfo();
                        showGroupInfo();
                        break;
                    case LOCAL_GROUP_MEMBER_CHANGED:
                        initGroupMember();
                        showGroupMember();
                        break;
                    case LEAVE_GROUP:
                        dismissDialog();
                        Intent intent = new Intent(mContext, MainActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        startActivity(intent);
                        break;
                }
            }
        });

    }

    @Override
    public void receiverMessageFail(final MessageType messageType, BaseRequest request, final MessageDTO response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                switch (messageType) {
                    case LEAVE_GROUP:
                        dismissDialog();
                        BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                        if (baseResponse.getCode().equals(ResponseCode.OPERATION_DONE_BY_OTHER)) {
                            Toast.makeText(mContext, "你已经不在群里", Toast.LENGTH_SHORT).show();
                            finish();
                        }
                        break;
                }

            }
        });
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        switch (messageType) {
            case LEAVE_GROUP:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dismissDialog();
                        Toast.makeText(mContext, "网络不畅，退群失败，请稍后再试", Toast.LENGTH_SHORT).show();
                    }
                });
                break;
        }
    }

    private void dismissDialog() {
        if (dialogFragment != null && dialogFragment.isShow()) {
            dialogFragment.dismissAllowingStateLoss();
        }
    }

}
