package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.choudao.equity.R;
import com.choudao.equity.entity.TagEntity;

import java.util.List;

/**
 * Created by liuzhao on 16/5/11.
 */
public class ProfileFieldAdapter extends BaseAdapter {
    private Activity mContent;
    private List<TagEntity> listTag;

    public ProfileFieldAdapter(Activity mContent, List<TagEntity> listTag) {
        this.mContent = mContent;
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
            convertView = LayoutInflater.from(mContent).inflate(R.layout.activity_profile_field_item_layout, null);
            holder.tvFieldName = (TextView) convertView.findViewById(R.id.tv_field_name);
            holder.tvFieldCount = (TextView) convertView.findViewById(R.id.tv_field_count);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvFieldName.setText(tag.getName());
        holder.tvFieldCount.setText(tag.getCount() + "");

        return convertView;
    }

    class ViewHolder {
        ImageView ivTag;
        TextView tvFieldName;
        TextView tvFieldCount;
    }
}
