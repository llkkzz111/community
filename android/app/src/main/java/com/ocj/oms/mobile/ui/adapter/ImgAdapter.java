package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ItemsBean;

import java.util.List;

/**
 * Created by pactera on 2017/4/
 */

public class ImgAdapter extends RecyclerView.Adapter {
    Context mContext;
    List<ItemsBean> mDatas;
    OnChildClickListner mListner;

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        ImgHolder holder = new ImgHolder(LayoutInflater.from(
                mContext).inflate(R.layout.item_gridview, parent,
                false));
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        ItemsBean bean = mDatas.get(position);
        ImgHolder mholder = (ImgHolder) holder;
        mholder.title.setText(bean.getItem_name());
        LoaderFactory.getLoader().loadNet(mholder.img, bean.getItem_image());
        if (bean.isCheck()) {
            mholder.title.setTextColor(mContext.getResources().getColor(R.color.text_blue));
            mholder.above.setBackgroundResource(R.drawable.bg_select);
        } else {
            mholder.title.setTextColor(mContext.getResources().getColor(R.color.text_black_444444));
            mholder.above.setBackgroundResource(R.drawable.bg_noselect);
        }


        mholder.img.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != mListner) {
                    mListner.onItemClick(position);
                }
            }
        });


    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    public void setItemClickListner(OnChildClickListner listner) {
        this.mListner = listner;
    }

    public ImgAdapter(Context context, List<ItemsBean> data) {
        this.mContext = context;
        this.mDatas = data;
    }


    class ImgHolder extends RecyclerView.ViewHolder {
        ImageView img;
        ImageView above;
        TextView title;


        public ImgHolder(View view) {
            super(view);
            title = (TextView) view.findViewById(R.id.tv_title);
            img = (ImageView) view.findViewById(R.id.img_below);
            above = (ImageView) view.findViewById(R.id.img_above);
        }
    }


    public interface OnChildClickListner {
        void onItemClick(int position);
    }


}
