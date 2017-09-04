package com.ocj.oms.mobile.ui.video;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.ItemEventBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import butterknife.BindView;

/**
 * Created by liu on 2017/6/7.
 */

public class GiftAdapter extends RecycleBaseAdapter<ItemEventBean.EventMapItem> {

    OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new GiftViewHolder(LayoutInflater.from(parent.getContext()).inflate(viewType, parent, false));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_gift_select_layout;
    }

    @Override
    public void convert(final BaseViewHolder holder, ItemEventBean.EventMapItem data, final int index, int type) {
        holder.onBind(index, data);
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int position = holder.getLayoutPosition();
                    onItemClickListener.onItemClick(position);
                }
            });
        }
    }


    public class GiftViewHolder extends BaseViewHolder<ItemEventBean.EventMapItem> {

        @BindView(R.id.tv_item_name) TextView tvItemName;
        @BindView(R.id.cb_content) CheckBox cb_content;
        @BindView(R.id.imageView) ImageView imageView;
        @BindView(R.id.tv_clolor) TextView tvColor;
        @BindView(R.id.tv_price) TextView tvPrice;
        @BindView(R.id.tv_num) TextView tvNum;

        ItemEventBean.EventMapItem bean;

        public GiftViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, ItemEventBean.EventMapItem bean) {
            this.bean = bean;
            cb_content.setChecked(bean.checked);
            tvItemName.setText(bean.gift_item_name);
            LoaderFactory.getLoader().loadNet(imageView, bean.gift_img, null);
        }
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
