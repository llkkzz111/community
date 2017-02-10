package com.choudao.equity.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.PersonalProfileActivity;
import com.choudao.equity.R;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.entity.UserInfoEntity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.TextConverters;
import com.choudao.equity.utils.TimeUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.LinkMoreMovementMethod;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.constants.ContentType;

import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import retrofit2.Call;

/**
 * Created by dufeng on 16/5/11.<br/>
 * Description: MessageAdapter
 */
public class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> {
    private static final String TAG = "===MessageAdapter===";


    private static final int UNKNOWN_MSG = -2;
    private static final int TEXT_MSG_LOCAL = -1;
    private static final int TEXT_MSG_LEFT = 0;
    private static final int TEXT_MSG_RIGHT = 1;
    /**
     * Item事件接口实例
     */
    private OnRecyclerViewListener onRecyclerViewListener;
    private Context context;
    private boolean isShowMemberName;
    private List<Message> messageList;

    public MessageAdapter(Context context) {
        this.context = context;
    }

    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    public void setData(List<Message> dataList, boolean isShowMemberName) {
        this.messageList = dataList;
        this.isShowMemberName = isShowMemberName;
        notifyDataSetChanged();
    }

    //    public List<PrivateMessage> getData() {
//        return messageList;
//    }
    public int getDataSize() {
        return messageList.size();
    }

    public Message getMsgByPosition(int i) {
        return messageList.get(i);
    }

    public void replaceMsg(int index, Message data) {
        messageList.set(index, data);
        notifyItemChanged(index);
    }

    public void addMsg(List<Message> addData) {
        int point = messageList.size();
        messageList.addAll(addData);
        notifyItemRangeInserted(point, addData.size());
    }

    public void addMsg(Message addData) {
        int point = messageList.size();
        messageList.add(addData);
        notifyItemRangeInserted(point, 1);
    }

    public void deleteMsg(int position) {
        messageList.remove(position);
        notifyDataSetChanged();
    }

    public void addDataToHead(List<Message> addDatas) {
        int point = messageList.size();
        messageList.addAll(0, addDatas);
        notifyItemRangeInserted(0, addDatas.size());
        notifyItemRangeChanged(addDatas.size(), point);
    }

    @Override
    public int getItemViewType(int position) {
        Message message = messageList.get(position);
        //老版本有用userType为-1的做本地标示
        if (message.getSendUserType() != null && message.getContentType() == ContentType.LOCAL.code) {
            return TEXT_MSG_LOCAL;
        }

        switch (ContentType.of(message.getShowType())) {
            case LOCAL:
                return TEXT_MSG_LOCAL;
            case TEXT:
                /**如果是自己发的,显示在右边*/
                if (message.getSendUserId() == ConstantUtils.USER_ID) {
                    return TEXT_MSG_RIGHT;
                } else {
                    return TEXT_MSG_LEFT;
                }
        }
        return UNKNOWN_MSG;
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        MessageViewHolder holder = null;
        switch (viewType) {
            case TEXT_MSG_RIGHT:
                holder = new TextRightMessageViewHolder(mInflater.inflate(R.layout.item_text_msg_right, parent, false));
                break;
            case TEXT_MSG_LEFT:
                holder = new TextLeftMessageViewHolder(mInflater.inflate(R.layout.item_text_msg_left, parent, false));
                break;
            case TEXT_MSG_LOCAL:
                holder = new LocalMessageViewHolder(mInflater.inflate(R.layout.item_text_msg_local, parent, false));
                break;
            case UNKNOWN_MSG:
                holder = new LocalMessageViewHolder(mInflater.inflate(R.layout.item_text_msg_local, parent, false));
                break;
        }
        return holder;
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        holder.position = position;
        Message message = messageList.get(position);

        String content = message.getContent();

        //如果是未知类型
        if (getItemViewType(position) == UNKNOWN_MSG) {
            LocalMessageViewHolder localViewHolder = (LocalMessageViewHolder) holder;
            localViewHolder.localText.setText(context.getString(R.string.text_local_unknown_msg));
            return;
        }

        //如果是本地提示消息的话
        if (getItemViewType(position) == TEXT_MSG_LOCAL) {
            LocalMessageViewHolder localViewHolder = (LocalMessageViewHolder) holder;
            convertTextMsg(localViewHolder.localText, content);
            return;
        }

        ChatViewHolder chatViewHolder = (ChatViewHolder) holder;
        showUserInfo(message.getSendUserId(), chatViewHolder.tvName, chatViewHolder.ivHead);

        if (position == 0) {
            chatViewHolder.tvTime.setVisibility(View.VISIBLE);
            chatViewHolder.tvTime.setText(TimeUtils.getTimeInterval(message.getTimestamp()));
        } else {
            if (message.getTimestamp() - messageList.get(position - 1).getTimestamp() < 1000 * 60) {
                if (messageList.get(position).getMessageIndex() == messageList.get(position - 1).getMessageIndex())
                    chatViewHolder.tvTime.setVisibility(View.GONE);
                else {
                    chatViewHolder.tvTime.setVisibility(View.VISIBLE);
                    chatViewHolder.tvTime.setText(TimeUtils.getTimeInterval(message.getTimestamp()));
                }
            } else {
                chatViewHolder.tvTime.setVisibility(View.VISIBLE);
                chatViewHolder.tvTime.setText(TimeUtils.getTimeInterval(message.getTimestamp()));
            }
        }

        switch (getItemViewType(position)) {
            case TEXT_MSG_RIGHT:
                TextRightMessageViewHolder rightHolder = (TextRightMessageViewHolder) holder;
                convertTextMsg(rightHolder.tvContent, content);
                rightHolder.pbSending.setVisibility(View.INVISIBLE);
                rightHolder.ivFail.setVisibility(View.INVISIBLE);
                switch (message.getSendStatus()) {
                    case Message.SENDING:
                        if (System.currentTimeMillis() - message.getTimestamp() < 15 * 1000) {
                            rightHolder.pbSending.setVisibility(View.VISIBLE);
                        } else {
                            rightHolder.ivFail.setVisibility(View.VISIBLE);
                        }
                        break;
                    case Message.SEND_FAIL:
                        rightHolder.ivFail.setVisibility(View.VISIBLE);
                        break;
                }
                break;
            case TEXT_MSG_LEFT:
                TextLeftMessageViewHolder leftHolder = (TextLeftMessageViewHolder) holder;
                convertTextMsg(leftHolder.tvContent, content);
                break;
        }
    }

    private void convertTextMsg(TextView textView, String content) {
        if (TextUtils.isEmpty(content)) {
            textView.setText("");
        } else {
            if (content.contains("://")) {
                textView.setText(TextConverters.convertSpannableString(context, content.trim()));
                textView.setMovementMethod(LinkMoreMovementMethod.getInstance());
            } else {
                textView.setText(content.trim());
            }
        }
    }

    /**
     * 展示用户头像和名字，如果本地有就从本地获取，没有就从网上拉取
     *
     * @param userId
     * @param tvName
     * @param ivHead
     */
    private void showUserInfo(final long userId, final TextView tvName, final ImageView ivHead) {
        UserInfo userInfo = DBHelper.getInstance().queryUniqueUserInfo(userId);
        if (userInfo == null) {
            tvName.setText("USER" + userId);
            /** 如果本地数据库没有用户信息的话就去网络拉取 */
            ApiService service = ServiceGenerator.createService(ApiService.class);
            Map<String, Object> params = new IdentityHashMap<>();
            params.put("user_id", userId);
            Call<UserInfoEntity> repos = service.getUserInfo(params);
            repos.enqueue(new BaseCallBack<UserInfoEntity>() {
                @Override
                protected void onSuccess(UserInfoEntity userInfoEntity) {
                    final UserInfo userInfo = Utils.userInfoEntityToUserInfo(userInfoEntity);
                    DBHelper.getInstance().saveUserInfo(userInfo);

                    Glide.with(context).load(userInfo.getHeadImgUrl()).centerCrop().diskCacheStrategy(DiskCacheStrategy.ALL).dontAnimate().bitmapTransform(new CropSquareTransformation(context))
                            .into(ivHead);
                    tvName.setText(userInfo.getName());
                }

                @Override
                protected void onFailure(int code, String msg) {
                }
            });
        } else {
            if (Util.isOnMainThread())
                Glide.with(context).load(userInfo.getHeadImgUrl()).centerCrop().diskCacheStrategy(DiskCacheStrategy.ALL).dontAnimate().bitmapTransform(new CropSquareTransformation(context))
                        .into(ivHead);
            tvName.setText(userInfo.showName());
        }
    }

    @Override
    public int getItemCount() {
        return messageList == null ? 0 : messageList.size();
    }

    /**
     * ===================item点击、长按事件传递 start===================
     */


    /**
     * =============== 基类ViewHolder ===============
     */
    public class MessageViewHolder extends RecyclerView.ViewHolder {
        public int position;

        public MessageViewHolder(View itemView) {
            super(itemView);
        }
    }

    public class ChatViewHolder extends MessageViewHolder implements View.OnClickListener, View.OnLongClickListener {
        public LinearLayout llContent;
        public ImageView ivHead;
        public TextView tvName, tvTime;

        public ChatViewHolder(View itemView) {
            super(itemView);
            llContent = (LinearLayout) itemView.findViewById(R.id.ll_message_content);
            ivHead = (ImageView) itemView.findViewById(R.id.iv_message_head);
            tvName = (TextView) itemView.findViewById(R.id.tv_message_name);
            tvTime = (TextView) itemView.findViewById(R.id.tv_message_time);

            llContent.setOnLongClickListener(this);
            ivHead.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (onRecyclerViewListener != null) {
                onRecyclerViewListener.onItemClick(position, view);
            }
            switch (view.getId()) {
                case R.id.iv_message_head:
                    Intent intent = new Intent(context, PersonalProfileActivity.class);
                    Message message = messageList.get(position);
                    intent.putExtra(IntentKeys.KEY_USER_ID, message.getSendUserId());
                    context.startActivity(intent);
                    break;
            }
        }

        @Override
        public boolean onLongClick(View view) {
            if (onRecyclerViewListener != null) {
                return onRecyclerViewListener.onItemLongClick(position, view);
            }
            return false;
        }
    }

    /**
     * ========================== 文本信息 start ==========================
     */

    public class TextLeftMessageViewHolder extends ChatViewHolder {
        public TextView tvContent;

        public TextLeftMessageViewHolder(View itemView) {
            super(itemView);
            tvContent = (TextView) itemView.findViewById(R.id.tv_message_content);

            if (isShowMemberName) {
                tvName.setVisibility(View.VISIBLE);
            }
            tvContent.setOnClickListener(this);
            tvContent.setOnLongClickListener(this);
        }

    }

    public class TextRightMessageViewHolder extends ChatViewHolder {
        public TextView tvContent;
        public ImageView ivFail;
        public ProgressBar pbSending;

        public TextRightMessageViewHolder(View itemView) {
            super(itemView);
            tvContent = (TextView) itemView.findViewById(R.id.tv_message_content);
            ivFail = (ImageView) itemView.findViewById(R.id.iv_message_fail);
            pbSending = (ProgressBar) itemView.findViewById(R.id.pb_message_sending);

            tvContent.setOnClickListener(this);
            tvContent.setOnLongClickListener(this);
            ivFail.setOnClickListener(this);
        }
    }
    /**========================== 文本信息 end ==========================*/


    /**
     * ========================== 本地提示 start ==========================
     */

    public class LocalMessageViewHolder extends MessageViewHolder {
        public TextView localText;

        public LocalMessageViewHolder(View itemView) {
            super(itemView);
            localText = (TextView) itemView.findViewById(R.id.tv_item_msg_local);
        }

    }
    /** ========================== 本地提示 end ========================== */


}
