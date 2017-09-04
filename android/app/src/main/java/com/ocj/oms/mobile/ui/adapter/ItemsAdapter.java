package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.adapter.holder.VideoHolder;
import com.ocj.oms.mobile.ui.video.listener.ItemClickListener;

/**
 * Created by yy on 2017/5/22.
 */

public class ItemsAdapter extends RecycleBaseAdapter<CmsItemsBean> {

    Context context;
    int mType = 0;
    private ItemClickListener itemClickListener;


    public ItemsAdapter(Context mContext, int type) {
        this.context = mContext;
        this.mType = type;
    }

    public ItemsAdapter(Context mContext, int type, ItemClickListener itemClickListener) {
        this.context = mContext;
        this.mType = type;
        this.itemClickListener = itemClickListener;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new VideoHolder(LayoutInflater.from(context).inflate(viewType, parent, false), mType,itemClickListener);
    }

    @Override
    public int getLayoutRes(int index) {
        return R.layout.item_holder_goods_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, CmsItemsBean data, int index, int type) {
        holder.onBind(index, data);
    }


}
