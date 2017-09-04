package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.AbroadBuyActivity;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.global.GlobalListActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_CONTENT_TYPE;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_LG_ROUP;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_SEARCH_ITEM;


/**
 * Created by pactera on 2017/4/
 */

public class SortAdapter extends RecyclerView.Adapter<SortAdapter.SortHolder> {

    Context mContext;
    List<CmsItemsBean> recomendList = new ArrayList<>();


    public SortAdapter(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<CmsItemsBean> list) {
        this.recomendList = list;
        this.notifyDataSetChanged();
    }


    @Override
    public SortHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_product_sort, null, false);
        SortHolder holder = new SortHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(SortHolder holder, int position) {
        final CmsItemsBean bean = recomendList.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public int getItemCount() {
        return recomendList.size();
    }


    class SortHolder extends BaseViewHolder<CmsItemsBean> {


        @BindView(R.id.iv_product) ImageView product;
        @BindView(R.id.tv_kind_name) TextView kindName;
        @BindView(R.id.iv_promotion_type) ImageView ivPromotion;
        @BindView(R.id.cardView) CardView cardView;

        private CmsItemsBean data;


        public SortHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, CmsItemsBean bean) {
            this.data = bean;

            if (position % 2 == 0) {
                cardView.setCardBackgroundColor(mContext.getResources().getColor(R.color.purple_light));
            } else {
                cardView.setCardBackgroundColor(mContext.getResources().getColor(R.color.purple_light2));
            }

            LoaderFactory.getLoader().loadNet(product, bean.getFirstImgUrl());

            kindName.setText(bean.getTitle());

            switch (bean.getIsNew()) {
                case 1:
                    ivPromotion.setVisibility(View.VISIBLE);
                    ivPromotion.setImageResource(R.drawable.icon_global_new);
                    break;
                case 2:
                    ivPromotion.setVisibility(View.VISIBLE);
                    ivPromotion.setImageResource(R.drawable.icon_global_promote);
                    break;
                default:
                    ivPromotion.setVisibility(View.GONE);
                    break;
            }


        }

        @OnClick({R.id.ll_item_sort})
        void onClick(View v) {
            Map<String,Object> params = ((AbroadBuyActivity)mContext).getParams();
            OcjStoreDataAnalytics.trackEvent(mContext,data.getCodeValue(),data.getTitle(),params);
            Intent intent = new Intent(mContext, GlobalListActivity.class);
            intent.putExtra(GLOBAL_SEARCH_ITEM, data.getTitle());
            if (!TextUtils.isEmpty(data.getLgroup())) {
                intent.putExtra(GLOBAL_LG_ROUP, data.getLgroup());
            }
            if (!TextUtils.isEmpty(data.getContentType())) {
                intent.putExtra(GLOBAL_CONTENT_TYPE, data.getContentType());
            }
            mContext.startActivity(intent);
        }
    }


}
