package com.ocj.oms.mobile.ui.fragment.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by pactera on 2017/4/
 */

public class OrderItemsAdapter extends RecycleBaseAdapter<String> {
    Context mContext;


    public OrderItemsAdapter(Context mContext, List<String> mDatas) {
        this.mContext = mContext;
        this.mData = mDatas;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new ImgHolder(LayoutInflater.from(mContext).inflate(viewType, null));
    }


    @Override
    public int getItemCount() {
        return mData.size();
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_fragment_order_items_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, String data, int index, int type) {
        holder.onBind(index, data);
    }


    class ImgHolder extends BaseViewHolder<String> {
        @BindView(R.id.iv_items)
        ImageView ivItems;


        public ImgHolder(View view) {
            super(view);
        }

        @Override
        public void onBind(int position, String bean) {
            LoaderFactory.getLoader().loadNet(ivItems, bean);

        }
    }

}
