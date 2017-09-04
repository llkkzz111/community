package com.ocj.oms.mobile.ui.video.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.bumptech.glide.Glide;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.VideoDetailBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/7/13.
 */

public class VideoPictureAdapter extends RecyclerView.Adapter<VideoPictureAdapter.MyViewHolder> {

    private Context context;
    private List<VideoDetailBean> data;
    private onItemClickListener onItemClickListener;

    public void setOnItemClickListener(VideoPictureAdapter.onItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public VideoPictureAdapter(Context context, List<VideoDetailBean> data) {
        this.context = context;
        this.data = data;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_video_picture_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.onBind(position, data.get(position));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    class MyViewHolder extends BaseViewHolder<VideoDetailBean> {
        @BindView(R.id.iv_image1) ImageView ivImage1;
        @BindView(R.id.rl_select1) RelativeLayout rlSelect1;

        public MyViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(final int position, VideoDetailBean bean) {
            Glide.with(context).load(bean.getVideo_picpath()).into(ivImage1);
            if (bean.isSelect()) {
                rlSelect1.setVisibility(View.VISIBLE);
            } else {
                rlSelect1.setVisibility(View.GONE);
            }
            ivImage1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (onItemClickListener != null) {
                        onItemClickListener.onItemClick(position);
                    }
                }
            });
        }
    }

    public interface onItemClickListener {
        void onItemClick(int position);
    }
}
