package com.community.equity;

import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.NetworkTool;
import com.community.equity.view.TopView;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.AddFriendRequest;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.SendMessageQueue;
import com.community.imsdk.imutils.callback.IReceiver;

/**
 * Created by dufeng on 16/8/31.<br/>
 * Description: AddContactRequestActivity
 */
public class FriendVerificationActivity extends BaseActivity implements View.OnClickListener, IReceiver {
    private EditText etVerification;
    private int userId;
    private String msg;
    private String userName;
    private BaseDialogFragment dialogFragment = new BaseDialogFragment();

    private MessageType[] msgTypeArray = {
            MessageType.ADD_FRIEND
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_friend_verification);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);

        Uri uri = getIntent().getData();
        if (uri == null) {
            if (getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1) == -1) {
                userId = (int) getIntent().getLongExtra(IntentKeys.KEY_USER_ID, -1);
            } else {
                userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);
            }
            msg = getIntent().getStringExtra(IntentKeys.KEY_VERIFICATION_MSG);
            userName = getIntent().getStringExtra(IntentKeys.KEY_USER_NAME);
        } else {
            msg = uri.getQueryParameter("msg");
            userId = Integer.valueOf(uri.getQueryParameter("id"));
        }
        initView();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }

    private void initView() {
        TopView topView = (TopView) findViewById(R.id.topview);
        etVerification = (EditText) findViewById(R.id.et_activity_friend_verification);
        if (!TextUtils.isEmpty(msg)) {
            etVerification.setText(msg);
        }

        topView.setTitle(R.string.text_friend_verification);
        topView.setRightText("添加", getResources().getColor(R.color.profile_un_follow_bg));
        topView.getLeftView().setOnClickListener(this);
        topView.getRightView().setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                finishActivity();
                break;
            case R.id.iv_right:
                String str = etVerification.getText().toString().trim();
                if (NetworkTool.isNetworkAvailable(mContext)) {
                    dialogFragment.addProgress().show(getSupportFragmentManager(), "add_friend");
                    SendMessageQueue.getInstance().addSendMessage(MessageType.ADD_FRIEND,
                            new AddFriendRequest(userId, str));
                    if (!TextUtils.isEmpty(userName)) {
                        finishActivity();
                    }
                } else {
                    Toast.makeText(mContext, "好友请求发送失败，请检查网络设置", Toast.LENGTH_SHORT).show();
                }
                break;
        }
    }

    private void finishActivity() {
        Utils.hideInput(etVerification);
        finish();
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case ADD_FRIEND:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialogFragment.dismissAllowingStateLoss();
                        Toast.makeText(FriendVerificationActivity.this, "请求已发送", Toast.LENGTH_SHORT).show();
                    }
                });
                finishActivity();
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        switch (messageType) {
            case ADD_FRIEND:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialogFragment.dismissAllowingStateLoss();
                        Toast.makeText(FriendVerificationActivity.this, "好友请求发送失败，请稍后重试", Toast.LENGTH_SHORT).show();
                    }
                });
                break;
        }
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        switch (messageType) {
            case ADD_FRIEND:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dialogFragment.dismissAllowingStateLoss();
                        Toast.makeText(FriendVerificationActivity.this, "好友请求发送失败，请检查网络", Toast.LENGTH_SHORT).show();
                    }
                });
                break;
        }
    }
}
