package com.community.equity.adapter;

import android.app.Activity;
import android.content.Intent;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.PersonalProfileActivity;
import com.community.equity.R;
import com.community.equity.api.BaseCallBack;
import com.community.equity.api.ServiceGenerator;
import com.community.equity.api.service.ApiService;
import com.community.equity.entity.CommentEntity;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.TimeUtils;
import com.community.equity.utils.params.IntentKeys;

import java.util.List;

/**
 * Created by liuz on 2016/4/24.
 */
public class CommentAdapter extends BaseAdapter {
    private List<CommentEntity> listComments;
    private Activity mActivity;

    public CommentAdapter(Activity mActivity, List<CommentEntity> listComments) {
        this.mActivity = mActivity;
        this.listComments = listComments;
    }

    @Override
    public int getCount() {
        return listComments.size();
    }

    @Override
    public Object getItem(int position) {
        return listComments.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final CommentEntity commentEntity = listComments.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.activity_comments_item_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_comment_item_head);
            holder.ivVote = (ImageView) convertView.findViewById(R.id.iv_comment_vote);
            holder.tvContent = (TextView) convertView.findViewById(R.id.tv_comments_info);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_comment_user_title);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_comment_user_name);
            holder.tvLikeCount = (TextView) convertView.findViewById(R.id.tv_comment_like_count);
            holder.tvTime = (TextView) convertView.findViewById(R.id.tv_comment_time);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvContent.setText(Html.fromHtml(commentEntity.getContent()));
        holder.tvName.setText(commentEntity.getUser().getName());
        holder.tvTitle.setText(commentEntity.getUser().getTitle());
        if (commentEntity.getVotesWeight() > 0)
            holder.tvLikeCount.setText(commentEntity.getVotesWeight() + "");
        else
            holder.tvLikeCount.setText("");

        if (commentEntity.getVoted()) {
            holder.ivVote.setImageResource(R.drawable.icon_comment_like);
        } else {
            holder.ivVote.setImageResource(R.drawable.icon_comment_unlike);
        }
        holder.tvTime.setText(TimeUtils.getCommunityTimeInterval(commentEntity.getTimestamp()));
        if (Util.isOnMainThread())
            Glide.with(mActivity).load(commentEntity.getUser().getImg()).placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).centerCrop().bitmapTransform(new CropSquareTransformation(mActivity))
                    .into(holder.ivHead);

        holder.ivVote.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ApiService service = ServiceGenerator.createService(ApiService.class);
                service.setAnsewerVote(commentEntity.getId()).enqueue(new BaseCallBack<CommentEntity>() {
                    @Override
                    protected void onSuccess(CommentEntity body) {
                        listComments.remove(position);
                        listComments.add(position, body);
                        notifyDataSetChanged();
                    }

                    @Override
                    protected void onFailure(int code, String msg) {
                        String sInfoFormat = mActivity.getResources().getString(R.string.error_no_refresh);
                        Toast.makeText(mActivity, String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
                    }

                });
            }
        });
        holder.ivHead.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(mActivity, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, commentEntity.getUser().getId());
                intent.putExtra(IntentKeys.KEY_USER_NAME, commentEntity.getUser().getName());
                mActivity.startActivity(intent);
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
        ImageView ivVote;
        TextView tvTime;
    }
}
