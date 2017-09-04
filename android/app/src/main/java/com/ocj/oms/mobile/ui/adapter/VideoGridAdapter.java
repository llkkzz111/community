package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.adapter.holder.VideoGridHolder;

/**
 * Created by yy on 2017/5/23.
 */

public class VideoGridAdapter extends RecycleBaseAdapter {
    Context context;

    public VideoGridAdapter(Context mContext) {
        this.context = mContext;
    }


    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new VideoGridHolder(LayoutInflater.from(context).inflate(viewType, null));
    }

    @Override
    public int getLayoutRes(int index) {
        return R.layout.item_grid;
    }

    @Override
    public void convert(BaseViewHolder holder, Object data, int index, int type) {
        final CmsItemsBean bean = (CmsItemsBean) data;
        holder.onBind(index, bean);

    }


}
