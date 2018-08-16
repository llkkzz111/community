package com.community.equity.adapter;

import android.app.Activity;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.util.Util;
import com.community.equity.R;
import com.community.equity.entity.TagEntity;
import com.community.equity.utils.CropSquareTransformation;

import java.util.List;

/**
 * Created by liuzhao on 16/4/8.
 */
public class CheckTagsAdapter extends BaseAdapter {
    private Activity mActivity;
    private List<TagEntity> listTag;

    public CheckTagsAdapter(Activity mActivity, List<TagEntity> listTag) {
        this.mActivity = mActivity;
        this.listTag = listTag;
    }

    @Override
    public int getCount() {
        return listTag.size();
    }

    @Override
    public Object getItem(int position) {
        return listTag.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        TagEntity tag = listTag.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.activity_tag_item_layout, null);
            holder.ivTag = (ImageView) convertView.findViewById(R.id.iv_tag);
            holder.tvTagName = (TextView) convertView.findViewById(R.id.tv_tag_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvTagName.setText(tag.getName());
        if (Util.isOnMainThread())
            if (!TextUtils.isEmpty(tag.getIcon()))
                Glide.with(mActivity).load(tag.getIcon()).centerCrop().placeholder(R.drawable.icon_tag_loding).bitmapTransform(new CropSquareTransformation(mActivity))
                        .into(holder.ivTag);
            else
                Glide.with(mActivity).load(R.drawable.icon_tag_all).placeholder(R.drawable.icon_tag_loding).centerCrop().bitmapTransform(new CropSquareTransformation(mActivity))
                        .into(holder.ivTag);

        return convertView;
    }

    class ViewHolder {
        ImageView ivTag;
        TextView tvTagName;
    }
}
