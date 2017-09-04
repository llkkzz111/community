package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.adapter.holder.VideoHorizonHolder;

/**
 * Created by yy on 2017/5/23.
 */

public class RecommendAdapter extends RecycleBaseAdapter {

    Context mContext;

    public RecommendAdapter(Context context) {
        this.mContext = context;
    }


    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        VideoHorizonHolder holder = new VideoHorizonHolder(LayoutInflater.from(mContext).inflate(viewType, null));
        return holder;
    }

    @Override
    public int getLayoutRes(int index) {
        return R.layout.item_horizon_video;
    }

    @Override
    public void convert(BaseViewHolder holder, final Object data, int index, int type) {
        CmsItemsBean bean = (CmsItemsBean) data;
        holder.onBind(index, bean);
    }


}
