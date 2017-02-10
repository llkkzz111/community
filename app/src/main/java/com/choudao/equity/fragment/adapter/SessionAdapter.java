package com.choudao.equity.fragment.adapter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.choudao.equity.R;
import com.choudao.equity.adapter.OnRecyclerViewListener;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.entity.SessionItem;
import com.choudao.equity.entity.UserInfoEntity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.NineImageUtils;
import com.choudao.equity.utils.TextConverters;
import com.choudao.equity.utils.TimeUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import retrofit2.Call;

/**
 * Created by dufeng on 16/5/6.<br/>
 * Description: SessionAdapter
 */
public class SessionAdapter extends RecyclerView.Adapter<SessionAdapter.SessionViewHolder> {


    private Activity context;
    private OnRecyclerViewListener onRecyclerViewListener;
    private List<SessionItem> sessionItems = new ArrayList<>();
    private boolean isNoNetwork = false;


    public SessionAdapter(Activity context) {
        this.context = context;
    }

    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    public void setNoNetwork(boolean isNoNetwork) {
        this.isNoNetwork = isNoNetwork;
        if (sessionItems.size() == 0) {
            return;
        }
        if (isNoNetwork) {
            if (sessionItems.get(0).getItemType() != SessionItem.HEAD_NO_NETWORK) {
                sessionItems.add(0, new SessionItem(SessionItem.HEAD_NO_NETWORK));
                notifyDataSetChanged();
            }
        } else {
            if (sessionItems.get(0).getItemType() == SessionItem.HEAD_NO_NETWORK) {
                sessionItems.remove(0);
                notifyDataSetChanged();
            }
        }
    }

    public List<SessionItem> getSessionItems() {
        return sessionItems;
    }

    public void setSessionItems(List<SessionItem> sessionItems) {
        this.sessionItems.clear();
        this.sessionItems.addAll(sessionItems);
        if(isNoNetwork){
            this.sessionItems.add(0, new SessionItem(SessionItem.HEAD_NO_NETWORK));
        }
        notifyDataSetChanged();
    }

    @Override
    public int getItemViewType(int position) {
        return sessionItems.get(position).getItemType();
    }

    @Override
    public SessionViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        SessionViewHolder holder = null;
        switch (viewType) {
            case SessionItem.HEAD_NO_NETWORK:
                holder = new HeaderViewHolder(mInflater.inflate(R.layout.item_session_header, parent, false));
                break;
            case SessionItem.ITEM_CONTENT:
                holder = new ContentViewHolder(mInflater.inflate(R.layout.item_session, parent, false));
                break;
        }
        return holder;
    }

    @Override
    public void onBindViewHolder(SessionViewHolder holder, int position) {

        holder.position = position;
        switch (getItemViewType(position)) {
            case SessionItem.HEAD_NO_NETWORK:
                break;
            case SessionItem.ITEM_CONTENT:
                bindContentData((ContentViewHolder) holder, position);
                break;
        }
    }


    /**
     * session内容
     *
     * @param holder
     * @param position
     */
    private void bindContentData(ContentViewHolder holder, int position) {
        SessionItem sessionItem = sessionItems.get(position);

        if (sessionItem.getName() == null) {
            showWebUserInfo(sessionItem.getSessionInfo().getTargetId(),
                    holder);
        } else {
            holder.tvName.setText(sessionItem.getName());
            if (sessionItem.getSessionInfo().getSessionType() == 2) {
                new NineImageUtils(context, sessionItem.getSessionInfo().getTargetId(), holder.ivHead, sessionItem.getHeadImgUrl()).saveGroupHead();
            } else {
                Glide.with(context)
                        .load(sessionItem.getHeadImgUrl())
                        .centerCrop()
                        .placeholder(R.drawable.icon_account_no_pic)
                        .diskCacheStrategy(DiskCacheStrategy.ALL).dontAnimate()
                        .bitmapTransform(new CropSquareTransformation(context))
                        .into(holder.ivHead);
            }
            //是否置顶
            if (sessionItem.isTop()) {
                holder.llContent.setBackgroundResource(R.drawable.list_top_selector_bg);
            } else {
                holder.llContent.setBackgroundResource(R.drawable.list_view_list_selector_bg);
            }

            int count = sessionItem.getSessionInfo().getCount();
            //是否免打扰
            if (sessionItem.isMute()) {
                holder.ivMute.setVisibility(View.VISIBLE);
                holder.tvMsgCount.setVisibility(View.GONE);
                if (count > 0) {
                    holder.vMute.setVisibility(View.VISIBLE);
                } else {
                    holder.vMute.setVisibility(View.GONE);
                }
            } else {
                holder.ivMute.setVisibility(View.INVISIBLE);
                holder.vMute.setVisibility(View.GONE);
                if (count > 0) {
                    holder.tvMsgCount.setVisibility(View.VISIBLE);
                    if (count > ConstantUtils.MAX_SHOW_MSG) {
                        holder.tvMsgCount.setText(context.getString(R.string.more_msg_count));
                    } else {
                        holder.tvMsgCount.setText(String.valueOf(count));
                    }
                } else {
                    holder.tvMsgCount.setVisibility(View.GONE);
                }
            }
        }
        holder.tvLastTime.setText(TimeUtils.getSimpleTimeInterval(sessionItem.getSessionInfo().getLastTime()));
        String strLast = sessionItem.getSessionInfo().getLastMessage();
        if (strLast == null) {
            holder.tvLastMsg.setText("");
        } else {
            holder.tvLastMsg.setText(TextConverters.convertSysText(strLast.trim()));
        }
    }

    private void showWebUserInfo(final long userId, final ContentViewHolder holder) {

        holder.llContent.setBackgroundResource(R.color.white);
        holder.ivMute.setVisibility(View.INVISIBLE);
        holder.vMute.setVisibility(View.GONE);
        holder.tvName.setText("USER" + userId);
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

                Glide.with(context)
                        .load(userInfo.getHeadImgUrl())
                        .centerCrop().placeholder(R.drawable.icon_account_no_pic)
                        .diskCacheStrategy(DiskCacheStrategy.ALL).dontAnimate()
                        .bitmapTransform(new CropSquareTransformation(context))
                        .into(holder.ivHead);
                holder.tvName.setText(userInfo.showName());
            }

            @Override
            protected void onFailure(int code, String msg) {
            }
        });
    }

    @Override
    public int getItemCount() {
        return sessionItems == null ? 0 : sessionItems.size();
    }

    /**
     * ===================item点击、长按事件传递 start===================
     */


    public class SessionViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener, View.OnLongClickListener {

        public int position;

        public SessionViewHolder(View itemView) {
            super(itemView);
        }


        @Override
        public void onClick(View view) {
            if (onRecyclerViewListener != null) {
                onRecyclerViewListener.onItemClick(position, view);
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


    public class HeaderViewHolder extends SessionViewHolder {

        public HeaderViewHolder(View view) {
            super(view);
            view.setOnClickListener(this);
            view.setOnLongClickListener(this);
        }
    }

    public class ContentViewHolder extends SessionViewHolder {

        public LinearLayout llContent;
        public ImageView ivHead, ivMute;
        public TextView tvMsgCount, tvName, tvLastTime, tvLastMsg;
        public View vMute;

        public ContentViewHolder(View view) {
            super(view);
            llContent = (LinearLayout) view.findViewById(R.id.ll_item_session_content);
            ivHead = (ImageView) view.findViewById(R.id.iv_item_session_head);
            tvMsgCount = (TextView) view.findViewById(R.id.tv_item_session_msgcount);
            tvName = (TextView) view.findViewById(R.id.tv_item_session_name);
            tvLastTime = (TextView) view.findViewById(R.id.tv_item_session_lasttime);
            tvLastMsg = (TextView) view.findViewById(R.id.tv_item_session_lastmsg);
            ivMute = (ImageView) view.findViewById(R.id.iv_item_session_mute);
            vMute = view.findViewById(R.id.v_item_session_msgmute);

            view.setOnClickListener(this);
            view.setOnLongClickListener(this);
        }
    }
}