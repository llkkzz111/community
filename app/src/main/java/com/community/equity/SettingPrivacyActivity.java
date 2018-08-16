package com.community.equity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.SwitchCompat;
import android.view.View;
import android.widget.CompoundButton;

import com.community.equity.base.BaseActivity;
import com.community.equity.utils.PreferencesUtils;
import com.community.equity.view.TopView;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.SetUserConfigRequest;
import com.community.imsdk.imutils.SendMessageQueue;

/**
 * Created by dufeng on 16/9/21.<br/>
 * Description: SettingPrivacyActivity
 */

public class SettingPrivacyActivity extends BaseActivity implements CompoundButton.OnCheckedChangeListener {
    private TopView topView;
    private SwitchCompat switchFriendConfirmation;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting_privacy);

        topView = (TopView) findViewById(R.id.topview);
        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        topView.setTitle("隐私");

        switchFriendConfirmation = (SwitchCompat) findViewById(R.id.switch_friend_confirmation);
        switchFriendConfirmation.setChecked(PreferencesUtils.getFriendConfirmationState());

        switchFriendConfirmation.setOnCheckedChangeListener(this);
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.switch_friend_confirmation:
                SendMessageQueue.getInstance().addSendMessage(MessageType.SET_USER_CONFIG,
                        new SetUserConfigRequest(
                                PreferencesUtils.getMessagePromptState(),
                                PreferencesUtils.getNotifyDetailsState(),
                                isChecked));
                break;
        }
    }

}
