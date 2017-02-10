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
import com.choudao.equity.entity.ContactsItem;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.imsdk.db.bean.UserInfo;
import com.tonicartos.superslim.GridSLM;
import com.tonicartos.superslim.LinearSLM;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by dufeng on 16/5/20.<br/>
 * Description: FriendsAdapter
 */
public class ContactsAdapter extends RecyclerView.Adapter<ContactsAdapter.ContactsViewHolder> {


    private List<ContactsItem<UserInfo>> contactsItemList;
    private long newFriendCount = 0;
    /**
     * ===================item点击、长按事件传递 start===================
     */

    private OnRecyclerViewListener onRecyclerViewListener;
    /**
     * ===================item点击、长按事件传递 end===================
     */

    private Context context;

    public ContactsAdapter(Context context) {
        this.context = context;
    }

    public void setData(List<ContactsItem<UserInfo>> contactsItemList, long newFriendCount) {
        this.contactsItemList = contactsItemList;
        this.newFriendCount = newFriendCount;
        notifyDataSetChanged();
    }

    public List<ContactsItem<UserInfo>> getData() {
        return contactsItemList;
    }


    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    @Override
    public int getItemViewType(int position) {
        return contactsItemList.get(position).itemType;
    }

    @Override
    public ContactsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        ContactsViewHolder viewHolder = null;
        switch (viewType) {
            case ContactsItem.VIEW_LIST_HEADER:
                viewHolder = new ListHeaderViewHolder(mInflater.inflate(R.layout.header_list_contacts, parent, false));
                break;
            case ContactsItem.VIEW_CONTACTS_HEADER:
                viewHolder = new ContactsHeaderViewHolder(mInflater.inflate(R.layout.item_contacts_header, parent, false));
                break;
            case ContactsItem.VIEW_CONTACTS_CONTENT:
                viewHolder = new ContactsContentViewHolder(mInflater.inflate(R.layout.item_friend, parent, false));
                break;
        }


        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ContactsViewHolder holder, int position) {
        holder.position = position;

        ContactsItem<UserInfo> contactsItem = contactsItemList.get(position);

        GridSLM.LayoutParams lp = GridSLM.LayoutParams.from(holder.itemView.getLayoutParams());
        lp.setFirstPosition(contactsItem.sectionFirstPosition);
        lp.setSlm(LinearSLM.ID);
        holder.itemView.setLayoutParams(lp);

        switch (getItemViewType(position)) {
            case ContactsItem.VIEW_LIST_HEADER:
                ListHeaderViewHolder listHeaderViewHolder = (ListHeaderViewHolder) holder;
                if (newFriendCount > 0) {
                    listHeaderViewHolder.tvNewCount.setVisibility(View.VISIBLE);
                    if (newFriendCount > ConstantUtils.MAX_SHOW_MSG) {
                        listHeaderViewHolder.tvNewCount.setText(context.getString(R.string.more_msg_count));
                    } else {
                        listHeaderViewHolder.tvNewCount.setText(String.valueOf(newFriendCount));
                    }
                } else {
                    listHeaderViewHolder.tvNewCount.setVisibility(View.GONE);
                }
                break;
            case ContactsItem.VIEW_CONTACTS_HEADER:
                ContactsHeaderViewHolder headerViewHolder = (ContactsHeaderViewHolder) holder;
                headerViewHolder.textView.setText(contactsItem.headText);
                break;
            case ContactsItem.VIEW_CONTACTS_CONTENT:
                ContactsContentViewHolder contentViewHolder = (ContactsContentViewHolder) holder;
                if (Util.isOnMainThread()) {
                    Glide.with(context).load(contactsItem.info.getHeadImgUrl())
                            .centerCrop().error(R.drawable.icon_account_no_pic)
                            .diskCacheStrategy(DiskCacheStrategy.ALL).dontAnimate()
                            .bitmapTransform(new CropSquareTransformation(context))
                            .into(contentViewHolder.ivHead);
                }
                contentViewHolder.tvName.setText(contactsItem.info.showName());
                contentViewHolder.tvTitle.setText(contactsItem.info.getTitle());
                break;
        }

    }

    @Override
    public int getItemCount() {
        return contactsItemList == null ? 0 : contactsItemList.size();
    }


    public class ContactsViewHolder extends RecyclerView.ViewHolder {
        public int position;

        public ContactsViewHolder(View itemView) {
            super(itemView);
        }
    }

    /**
     * list的header
     */
    public class ListHeaderViewHolder extends ContactsViewHolder implements View.OnClickListener {


        @BindView(R.id.ll_header_contacts_search)
        public LinearLayout llSearch;
        @BindView(R.id.iv_header_contacts_new_friends)
        public ImageView ivNewFriends;
        @BindView(R.id.tv_header_contacts_new_count)
        public TextView tvNewCount;
        @BindView(R.id.ll_header_contacts_new_friends)
        public LinearLayout llNewFriends;

        public ListHeaderViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            Glide.with(context).load(R.drawable.ic_new_friends).centerCrop().dontAnimate().bitmapTransform(new CropSquareTransformation(context)).into(ivNewFriends);
            llSearch.setOnClickListener(this);
            llNewFriends.setOnClickListener(this);
        }


        @Override
        public void onClick(View view) {
            if (onRecyclerViewListener != null) {
                onRecyclerViewListener.onItemClick(position, view);
            }
        }
    }

    /**
     * 联系人的分类栏
     */
    public class ContactsHeaderViewHolder extends ContactsViewHolder {
        @BindView(R.id.tv_item_contacts_header)
        TextView textView;

        public ContactsHeaderViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }

    /**
     * 联系人的具体内容
     */
    public class ContactsContentViewHolder extends ContactsViewHolder implements View.OnClickListener, View.OnLongClickListener {
        @BindView(R.id.iv_item_friend_head)
        ImageView ivHead;
        @BindView(R.id.tv_item_friend_name)
        TextView tvName;
        @BindView(R.id.tv_item_friend_extra)
        TextView tvExtra;
        @BindView(R.id.tv_item_friend_title)
        TextView tvTitle;


        public ContactsContentViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
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
