package com.ocj.oms.mobile.ui.global;

import android.content.Context;
import android.support.v7.widget.AppCompatImageView;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by shizhang.cai on 9/4/16.
 */
public class ContactsAdapter extends RecyclerView.Adapter<ContactsAdapter.ContactsViewHolder> {

    private List<Contact> contacts;
    private List<Contact> selectList = new ArrayList<>();
    private int layoutId;
    private Context mContext;

    public ContactsAdapter(List<Contact> contacts, int layoutId) {
        this.contacts = contacts;
        this.layoutId = layoutId;
    }

    public void setSelectList(List<Contact> selectList) {
        this.selectList = selectList;
    }

    @Override
    public ContactsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(layoutId, null);
        mContext = parent.getContext();
        return new ContactsViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ContactsViewHolder holder, final int position) {
        Contact contact = contacts.get(position);
        if (position == 0 || !contacts.get(position - 1).getIndex().equals(contact.getIndex())) {
            holder.tvIndex.setVisibility(View.VISIBLE);
            holder.tvIndex.setText(contact.getIndex());
        } else {
            holder.tvIndex.setVisibility(View.GONE);
        }
        if (checkContain(selectList, contacts.get(position))) {
            holder.tvName.setTextColor(mContext.getResources().getColor(R.color.text_red_E5290D));
            holder.selectIv.setVisibility(View.VISIBLE);
        } else {
            holder.tvName.setTextColor(mContext.getResources().getColor(R.color.text_grey_666666));
            holder.selectIv.setVisibility(View.GONE);
        }

        holder.tvName.setText(contact.getName());
        holder.selectLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!checkContain(selectList,contacts.get(position))) {
                    selectList.add(contacts.get(position));
                } else {
                    removeItem(selectList,contacts.get(position));
                }
                notifyDataSetChanged();
            }
        });
    }

    private boolean checkContain(List<Contact> list, Contact item) {
        for (Contact con : list) {
            if (con.getCode().equals(item.getCode())) {
                return true;
            }
        }
        return false;
    }

    private void removeItem(List<Contact> list, Contact item) {
        Iterator<Contact> iterator = list.iterator();
        while (iterator.hasNext()) {
            Contact co = iterator.next();
            if (!TextUtils.isEmpty(co.getCode())
                    && co.getCode().equals(item.getCode())) {
                iterator.remove();
            }
        }
    }

    @Override
    public int getItemCount() {
        return contacts.size();
    }

    class ContactsViewHolder extends RecyclerView.ViewHolder {
        public TextView tvIndex;
        public ImageView ivAvatar;
        public TextView tvName;
        public RelativeLayout selectLayout;
        public AppCompatImageView selectIv;

        public ContactsViewHolder(View itemView) {
            super(itemView);
            tvIndex = (TextView) itemView.findViewById(R.id.tv_index);
            ivAvatar = (ImageView) itemView.findViewById(R.id.iv_avatar);
            tvName = (TextView) itemView.findViewById(R.id.tv_name);
            selectLayout = (RelativeLayout) itemView.findViewById(R.id.selectLayout);
            selectIv = (AppCompatImageView) itemView.findViewById(R.id.selectIv);
        }
    }

    public List<Contact> getSelectList() {
        return selectList;
    }
}