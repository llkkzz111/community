package com.community.equity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.utils.StringUtil;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.ResponseCode;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.dto.request.UpdateGroupInfoRequest;
import com.community.imsdk.dto.response.BaseResponse;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.SendMessageQueue;
import com.community.imsdk.imutils.callback.IReceiver;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;


public class GroupChatNameChengeActivity extends BaseActivity implements IReceiver {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.et_group_name_update) EditText etGroupName;
    @BindView(R.id.iv_right) TextView tvRight;
    @BindView(R.id.rl_loading) RelativeLayout rlLoading;
    @BindView(R.id.tv_loading) TextView tvLoading;

    @BindColor(R.color.dialog_ok_checked) int canCheck;
    @BindColor(R.color.dim_gray) int cannotCheck;

    private long groupId;
    private String groupName;
    private BaseDialogFragment dialogFragment = new BaseDialogFragment();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_name_layout);
        ButterKnife.bind(this);
        IMMessageDispatcher.bindMessageType(MessageType.UPDATE_GROUP_INFO, this);
        groupId = getIntent().getLongExtra(IntentKeys.KEY_GROUP_ID, -1);
        groupName = getIntent().getStringExtra(IntentKeys.KEY_GROUP_NAME);
        initView();
    }

    private void initView() {
        topView.setTitle("群名称");
        tvRight.setTextColor(cannotCheck);
        topView.setLeftImage();
        etGroupName.setVisibility(View.VISIBLE);
        etGroupName.setText(groupName);
        if (!TextUtils.isEmpty(groupName)) {
            etGroupName.setSelection(groupName.length());
        }
        topView.setRightText(R.string.text_complete);
    }

    @OnClick({R.id.iv_right, R.id.iv_left})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                Utils.hideInput(topView);
                finish();
                break;
            case R.id.iv_right:
                final String groupName = etGroupName.getText().toString();

                if (groupName.equals(this.groupName)) {
                    Toast.makeText(mContext, "群名称并未修改", Toast.LENGTH_SHORT).show();
                    return;
                }


                if (TextUtils.isEmpty(groupName)) {
                    dialogFragment = new BaseDialogFragment();
                    dialogFragment.addContent("是否要清空群昵称").addButton(1, "取消", null).addButton(2, "确定", new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            dialogFragment = new BaseDialogFragment();
                            dialogFragment.addProgress("正在保存...").show(getSupportFragmentManager(), "showloading");
                            SendMessageQueue.getInstance().addSendMessage(MessageType.UPDATE_GROUP_INFO,
                                    new UpdateGroupInfoRequest(groupId, groupName, null));
                        }
                    }).show(getSupportFragmentManager(), "clean_group_name");
                } else {
                    dialogFragment.addProgress("正在保存...").show(getSupportFragmentManager(), "chenge_name_loading");
                    SendMessageQueue.getInstance().addSendMessage(MessageType.UPDATE_GROUP_INFO,
                            new UpdateGroupInfoRequest(groupId, groupName, null));
                }

                break;

        }
    }

    @OnTextChanged(value = R.id.et_group_name_update, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChenge(CharSequence text) {
        String name = etGroupName.getText().toString();
        checkInputTextLength(StringUtil.getStringLength(name));
    }


    private void checkInputTextLength(int contentLength) {
        setRightTextColor(contentLength);
        if (contentLength > 32) {
            setTitleDisable();
        } else {
            setTitleEnabled();
        }
    }

    /**
     * 设置发布按钮的字体颜色
     */
    private void setRightTextColor(int contentLength) {
        if (contentLength > 32) {
            tvRight.setEnabled(false);
            tvRight.setTextColor(cannotCheck);
        } else {
            tvRight.setEnabled(true);
            tvRight.setTextColor(canCheck);
        }
    }

    private void setTitleDisable() {
        if (topView.getTitleView().getText().toString().startsWith("群名称")) {
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
            topView.setTitle("您输入的群名称过长");
        }
    }

    private void setTitleEnabled() {
        if (topView.getTitleView().getText().toString().startsWith("您输入")) {
            topView.setTitle("群名称");
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
        }
    }

    private void dismissDialog() {
        if (dialogFragment.isShow()) {
            dialogFragment.dismissAllowingStateLoss();
        }
    }

    private void showLoading(String text) {
        if (TextUtils.isEmpty(text)) {
            tvLoading.setVisibility(View.GONE);
        }
        tvLoading.setText(text);
        rlLoading.setVisibility(View.VISIBLE);
    }

    private void dismissLoading() {
        rlLoading.setVisibility(View.GONE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IMMessageDispatcher.unbindMessageType(MessageType.UPDATE_GROUP_INFO, this);
    }


    @Override
    public void receiverMessageSuccess(MessageType messageType, final BaseRequest request, Object response) {
        switch (messageType) {
            case UPDATE_GROUP_INFO:
                final UpdateGroupInfoRequest groupInfoRequest = (UpdateGroupInfoRequest) request;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dismissDialog();
                        if (TextUtils.isEmpty(groupInfoRequest.getNotice())) {
                            Toast.makeText(mContext, "修改成功", Toast.LENGTH_SHORT).show();
                            finish();
                        }
                    }
                });
                break;
        }

    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        switch (messageType) {
            case UPDATE_GROUP_INFO:
                final BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                final UpdateGroupInfoRequest groupInfoRequest = (UpdateGroupInfoRequest) request;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dismissDialog();
                        if (TextUtils.isEmpty(groupInfoRequest.getNotice())) {
                            if (baseResponse.getCode().equals(ResponseCode.NOT_GROUP_MEMBER)) {
                                Toast.makeText(mContext, "非群组成员", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(mContext, "修改失败", Toast.LENGTH_SHORT).show();
                            }
                        }
                    }
                });
                break;
        }
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {
        switch (messageType) {
            case UPDATE_GROUP_INFO:
                final UpdateGroupInfoRequest groupInfoRequest = (UpdateGroupInfoRequest) request;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dismissDialog();
                        if (TextUtils.isEmpty(groupInfoRequest.getNotice())) {
                            Toast.makeText(mContext, "网络不畅，修改失败，请稍后再试", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
                break;
        }
    }
}
