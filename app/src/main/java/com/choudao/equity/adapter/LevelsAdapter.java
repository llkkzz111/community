package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.choudao.equity.R;
import com.choudao.equity.entity.UserEntity;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by liuzhao on 16/12/14.
 */

public class LevelsAdapter extends BaseAdapter {
    List<UserEntity.LevelsBean> levels;
    private Activity mContext;

    public LevelsAdapter(Activity mContext, List<UserEntity.LevelsBean> levels) {
        this.mContext = mContext;
        this.levels = levels;
    }

    @Override
    public int getCount() {
        return levels.size();
    }

    @Override
    public Object getItem(int position) {
        return levels.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ViewHolder holder = null;
        final UserEntity.LevelsBean levelsBean = levels.get(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.activity_profile_levels_item_layout, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.tvLevelsName.setText(levelsBean.getHuman_name());
        return convertView;
    }

    static class ViewHolder {
        @BindView(R.id.iv_levels_img) ImageView ivLevelsImg;
        @BindView(R.id.tv_levels_name) TextView tvLevelsName;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
