package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.SwitchCompat;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.popup.ReportChatPopupWindow;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.SessionConfig;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.constants.UserType;
import com.community.imsdk.dto.request.SetSessionConfigRequest;
import com.community.imsdk.imutils.SendMessageQueue;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

/**
 * Created by dufeng on 16/7/11.<br/>
 * Description: PrivateMessageDetail
 */
public class PrivateMessageDetailActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.iv_privatemsg_detail_user) ImageView ivUser;
    @BindView(R.id.tv_privatemsg_detail_user) TextView tvUser;
    @BindView(R.id.btn_privatemsg_detail_add) Button btnAdd;
    @BindView(R.id.switch_privatemsg_top) SwitchCompat switchTop;
    @BindView(R.id.switch_privatemsg_mute) SwitchCompat switchMute;

    private SessionConfig sessionConfig;
    private UserInfo userInfo;
    private long nowUserId;
    private boolean isClearMsg = false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_privatemsg_detail);
        ButterKnife.bind(this);
        initView();
        initData();
    }

    private void initView() {
        topView.setTitle("聊天详情");
        topView.setLeftImage();
    }

    private void initData() {
        nowUserId = getIntent().getLongExtra(IntentKeys.KEY_TARGET_ID, 0);
        userInfo = DBHelper.getInstance().queryUniqueUserInfo(nowUserId);
        sessionConfig = DBHelper.getInstance().queryUniqueSessionConfig(nowUserId, SessionType.PRIVATE_CHAT.code);
        if (sessionConfig == null) {
            sessionConfig = new SessionConfig();
            sessionConfig.setTargetId(nowUserId);
            sessionConfig.setSessionType(SessionType.PRIVATE_CHAT.code);
            sessionConfig.setIsTop(false);
            sessionConfig.setIsMute(false);
        }
        if (userInfo.getUserType() == UserType.SYSTEM.code) {
            btnAdd.setVisibility(View.GONE);
        }
        switchTop.setChecked(sessionConfig.getIsTop());
        switchMute.setChecked(sessionConfig.getIsMute());
    }

    @Override
    protected void onResume() {
        super.onResume();
        userInfo = DBHelper.getInstance().queryUniqueUserInfo(nowUserId);
        if (Util.isOnMainThread() && !isDestory)
            Glide.with(mContext).load(userInfo.getHeadImgUrl()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                    .into(ivUser);
        tvUser.setText(userInfo.showName());
    }


    @OnClick({R.id.iv_left, R.id.iv_privatemsg_detail_user, R.id.btn_privatemsg_detail_add, R.id.ll_privatemsg_clear, R.id.ll_privatemsg_report})
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.iv_left:
                finishActivity();
                break;
            case R.id.iv_privatemsg_detail_user:
                intent = new Intent(this, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, nowUserId);
                intent.putExtra(IntentKeys.KEY_USER_NAME, userInfo.getName());
                startActivity(intent);
                break;
            case R.id.btn_privatemsg_detail_add:
                intent = new Intent(this, GroupSelectContactsActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, nowUserId);
                intent.putExtra(IntentKeys.KEY_GROUP_SELECT_TYPE, GroupSelectContactsActivity.SELECT_TYPE_CREATE);
                startActivity(intent);
                break;
            case R.id.ll_privatemsg_clear:
                showClearMsgDialog();
                break;
            case R.id.ll_privatemsg_report:
                ReportChatPopupWindow chatPopupWindow = new ReportChatPopupWindow(mContext);
                chatPopupWindow.popShow(topView);
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
                        DBHelper.getInstance().clearChat(nowUserId, SessionType.PRIVATE_CHAT.code);
                        DBHelper.getInstance().clearSessionText(nowUserId, SessionType.PRIVATE_CHAT.code);
                        isClearMsg = true;
                        Toast.makeText(mContext, "聊天记录已清空", Toast.LENGTH_SHORT).show();
                    }
                }).show(getSupportFragmentManager(), "dialog");
    }

    @OnCheckedChanged({R.id.switch_privatemsg_top, R.id.switch_privatemsg_mute})
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
                    new SetSessionConfigRequest(nowUserId,
                            SessionType.PRIVATE_CHAT.code,
                            sessionConfig.getIsMute(),
                            sessionConfig.getIsTop()));
        }
    }

    @Override
    public void onBackPressed() {
        finishActivity();
        super.onBackPressed();
    }

    private void finishActivity() {
        Intent intent = new Intent();
        intent.putExtra("isClearMsg", isClearMsg);
        setResult(0, intent);
        finish();
    }

}
