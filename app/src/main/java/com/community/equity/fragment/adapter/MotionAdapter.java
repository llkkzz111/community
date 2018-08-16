package com.community.equity.fragment.adapter;

import android.content.Context;
import android.content.Intent;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.QuestionDetailsActivity;
import com.community.equity.R;
import com.community.equity.SingleAnswerActivity;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.MotionEntity;
import com.community.equity.entity.MotionJumpEntity;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.TimeUtils;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;

import java.util.List;

/**
 * Created by liuzhao on 16/4/29.
 */
public class MotionAdapter extends BaseAdapter {
    private List<MotionEntity> listMotion;
    private Context mContext;
    private BaseFragment fragment;

    public MotionAdapter(BaseFragment fragment, List<MotionEntity> listMotion) {
        this.mContext = fragment.getActivity();
        this.fragment = fragment;
        this.listMotion = listMotion;
    }

    @Override
    public int getCount() {
        return listMotion.size();
    }

    @Override
    public Object getItem(int position) {
        return listMotion.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final MotionEntity motion = listMotion.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.fragment_item_motion_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_motion_item_head);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_motion_item_user_name);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_motion_item_user_title);
            holder.tvTime = (TextView) convertView.findViewById(R.id.tv_motion_item_time);
            holder.tvContent = (TextView) convertView.findViewById(R.id.tv_motion_item_content);
            holder.tvVoteCount = (TextView) convertView.findViewById(R.id.tv_vote_count);
            holder.tvAnswerContent = (TextView) convertView.findViewById(R.id.tv_another_content);
            holder.llAnother = (LinearLayout) convertView.findViewById(R.id.ll_another);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvName.setText(motion.getUser().getName());
        holder.tvTitle.setText(motion.getUser().getTitle());
        holder.tvTime.setText(TimeUtils.getCommunityTimeInterval(motion.getTimestamp()));


        String start = Utils.formatStr(motion.getContent_prefix().trim()) + " ";
        String end = Utils.formatStr(motion.getContent().trim());

        holder.tvContent.setText(start + end);
        holder.tvAnswerContent.setText(end);

        SpannableStringBuilder builder = new SpannableStringBuilder(holder.tvContent.getText().toString());

        ForegroundColorSpan startSpan = new ForegroundColorSpan(mContext.getResources().getColor(R.color.text_defult_color));
        ForegroundColorSpan endSpan = new ForegroundColorSpan(mContext.getResources().getColor(R.color.text_default_color));

        builder.setSpan(startSpan, 0, start.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.setSpan(endSpan, start.length(), start.length() + end.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        holder.tvContent.setText(builder);
        if (Util.isOnMainThread() && fragment.getActivity() != null)
            Glide.with(fragment).load(motion.getUser().getImg()).placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext)).into(holder.ivHead);

        holder.llAnother.setVisibility(View.GONE);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MotionEntity motion = listMotion.get(position);
                MotionJumpEntity jumpEntity = motion.getEntry();
                Intent intent = new Intent();
                if (motion.getType().equals("QuestionCreated")) {
                    intent.setClass(mContext, QuestionDetailsActivity.class);
                    intent.putExtra(IntentKeys.KEY_QUESTION_ID, jumpEntity.getId());
                    mContext.startActivity(intent);
                } else if (motion.getType().equals("AnswerCreated")) {
                    intent.setClass(mContext, SingleAnswerActivity.class);
                    intent.putExtra(IntentKeys.KEY_QUESTION_ID, jumpEntity.getQuestion_id());
                    intent.putExtra(IntentKeys.KEY_ANSWER_ID, jumpEntity.getId());
                    intent.putExtra(IntentKeys.KEY_QUESTION_TITLE, motion.getContent());
                    mContext.startActivity(intent);
                } else if (motion.getType().equals("AnswerVotedUp")) {
                    intent.setClass(mContext, SingleAnswerActivity.class);
                    intent.putExtra(IntentKeys.KEY_QUESTION_ID, jumpEntity.getQuestion_id());
                    intent.putExtra(IntentKeys.KEY_ANSWER_ID, jumpEntity.getId());
                    intent.putExtra(IntentKeys.KEY_QUESTION_TITLE, motion.getContent());
                    mContext.startActivity(intent);
                } else {
                    Toast.makeText(mContext, motion.getType(), Toast.LENGTH_SHORT).show();
                }
            }
        });
        return convertView;
    }

    class ViewHolder {
        ImageView ivHead;
        TextView tvTitle;
        TextView tvTime;
        TextView tvName;
        TextView tvContent;
        TextView tvAnswerContent;
        TextView tvVoteCount;
        LinearLayout llAnother;
    }
}
