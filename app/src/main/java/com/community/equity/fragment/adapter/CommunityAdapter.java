package com.community.equity.fragment.adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.PersonalProfileActivity;
import com.community.equity.R;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.QuestionEntity;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.TimeUtils;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;

import java.util.List;

/**
 * Created by liuzhao on 16/4/8.
 */
public class CommunityAdapter extends BaseAdapter {
    private Context mContext;
    private List<QuestionEntity> listQuestion;
    private BaseFragment fragment;

    public CommunityAdapter(BaseFragment fragment, List<QuestionEntity> listQuestion) {
        this.mContext = fragment.getActivity();
        this.fragment = fragment;
        this.listQuestion = listQuestion;
    }

    @Override
    public int getCount() {
        return listQuestion.size();
    }

    @Override
    public Object getItem(int position) {
        return listQuestion.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final QuestionEntity question = listQuestion.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.fragment_item_community_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_community_item_head);
            holder.tvCount = (TextView) convertView.findViewById(R.id.tv_community_item_count);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_community_item_user_name);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_community_item_title);
            holder.tvTime = (TextView) convertView.findViewById(R.id.tv_community_item_time);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        String title = Utils.formatStr(question.getTitle().trim());

        holder.tvTitle.setText(title);
        holder.tvCount.setText(String.format(mContext.getString(R.string.text_answer_count), question.getAnswersCount()));
        holder.tvName.setText(question.getUser().getName());
        holder.tvTime.setText(TimeUtils.getCommunityTimeInterval(question.getTimestamp()));
        if (Util.isOnMainThread() && fragment.getActivity() != null)
            Glide.with(fragment).load(question.getUser().getImg()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                    .into(holder.ivHead);
        holder.ivHead.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(mContext, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, question.getUser().getId());
                intent.putExtra(IntentKeys.KEY_USER_NAME, question.getUser().getName());
                mContext.startActivity(intent);
            }
        });
        return convertView;
    }

    class ViewHolder {
        ImageView ivHead;
        TextView tvTitle;
        TextView tvTime;
        TextView tvName;
        TextView tvCount;
    }
}
