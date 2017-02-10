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
import com.choudao.equity.entity.ContactsItem;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.imsdk.db.bean.UserInfo;
import com.tonicartos.superslim.GridSLM;
import com.tonicartos.superslim.LinearSLM;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: SelectContactsAdapter
 */

public class SelectContactsAdapter extends RecyclerView.Adapter<SelectContactsAdapter.SelectContactsViewHolder> {

    public static final int INHERENT_MEMBER = 1;
    public static final int NON_MEMBER = 2;
    public static final int SELECTED_MEMBER = 3;

    private List<ContactsItem<UserInfo>> contactsItemList;

    private OnRecyclerViewListener onRecyclerViewListener;

    private Context context;
    private Map<Long, UserInfo> mapUsers = new HashMap<>();

    public SelectContactsAdapter(Context context, List<ContactsItem<UserInfo>> contactsItemList) {
        this.context = context;
        this.contactsItemList = contactsItemList;
    }

    public List<ContactsItem<UserInfo>> getData() {
        return contactsItemList;
    }

    /**
     * 改变选择状态
     *
     * @param position
     */
    public void changeSelectState(int position) {
        ContactsItem<UserInfo> item = contactsItemList.get(position);
        switch (item.selectState) {
            case NON_MEMBER:
                item.selectState = SELECTED_MEMBER;
                mapUsers.put(item.info.getUserId(), null);
                break;
            case SELECTED_MEMBER:
                item.selectState = NON_MEMBER;
                mapUsers.remove(item.info.getUserId());
                break;
        }
        notifyDataSetChanged();
    }

    public void setOnRecyclerViewListener(OnRecyclerViewListener onRecyclerViewListener) {
        this.onRecyclerViewListener = onRecyclerViewListener;
    }

    @Override
    public int getItemViewType(int position) {
        return contactsItemList.get(position).itemType;
    }


    @Override
    public SelectContactsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        SelectContactsViewHolder viewHolder = null;
        switch (viewType) {
            case ContactsItem.VIEW_CONTACTS_HEADER:
                viewHolder = new SelectContactsHeaderViewHolder(mInflater.inflate(R.layout.item_contacts_header, parent, false));
                break;
            case ContactsItem.VIEW_CONTACTS_SELECT:
                viewHolder = new SelectContactsContentViewHolder(mInflater.inflate(R.layout.item_select_friend, parent, false));
                break;
        }


        return viewHolder;
    }

    @Override
    public void onBindViewHolder(SelectContactsViewHolder holder, int position) {
        holder.position = position;
        ContactsItem<UserInfo> contactsItem = contactsItemList.get(position);
        GridSLM.LayoutParams lp = GridSLM.LayoutParams.from(holder.itemView.getLayoutParams());
        lp.setFirstPosition(contactsItem.sectionFirstPosition);
        lp.setSlm(LinearSLM.ID);
        holder.itemView.setLayoutParams(lp);

        switch (getItemViewType(position)) {
            case ContactsItem.VIEW_CONTACTS_HEADER:
                SelectContactsHeaderViewHolder headerViewHolder = (SelectContactsHeaderViewHolder) holder;
                headerViewHolder.textView.setText(contactsItem.headText);
                break;
            case ContactsItem.VIEW_CONTACTS_SELECT:
                SelectContactsContentViewHolder contentViewHolder = (SelectContactsContentViewHolder) holder;
                if (Util.isOnMainThread()) {
                    Glide.with(context).load(contactsItem.info.getHeadImgUrl())
                            .centerCrop().placeholder(R.drawable.icon_account_no_pic)
                            .diskCacheStrategy(DiskCacheStrategy.ALL)
                            .bitmapTransform(new CropSquareTransformation(context))
                            .into(contentViewHolder.ivHead);
                }
                contentViewHolder.tvName.setText(contactsItem.info.showName());
                switch (contactsItem.selectState) {
                    case INHERENT_MEMBER:
                        contentViewHolder.ivSelect.setImageResource(R.drawable.icon_contact_inherent);
                        break;
                    case NON_MEMBER:
                        contentViewHolder.ivSelect.setImageResource(R.drawable.icon_contact_normal);
                        break;
                    case SELECTED_MEMBER:
                        contentViewHolder.ivSelect.setImageResource(R.drawable.icon_contact_select);
                        break;
                }

                if (mapUsers.containsKey(contactsItem.info.getUserId())){
                    contentViewHolder.ivSelect.setImageResource(R.drawable.icon_contact_select);
                    contactsItem.selectState =SELECTED_MEMBER;
                }
                break;


        }

    }

    @Override
    public int getItemCount() {
        return contactsItemList == null ? 0 : contactsItemList.size();
    }


    public class SelectContactsViewHolder extends RecyclerView.ViewHolder {
        public int position;

        public SelectContactsViewHolder(View itemView) {
            super(itemView);
        }
    }


    /**
     * 联系人的分类栏
     */
    public class SelectContactsHeaderViewHolder extends SelectContactsViewHolder {
        public TextView textView;

        public SelectContactsHeaderViewHolder(View itemView) {
            super(itemView);
            textView = (TextView) itemView.findViewById(R.id.tv_item_contacts_header);
        }
    }

    /**
     * 联系人的具体内容
     */
    public class SelectContactsContentViewHolder extends SelectContactsViewHolder implements View.OnClickListener, View.OnLongClickListener {
        public ImageView ivHead, ivSelect;
        public TextView tvName;


        public SelectContactsContentViewHolder(View itemView) {
            super(itemView);
            ivSelect = (ImageView) itemView.findViewById(R.id.iv_item_friend_select);
            ivHead = (ImageView) itemView.findViewById(R.id.iv_item_friend_head);
            tvName = (TextView) itemView.findViewById(R.id.tv_item_friend_name);


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