package com.ocj.oms.mobile.ui.adapter.holder;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/23.
 */
public class VideoHorizonHolder extends BaseViewHolder<CmsItemsBean> {

    @BindView(R.id.iv_product_url) ImageView product;
    @BindView(R.id.tv_current_price) TextView currentPrice;
    // @BindView(R.id.tv_promotion_type) TextView promotion;
    @BindView(R.id.tv_content) TextView content;
    @BindView(R.id.ll_item_horizon) View item;


    private Context mContext;
    public VideoHorizonHolder(View itemView) {
        super(itemView);
        mContext = itemView.getContext();
    }

    @Override
    public void onBind(int position, final CmsItemsBean bean) {
        currentPrice.setText(bean.getSalePrice());
        content.setText(bean.getTitle());
        //promotion.setText(bean.getDiscount());
        LoaderFactory.getLoader().loadNet(product, bean.getFirstImgUrl());

        item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, Object> params1 = new HashMap<>();
                OcjStoreDataAnalytics.trackEvent(mContext, bean.getCodeValue(), bean.getTitle(), params1);
                RouterModule.videoToDetail(bean.getContentCode());
            }
        });
    }
}
