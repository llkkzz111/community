package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.ui.global.Contact;

import java.util.List;

/**
 * Created by shizhang.cai on 9/4/16.
 */
public class MyContactsAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements View.OnClickListener {

    private List<Contact> contacts;
    private static final int TYPE_NORMAL = 2;

    @Override
    public void onClick(View view) {
        if (mOnItemClickListener != null) {
            mOnItemClickListener.onItemClick(view, (int) view.getTag());
        }
    }

    public void setOnItemClickListener(OnItemClickListener listener) {
        this.mOnItemClickListener = listener;
    }

    public static interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    private OnItemClickListener mOnItemClickListener = null;

    public MyContactsAdapter(List<Contact> contacts, Context context) {
        this.contacts = contacts;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder holder = getViewHolderByViewType(viewType, parent);
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        Contact contact = contacts.get(position);
        if (position == 0 || !contacts.get(position - 1).getIndex().equals(contact.getIndex())) {
            ((ContactsViewHolder) holder).tvIndex.setVisibility(View.VISIBLE);
            ((ContactsViewHolder) holder).tvIndex.setText(contact.getIndex());
        } else {
            ((ContactsViewHolder) holder).tvIndex.setVisibility(View.GONE);
        }
        ((ContactsViewHolder) holder).tvName.setText(contact.getName());
        ((ContactsViewHolder) holder).itemView.setTag(position);

    }

    private RecyclerView.ViewHolder getViewHolderByViewType(int viewType, ViewGroup parent) {
        RecyclerView.ViewHolder holder = null;
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(R.layout.item_local, null);
        holder = new ContactsViewHolder(view);
        view.setOnClickListener(this);
        return holder;
    }


    @Override
    public int getItemCount() {
        return contacts.size();
    }

    @Override
    public int getItemViewType(int position) {
        return TYPE_NORMAL;
    }

    class ContactsViewHolder extends RecyclerView.ViewHolder {
        public TextView tvIndex;
        public TextView tvName;

        public ContactsViewHolder(View itemView) {
            super(itemView);
            tvIndex = (TextView) itemView.findViewById(R.id.tv_index);
            tvName = (TextView) itemView.findViewById(R.id.tv_name);
        }
    }


}