package com.community.equity.adapter;

import android.app.Activity;
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
import com.community.equity.entity.AnswerEntity;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;

import java.util.List;

/**
 * Created by liuzhao on 16/4/18.
 */
public class AnswersAdapter extends BaseAdapter {
    private Activity mContext;
    private List<AnswerEntity> listAnswers;

    public AnswersAdapter(Activity mContext, List<AnswerEntity> listAnswers) {
        this.mContext = mContext;
        this.listAnswers = listAnswers;
    }

    @Override
    public int getCount() {
        return listAnswers.size();
    }

    @Override
    public Object getItem(int position) {
        return listAnswers.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final AnswerEntity answer = listAnswers.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.activity_question_answers_item_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_answer_item_head);
            holder.tvContent = (TextView) convertView.findViewById(R.id.tv_answer_safe_content);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_answer_user_title);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_answer_user_name);
            holder.tvLikeCount = (TextView) convertView.findViewById(R.id.tv_answer_like_count);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (answer.getQuestion_id() > 0) {
            holder.tvLikeCount.setVisibility(View.GONE);
        }
        holder.tvName.setText(answer.getUser().getName());
        holder.tvTitle.setText(answer.getUser().getTitle());
        holder.tvLikeCount.setText(answer.getVotes_weight() + "");
        String content = Utils.formatStr(answer.getSafe_content().trim());
        holder.tvContent.setText(content);
        if (Util.isOnMainThread())
            Glide.with(mContext).load(answer.getUser().getImg()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                    .into(holder.ivHead);
        holder.ivHead.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(mContext, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, answer.getUser().getId());
                intent.putExtra(IntentKeys.KEY_USER_NAME, answer.getUser().getName());
                mContext.startActivity(intent);
            }
        });
        return convertView;
    }

    class ViewHolder {
        TextView tvContent;
        TextView tvTitle;
        TextView tvName;
        TextView tvLikeCount;
        ImageView ivHead;

    }
}
