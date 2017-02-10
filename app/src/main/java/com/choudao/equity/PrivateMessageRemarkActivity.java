package com.choudao.equity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.NetworkTool;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.SetFriendRemarkRequest;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by dufeng on 16/5/10.<br/>
 * Description: PrivateMessageActivity
 */
public class PrivateMessageRemarkActivity extends BaseActivity implements View.OnClickListener, IReceiver {

    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.et_remark) EditText etRemark;
    private UserInfo userInfo;
    private String remark;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageType(MessageType.SET_FRIEND_REMARK, this);
        setContentView(R.layout.activity_remark_info_layout);
        ButterKnife.bind(this);

        userInfo = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        initView();
    }

    @Override
    protected void onDestroy() {
        IMMessageDispatcher.unbindMessageType(MessageType.SET_FRIEND_REMARK, this);
        super.onDestroy();
    }

    private void initView() {
        topView.setTitle("备注信息");
        topView.setRightText("完成");
        topView.setLeftImage();
        etRemark.setText(userInfo.showName());
        if (!TextUtils.isEmpty(userInfo.showName()))
            etRemark.setSelection(userInfo.showName().length() > 20 ? 20 : userInfo.showName().length());
    }


    @OnClick({R.id.iv_right, R.id.iv_left, R.id.et_remark})
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.iv_right:

                remark = etRemark.getText().toString().trim();
                if (NetworkTool.isNetworkAvailable(mContext)) {
                    SendMessageQueue.getInstance().addSendMessage(MessageType.SET_FRIEND_REMARK,
                            new SetFriendRemarkRequest(userInfo.getUserId(), remark));
                } else {
                    Toast.makeText(mContext, "网络未连接，无法添加备注，请检查网络设置", Toast.LENGTH_SHORT).show();
                }

                break;
            case R.id.iv_left:
                finishActivity();
                break;
            case R.id.et_remark:
                break;

        }
    }

    private void finishActivity() {
        Utils.hideInput(etRemark);
        finish();
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case SET_FRIEND_REMARK:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(PrivateMessageRemarkActivity.this, "备注修改成功", Toast.LENGTH_SHORT).show();
                    }
                });
                finishActivity();
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {

    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

    }

}
