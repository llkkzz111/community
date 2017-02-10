package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.entity.TagEntity;
import com.choudao.equity.utils.CropSquareTransformation;

import java.util.HashMap;
import java.util.List;

/**
 * Created by liuzhao on 16/4/15.
 */
public class CheckTagsAddAdapter extends BaseAdapter {
    private Activity mActivity;
    private List<TagEntity> listTag;
    // 用来控制CheckBox的选中状况
    private HashMap<Integer, Boolean> map = new HashMap<>();

    public CheckTagsAddAdapter(Activity mActivity, List<TagEntity> listTag) {
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
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        TagEntity tag = listTag.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.activity_add_question_tag_item_layout, null);
            holder.ivTag = (ImageView) convertView.findViewById(R.id.iv_tag);
            holder.cbCheckTag = (CheckBox) convertView.findViewById(R.id.cb_check_tag);
            holder.tvTagName = (TextView) convertView.findViewById(R.id.tv_tag_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.cbCheckTag.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                map.put(position, isChecked);
            }
        });
        if (map.containsKey(position)) {
            holder.cbCheckTag.setChecked(map.get(position));
        } else {
            holder.cbCheckTag.setChecked(false);
        }
        holder.tvTagName.setText(tag.getName());
        if (Util.isOnMainThread())
            Glide.with(mActivity).load(tag.getIcon()).centerCrop().placeholder(R.drawable.icon_tag_loding).bitmapTransform(new CropSquareTransformation(mActivity))
                    .into(holder.ivTag);
        return convertView;
    }

    public class ViewHolder {
        public CheckBox cbCheckTag;
        public ImageView ivTag;
        public TextView tvTagName;
    }
}
