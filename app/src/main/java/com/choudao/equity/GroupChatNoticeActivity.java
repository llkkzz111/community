package com.choudao.equity;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.NoticeInfo;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.StringUtil;
import com.choudao.equity.utils.TimeUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.ResponseCode;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.UpdateGroupInfoRequest;
import com.choudao.imsdk.dto.response.BaseResponse;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.google.gson.Gson;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class GroupChatNoticeActivity extends BaseActivity implements View.OnClickListener, IReceiver {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.iv_user_head) ImageView ivHead;
    @BindView(R.id.tv_chenge_name) TextView tvChengeName;
    @BindView(R.id.tv_chenge_time) TextView tvChengeTime;
    @BindView(R.id.et_group_notice) EditText etNotice;
    @BindView(R.id.rl_notice_tips) RelativeLayout rlTips;
    @BindView(R.id.iv_right) TextView tvRight;
    @BindView(R.id.ll_group_notice_header) LinearLayout llNoticeHeader;
    @BindView(R.id.rl_loading) RelativeLayout rlLoading;
    @BindView(R.id.tv_loading) TextView tvLoading;

    @BindColor(R.color.dialog_ok_checked) int canCheck;
    @BindColor(R.color.dim_gray) int cannotCheck;
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            Utils.showInput(etNotice);
        }
    };
    private GroupInfo groupInfo;
    private long groupId;
    private UserInfo holderInfo;
    private NoticeInfo info;
    private BaseDialogFragment dialogFragment = new BaseDialogFragment();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageType(MessageType.UPDATE_GROUP_INFO, this);
        setContentView(R.layout.activity_group_chat_notice_layout);
        ButterKnife.bind(this);
        initGroupInfo();
        initView();
    }

    private void initGroupInfo() {
        groupId = getIntent().getLongExtra(IntentKeys.KEY_GROUP_ID, -1);
        if (groupId > 0) {
            groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(groupId);
            holderInfo = DBHelper.getInstance().queryUniqueUserInfo(groupInfo.getHolder());
        }
    }

    private void initView() {
        topView.setTitle("群公告");
        topView.setLeftImage();
        Glide.with(mContext).load(holderInfo.getHeadImgUrl()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                .into(ivHead);
        tvChengeName.setText(holderInfo.showName());
        showNotice(groupInfo.getNotice());
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (topView.getRightView().getText().equals("保存"))
            handler.sendEmptyMessageDelayed(1, 100);
    }

    private void showNotice(String data) {
        if (TextUtils.isEmpty(data)) {
            llNoticeHeader.setVisibility(View.GONE);
            topView.setRightText("保存");
        } else {
            info = new Gson().fromJson(data, NoticeInfo.class);
            if (info != null) {
                tvChengeTime.setText(TimeUtils.getFormatDate(info.getTime()));
                etNotice.setText(info.getData());
            }
            if (groupInfo.getHolder() == ConstantUtils.USER_ID) {
                if (TextUtils.isEmpty(info.getData())) {
                    llNoticeHeader.setVisibility(View.GONE);
                    topView.setRightText("保存");
                } else {
                    topView.setRightText("编辑");
                    Utils.hideInput(etNotice);
                    etNotice.setEnabled(false);
                }
            } else {
                etNotice.setEnabled(false);
            }

        }
        if (groupInfo.getHolder() == ConstantUtils.USER_ID) {
            rlTips.setVisibility(View.GONE);
        } else {
            rlTips.setVisibility(View.VISIBLE);
        }
    }

    @OnClick({R.id.iv_left, R.id.iv_right})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.iv_right:
                if (!etNotice.isEnabled()) {
                    etNotice.setEnabled(true);
                    tvRight.setText("保存");
                    etNotice.setSelection(etNotice.getText().length());
                    Utils.showInput(etNotice);
                    return;
                }


                final String notice = etNotice.getText().toString();
                if (info != null && info.getData().equals(notice)) {
                    Toast.makeText(mContext, "公告内容并未被修改!", Toast.LENGTH_SHORT).show();
                    return;
                }
                String content, left, right;
                if (TextUtils.isEmpty(notice)) {
                    content = "确定清空群公告？";
                    left = "取消";
                    right = "清空";
                } else {
                    content = "该公告通知全部群成员，是否发布？";
                    left = "取消";
                    right = "发布";
                }
                dialogFragment = new BaseDialogFragment();
                dialogFragment.addContent(content).addButton(1, left, null).addButton(2, right, new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialogFragment = new BaseDialogFragment();
                        dialogFragment.addProgress("正在保存...").show(getSupportFragmentManager(), "chenge_notice_loading");
                        SendMessageQueue.getInstance().addSendMessage(MessageType.UPDATE_GROUP_INFO,
                                new UpdateGroupInfoRequest(groupId, null, notice));

                    }
                }).show(getSupportFragmentManager(), "clean_group_notice");

                break;
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


    @OnTextChanged(value = R.id.et_group_notice, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChenge(CharSequence text) {
        String name = etNotice.getText().toString();
        checkInputTextLength(StringUtil.getStringLength(name));
    }

    private void checkInputTextLength(int contentLength) {
        setRightTextColor(contentLength);
        if (contentLength > 1000) {
            setTitleDisable();
        } else {
            setTitleEnabled();
        }
    }

    private void dismissDialog() {
        if (dialogFragment.isShow()) {
            dialogFragment.dismissAllowingStateLoss();
        }
    }

    /**
     * 设置发布按钮的字体颜色
     */
    private void setRightTextColor(int contentLength) {
        if (contentLength > 1000) {
            tvRight.setEnabled(false);
            tvRight.setTextColor(cannotCheck);
        } else {
            tvRight.setEnabled(true);
            tvRight.setTextColor(canCheck);
        }
    }

    private void setTitleDisable() {
        if (topView.getTitleView().getText().toString().startsWith("群公告")) {
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
            topView.setTitle("您输入的群公告过长");
        }
    }

    private void setTitleEnabled() {
        if (topView.getTitleView().getText().toString().startsWith("您输入")) {
            topView.setTitle("群公告");
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IMMessageDispatcher.unbindMessageType(MessageType.UPDATE_GROUP_INFO, this);
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case UPDATE_GROUP_INFO:
                final UpdateGroupInfoRequest groupInfoRequest = (UpdateGroupInfoRequest) request;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (TextUtils.isEmpty(groupInfoRequest.getName())) {
                            dismissDialog();
                            Toast.makeText(mContext, "修改成功", Toast.LENGTH_SHORT).show();
                            finish();
                        }
                    }
                });
                break;
        }

    }

    @Override
    public void receiverMessageFail(final MessageType messageType, final BaseRequest request, final MessageDTO response) {
        switch (messageType) {
            case UPDATE_GROUP_INFO:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                        final UpdateGroupInfoRequest groupInfoRequest = (UpdateGroupInfoRequest) request;
                        if (TextUtils.isEmpty(groupInfoRequest.getName())) {
                            dismissDialog();
                            if (baseResponse.getCode().equals(ResponseCode.NOT_GROUP_MEMBER)) {
                                Toast.makeText(mContext, "非群组成员", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(mContext, "修改群公告失败，请稍后重试", Toast.LENGTH_SHORT).show();

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
                if (TextUtils.isEmpty(groupInfoRequest.getName())) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            dismissDialog();
                            Toast.makeText(mContext, "网络不畅，修改失败，请稍后再试", Toast.LENGTH_SHORT).show();
                        }
                    });
                }
                break;
        }
    }
}
