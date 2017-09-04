package com.ocj.oms.mobile.ui.global;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatImageView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.rn.NumUtils;

import java.util.List;

/**
 * 线性adapter
 * Created by shizhang.cai on 2017/6/7.
 */

public class GlobalLinearAdapter extends BaseQuickAdapter<CmsItemsBean, BaseViewHolder> {

    Context ctx;

    public GlobalLinearAdapter(Context ctx, @LayoutRes int layoutResId, @Nullable List<CmsItemsBean> data) {
        super(layoutResId, data);
        this.ctx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder holder, CmsItemsBean data) {
        //折扣
        if (isNotNull(data.getDiscount()) && Float.parseFloat(data.getDiscount()) != 0) {
            holder.setText(R.id.rabateTv, data.getDiscount() + "折");
            holder.setVisible(R.id.rabateTv, true);
        } else {
            holder.setVisible(R.id.rabateTv, false);
        }
        //价格
        if (isNotNull(data.getSalePrice())) {
            String value = data.getSalePrice();
            if (value.contains(".")) {
                value = value.substring(0, value.indexOf("."));
            }
            holder.setText(R.id.priceTv, value);
            holder.setVisible(R.id.priceTv, true);
        } else {
            holder.getView(R.id.priceTv).setVisibility(View.INVISIBLE);
        }

        //赠品
        if (data.getGifts() != null && data.getGifts().size() > 0) {
            holder.setVisible(R.id.tvZengpin, true);
            holder.setText(R.id.tvSubtitle, data.getGifts().toString());
        } else {
            holder.setVisible(R.id.tvZengpin, false);
        }

        //库存情况
        if (isNotNull(data.getInStock()) && !NumUtils.checkStringIsNum(data.getInStock())) {
            holder.setVisible(R.id.tv_storage, true);
            holder.setText(R.id.tv_storage, data.getInStock());
        } else {
            holder.setVisible(R.id.tv_storage, false);
        }

        AppCompatImageView relationIv = holder.getView(R.id.relationIv);

        LoaderFactory.getLoader().loadNet(relationIv,data.getFirstImgUrl(),R.drawable.icon_dougou_def);

        ImageView ivNation = holder.getView(R.id.iv_nation);
        if (isNotNull(data.getCountryImgUrl())) {
            holder.setVisible(R.id.iv_nation, true);
            LoaderFactory.getLoader().loadNet(ivNation, data.getCountryImgUrl());
            if (isNotNull(data.getDiscount()) && Float.parseFloat(data.getDiscount()) != 0) {
                holder.setText(R.id.titleTv, mContext.getString(R.string.space_text, data.getTitle()));
            } else {
                holder.setText(R.id.titleTv, mContext.getString(R.string.space_text_7, data.getTitle()));
            }
        } else {
            holder.setVisible(R.id.iv_nation, false);
            if (isNotNull(data.getDiscount()) && Float.parseFloat(data.getDiscount()) != 0) {
                holder.setText(R.id.titleTv, mContext.getString(R.string.space_text_12, data.getTitle()));
            } else {
                holder.setText(R.id.titleTv, data.getTitle());
            }
        }
    }

    private boolean isNotNull(String values) {
        return values != null && !TextUtils.isEmpty(values) && !values.equals("null") && !values.equals("0.0") && !values.equals("10") && !values.equals("0");
    }
}
