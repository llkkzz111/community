package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.entity.UserEntity;
import com.choudao.equity.utils.CropSquareTransformation;

import java.util.List;

/**
 * Created by liuzhao on 16/5/5.
 */
public class PersonalsAdapter extends BaseAdapter {
    private List<UserEntity> listUsers;
    private Activity mActivity;

    public PersonalsAdapter(Activity mActivity, List<UserEntity> listUsers) {
        this.mActivity = mActivity;
        this.listUsers = listUsers;
    }

    @Override
    public int getCount() {
        return listUsers.size();
    }

    @Override
    public Object getItem(int position) {
        return listUsers.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final UserEntity commentEntity = listUsers.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.activity_personal_item_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_personal_item_head);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_personal_item_title);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_personal_item_user_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvName.setText(commentEntity.getName());
        holder.tvTitle.setText(commentEntity.getTitle());
        if (Util.isOnMainThread())
            Glide.with(mActivity).load(commentEntity.getImg()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mActivity))
                    .into(holder.ivHead);
        return convertView;
    }

    class ViewHolder {
        TextView tvTitle;
        TextView tvName;
        ImageView ivHead;
    }
}
