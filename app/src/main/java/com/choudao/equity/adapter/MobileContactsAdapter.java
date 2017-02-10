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
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.MobileUserInfo;
import com.tonicartos.superslim.GridSLM;
import com.tonicartos.superslim.LinearSLM;

import java.util.List;

/**
 * Created by dufeng on 16/5/20.<br/>
 * Description: FriendsAdapter
 */
public class MobileContactsAdapter extends RecyclerView.Adapter<MobileContactsAdapter.ContactsViewHolder> {


    private List<ContactsItem<MobileUserInfo>> contactsItemList;
    /**
     * ===================item点击、长按事件传递 start===================
     */

    private OnRecyclerViewListener onRecyclerViewListener;
    /**
     * ===================item点击、长按事件传递 end===================
     */

    private Context context;

    public MobileContactsAdapter(Context context) {
        this.context = context;
    }

    public List<ContactsItem<MobileUserInfo>> getData() {
        return contactsItemList;
    }

    public void setData(List<ContactsItem<MobileUserInfo>> contactsItemList) {
        this.contactsItemList = contactsItemList;
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
    public ContactsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        ContactsViewHolder viewHolder = null;
        switch (viewType) {
            case ContactsItem.VIEW_CONTACTS_HEADER:
                viewHolder = new ContactsHeaderViewHolder(mInflater.inflate(R.layout.item_contacts_header, parent, false));
                break;
            case ContactsItem.VIEW_CONTACTS_CONTENT:
                viewHolder = new ContactsContentViewHolder(mInflater.inflate(R.layout.activity_mobcontacts_item_layout, parent, false));
                break;
        }


        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ContactsViewHolder holder, int position) {
        holder.position = position;

        ContactsItem<MobileUserInfo> contactsItem = contactsItemList.get(position);

        GridSLM.LayoutParams lp = GridSLM.LayoutParams.from(holder.itemView.getLayoutParams());
        lp.setFirstPosition(contactsItem.sectionFirstPosition);
        lp.setSlm(LinearSLM.ID);
        holder.itemView.setLayoutParams(lp);

        switch (getItemViewType(position)) {
            case ContactsItem.VIEW_CONTACTS_HEADER:
                ContactsHeaderViewHolder headerViewHolder = (ContactsHeaderViewHolder) holder;
                headerViewHolder.textView.setText(contactsItem.headText);
                break;
            case ContactsItem.VIEW_CONTACTS_CONTENT:
                int contactRelation = DBHelper.getInstance().queryContactRelations(contactsItem.info.getUserId());
                ContactsContentViewHolder contentViewHolder = (ContactsContentViewHolder) holder;
                if (Util.isOnMainThread()) {
                    Glide.with(context).load(contactsItem.info.getHeadImgUrl())
                            .centerCrop().placeholder(R.drawable.icon_account_no_pic)
                            .diskCacheStrategy(DiskCacheStrategy.SOURCE)
                            .bitmapTransform(new CropSquareTransformation(context))
                            .into(contentViewHolder.ivHead);
                }
                if (contactRelation == 1) {
                    contentViewHolder.btnCheck.setText("已添加");
                    contentViewHolder.btnCheck.setTextColor(context.getResources().getColor(R.color.grey));
                    contentViewHolder.btnCheck.setBackgroundColor(context.getResources().getColor(R.color.transparent));
                } else {
                    if (contactsItem.info.getState() != null) {
                        contentViewHolder.btnCheck.setText("等待验证");
                        contentViewHolder.btnCheck.setTextColor(context.getResources().getColor(R.color.grey));
                        contentViewHolder.btnCheck.setBackgroundColor(context.getResources().getColor(R.color.transparent));
                    } else {
                        contentViewHolder.btnCheck.setText("添加");
                        contentViewHolder.btnCheck.setTextColor(context.getResources().getColor(R.color.text_defult_color));
                        contentViewHolder.btnCheck.setBackgroundResource(R.drawable.radius_button_refush_text_bg);
                    }
                }
                contentViewHolder.tvPhoneName.setText(contactsItem.info.getMobName());
                contentViewHolder.tvName.setText("筹道：" + contactsItem.info.getName());
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
     * 联系人的分类栏
     */
    public class ContactsHeaderViewHolder extends ContactsViewHolder {
        public TextView textView;

        public ContactsHeaderViewHolder(View itemView) {
            super(itemView);
            textView = (TextView) itemView.findViewById(R.id.tv_item_contacts_header);
        }
    }

    /**
     * 联系人的具体内容
     */
    public class ContactsContentViewHolder extends ContactsViewHolder implements View.OnClickListener, View.OnLongClickListener {
        public ImageView ivHead;
        public TextView tvPhoneName, tvName;
        public TextView btnCheck;


        public ContactsContentViewHolder(View itemView) {
            super(itemView);
            ivHead = (ImageView) itemView.findViewById(R.id.iv_mob_contacts_head);
            tvPhoneName = (TextView) itemView.findViewById(R.id.tv_mob_contacts_phone_name);
            tvName = (TextView) itemView.findViewById(R.id.tv_mob_contacts_name);
            btnCheck = (TextView) itemView.findViewById(R.id.btn_mob_contacts_check);

            btnCheck.setOnClickListener(this);

            itemView.setOnClickListener(this);
            itemView.setOnLongClickListener(this);
        }

        @Override
        public void onClick(View view) {
            onRecyclerViewListener.onItemClick(position, view);
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
