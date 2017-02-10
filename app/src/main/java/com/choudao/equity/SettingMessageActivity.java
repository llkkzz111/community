package com.choudao.equity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.SwitchCompat;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.LinearLayout;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.SetUserConfigRequest;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;

/**
 * Created by liuzhao on 16/6/1.
 */
public class SettingMessageActivity extends BaseActivity implements CompoundButton.OnCheckedChangeListener {

    private TopView topView;
    private LinearLayout llDetail;
    private SwitchCompat switchPrompt;
    private SwitchCompat switchDetails;
    private SwitchCompat switchVoice;
    private SwitchCompat switchVibrate;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting_message_layout);
        initView();
    }

    private void initView() {
        topView = (TopView) findViewById(R.id.topview);
        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        topView.setTitle("新消息通知");

        llDetail = (LinearLayout) findViewById(R.id.ll_activity_setting_message_detail);

        switchPrompt = (SwitchCompat) findViewById(R.id.switch_new_message_prompt);
        switchDetails = (SwitchCompat) findViewById(R.id.switch_notify_details);
        switchVoice = (SwitchCompat) findViewById(R.id.switch_notify_voice);
        switchVibrate = (SwitchCompat) findViewById(R.id.switch_notify_vibrate);


        boolean isMsgPrompt = PreferencesUtils.getMessagePromptState();
        if (isMsgPrompt) {
            llDetail.setVisibility(View.VISIBLE);
        } else {
            llDetail.setVisibility(View.GONE);
        }
        switchPrompt.setChecked(isMsgPrompt);
        switchDetails.setChecked(PreferencesUtils.getNotifyDetailsState());
        switchVoice.setChecked(PreferencesUtils.getNotifyVoiceState());
        switchVibrate.setChecked(PreferencesUtils.getNotifyVibrateState());

        switchPrompt.setOnCheckedChangeListener(this);
        switchDetails.setOnCheckedChangeListener(this);
        switchVoice.setOnCheckedChangeListener(this);
        switchVibrate.setOnCheckedChangeListener(this);
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.switch_new_message_prompt:
                if (isChecked) {
                    llDetail.setVisibility(View.VISIBLE);
                } else {
                    llDetail.setVisibility(View.GONE);
                }
                sendMsgConfig(isChecked, PreferencesUtils.getNotifyDetailsState());
                break;
            case R.id.switch_notify_details:
                sendMsgConfig(PreferencesUtils.getMessagePromptState(), isChecked);
                break;
            case R.id.switch_notify_voice:
                PreferencesUtils.setNotifyVoiceState(isChecked);
                break;
            case R.id.switch_notify_vibrate:
                PreferencesUtils.setNotifyVibrateState(isChecked);
                break;
        }
    }

    private void sendMsgConfig(boolean isAccept, boolean isShowDetail) {
        SendMessageQueue.getInstance().addSendMessage(MessageType.SET_USER_CONFIG,
                new SetUserConfigRequest(isAccept, isShowDetail, PreferencesUtils.getFriendConfirmationState()));
    }


}
