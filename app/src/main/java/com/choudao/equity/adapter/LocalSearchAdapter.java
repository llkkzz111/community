package com.choudao.equity.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.List;

/**
 * Created by dufeng on 16/9/2.<br/>
 * Description: LocalSearchAdapter
 */
public class LocalSearchAdapter extends RecyclerView.Adapter<LocalSearchAdapter.LocalSearchViewHolder> {

    private static final java.lang.String TAG = "===LocalSearchAdapter===";
    /**
     * ===================item点击、长按事件传递 start===================
     */

    private OnRecyclerViewListener onRecyclerViewListener;
    /**
     * ===================item点击、长按事件传递 end===================
     */

    private Context context;
    private List<UserInfo> userInfoList;
    public LocalSearchAdapter(Context context) {
        this.context = context;
    }

    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    public void setData(List<UserInfo> userInfoList) {
        this.userInfoList = userInfoList;
        notifyDataSetChanged();
    }

    public UserInfo getUserInfoByPosition(int position) {
        return userInfoList.get(position);
    }

    @Override
    public LocalSearchViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());

        return new LocalSearchViewHolder(mInflater.inflate(R.layout.item_friend, parent, false));
    }

    @Override
    public void onBindViewHolder(LocalSearchViewHolder holder, int position) {
        holder.position = position;
        UserInfo userInfo = userInfoList.get(position);

        if (Util.isOnMainThread()) {
            Glide.with(context).load(userInfo.getHeadImgUrl())
                    .centerCrop().placeholder(R.drawable.icon_account_no_pic)
                    .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                    .bitmapTransform(new CropSquareTransformation(context))
                    .into(holder.ivHead);
        }
        String name = "(" + userInfo.getName() + ")";
        holder.tvName.setText(userInfo.showName());
        holder.tvExtra.setText(name);
        holder.tvTitle.setText(userInfo.getTitle());
    }

    @Override
    public int getItemCount() {
        return userInfoList == null ? 0 : userInfoList.size();
    }


    /** 联系人的具体内容 */
    public class LocalSearchViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener, View.OnLongClickListener {
        public int position;
        public ImageView ivHead;
        public TextView tvName, tvTitle, tvExtra;


        public LocalSearchViewHolder(View itemView) {
            super(itemView);
            ivHead = (ImageView) itemView.findViewById(R.id.iv_item_friend_head);
            tvName = (TextView) itemView.findViewById(R.id.tv_item_friend_name);
            tvTitle = (TextView) itemView.findViewById(R.id.tv_item_friend_title);
            tvExtra = (TextView) itemView.findViewById(R.id.tv_item_friend_extra);


            itemView.setOnClickListener(this);
            itemView.setOnLongClickListener(this);
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
