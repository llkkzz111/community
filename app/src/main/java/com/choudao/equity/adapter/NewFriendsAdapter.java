package com.choudao.equity.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.entity.NewFriendItem;
import com.choudao.equity.entity.UserInfoEntity;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.Utils;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import retrofit2.Call;

/**
 * Created by dufeng on 16/7/15.<br/>
 * Description: NewFriendsAdapter
 */
public class NewFriendsAdapter extends RecyclerView.Adapter<NewFriendsAdapter.NewFriendsViewHolder> {

    private List<NewFriendItem> newFriendItemList;
    /**
     * ===================item点击、长按事件传递 end===================
     */
    private OnRecyclerViewListener onRecyclerViewListener;
    /**
     * ===================item点击、长按事件传递 start===================
     */

    private Context context;

    public NewFriendsAdapter(Context context) {
        this.context = context;
    }

    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    @Override
    public int getItemViewType(int position) {
        return newFriendItemList.get(position).getItemType();
    }

    public void setNewFriendItems(List<NewFriendItem> newFriendItemList) {
        this.newFriendItemList = newFriendItemList;
        notifyDataSetChanged();
    }

    public NewFriendItem getItemData(int position) {
        return newFriendItemList.get(position);
    }


    @Override
    public NewFriendsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());

        NewFriendsViewHolder holder = null;
        switch (viewType) {
            case NewFriendItem.VIEW_HEADER:
                holder = new HeaderViewHolder(mInflater.inflate(R.layout.header_new_friends, parent, false));
                break;
            case NewFriendItem.VIEW_CONTENT:
                holder = new ContentViewHolder(mInflater.inflate(R.layout.item_new_friend, parent, false));
                break;
        }
        return holder;
    }

    @Override
    public void onBindViewHolder(NewFriendsViewHolder holder, int position) {
        holder.position = position;

        switch (getItemViewType(position)) {
//            case NewFriendItem.VIEW_HEADER:
//
//                break;
            case NewFriendItem.VIEW_CONTENT:
                ContentViewHolder contentViewHolder = (ContentViewHolder) holder;
                NewFriendItem friendItem = newFriendItemList.get(position);

                if (friendItem.getName() == null) {
                    showWebUserInfo(friendItem.getSessionInfo().getTargetId(),
                            contentViewHolder);
                } else {
                    contentViewHolder.tvName.setText(friendItem.getName());
                    if (Util.isOnMainThread()) {
                        Glide.with(context)
                                .load(friendItem.getHeadImgUrl())
                                .centerCrop()
                                .placeholder(R.drawable.icon_account_no_pic)
                                .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                                .bitmapTransform(new CropSquareTransformation(context))
                                .into(contentViewHolder.ivHead);
                    }
                }
                contentViewHolder.tvMsg.setText(friendItem.getContent().getMsg());
                showAction(friendItem.getAction(), contentViewHolder.tvAction);
                break;
        }
    }

    private void showWebUserInfo(final long userId, final ContentViewHolder holder) {
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
                        .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                        .bitmapTransform(new CropSquareTransformation(context))
                        .into(holder.ivHead);
                holder.tvName.setText(userInfo.showName());
            }

            @Override
            protected void onFailure(int code, String msg) {
            }
        });
    }

    private void showAction(int action, TextView tvAction) {
        switch (action) {
            case NewFriendItem.ACCEPT:
                tvAction.setText("接受");
                tvAction.setTextColor(context.getResources().getColor(R.color.white));
                tvAction.setBackgroundResource(R.drawable.bg_newfriend_accept);
                break;
            case NewFriendItem.ADD:
                tvAction.setText("添加");
                tvAction.setTextColor(context.getResources().getColor(R.color.color_newfriend_add));
                tvAction.setBackgroundResource(R.drawable.bg_newfriend_add);
                break;
            case NewFriendItem.ADDED:
                tvAction.setText("已添加");
                tvAction.setTextColor(context.getResources().getColor(R.color.tab_uncheck_color));
                tvAction.setBackground(null);
                break;
            case NewFriendItem.REQUEST_SEND:
                tvAction.setText("等待验证");
                tvAction.setTextColor(context.getResources().getColor(R.color.tab_uncheck_color));
                tvAction.setBackground(null);
                break;
        }
    }

    @Override
    public int getItemCount() {
        return newFriendItemList == null ? 0 : newFriendItemList.size();
    }

    public class NewFriendsViewHolder extends RecyclerView.ViewHolder {
        public int position;

        public NewFriendsViewHolder(View itemView) {
            super(itemView);
        }
    }

    public class HeaderViewHolder extends NewFriendsViewHolder implements View.OnClickListener {
        private LinearLayout llSearch, llMobileContacts;

        public HeaderViewHolder(View itemView) {
            super(itemView);

            llSearch = (LinearLayout) itemView.findViewById(R.id.ll_header_new_friend_search);
            llMobileContacts = (LinearLayout) itemView.findViewById(R.id.ll_header_mobile_contacts);
            llSearch.setOnClickListener(this);
            llMobileContacts.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (onRecyclerViewListener != null) {
                onRecyclerViewListener.onItemClick(position, view);
            }
        }
    }

    public class ContentViewHolder extends NewFriendsViewHolder implements View.OnClickListener, View.OnLongClickListener {
        public ImageView ivHead;
        public TextView tvName, tvMsg, tvAction;


        public ContentViewHolder(View itemView) {
            super(itemView);
            ivHead = (ImageView) itemView.findViewById(R.id.iv_item_new_friend_head);
            tvName = (TextView) itemView.findViewById(R.id.tv_item_new_friend_name);
            tvMsg = (TextView) itemView.findViewById(R.id.tv_item_new_friend_msg);
            tvAction = (TextView) itemView.findViewById(R.id.tv_item_new_friend_action);

            itemView.setOnClickListener(this);
            itemView.setOnLongClickListener(this);
            tvAction.setOnClickListener(this);
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
}
