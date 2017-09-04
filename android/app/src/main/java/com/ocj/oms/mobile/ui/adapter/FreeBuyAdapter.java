package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.content.Intent;
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
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_LG_ROUP;
import static com.ocj.oms.mobile.ui.global.GlobalListActivity.TWO_YUAN_KEY;


/**
 * Created by pactera on 2017/4/
 */

public class FreeBuyAdapter extends RecyclerView.Adapter<FreeBuyAdapter.FreeBuyHolder> {

    Context mContext;
    List<CmsItemsBean> recomendList = new ArrayList<>();


    public FreeBuyAdapter(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<CmsItemsBean> list) {
        recomendList.clear();
        recomendList.addAll(list);
        this.notifyDataSetChanged();
    }


    @Override
    public FreeBuyHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_free_buy, parent, false);
        FreeBuyHolder holder = new FreeBuyHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(FreeBuyHolder holder, int position) {
        final CmsItemsBean bean = recomendList.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public int getItemCount() {
        return recomendList.size();
    }


    class FreeBuyHolder extends BaseViewHolder<CmsItemsBean> {


        @BindView(R.id.iv_product) ImageView product;
        @BindView(R.id.iv_nation) ImageView nationFlag;
        @BindView(R.id.tv_product_mark) TextView productMark;
        @BindView(R.id.tv_price) TextView price;
        @BindView(R.id.tv_price_pre) TextView tvPricePre;
        @BindView(R.id.tv_more) TextView tvMore;


        private CmsItemsBean data;


        public FreeBuyHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, CmsItemsBean bean) {
            this.data = bean;
            String value = data.getSalePrice();
            if (value != null) {
                if (value.contains(".")) {
                    value = value.substring(0, value.indexOf("."));
                }
                price.setText(value);
                tvPricePre.setVisibility(View.VISIBLE);
            }

            if (position + 1 == recomendList.size()) {
                tvMore.setVisibility(View.VISIBLE);
            } else {
                tvMore.setVisibility(View.GONE);
            }

            tvMore.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(mContext, GlobalListActivity.class);
                    intent.putExtra(GLOBAL_LG_ROUP, TWO_YUAN_KEY);
                    mContext.startActivity(intent);
                }
            });

            LoaderFactory.getLoader().loadNet(product, bean.getFirstImgUrl());

            if (bean.getCountryImgUrl() != null && !TextUtils.isEmpty(bean.getCountryImgUrl())) {
                nationFlag.setVisibility(View.VISIBLE);
                LoaderFactory.getLoader().loadNet(nationFlag, bean.getCountryImgUrl());
                productMark.setText("      " + data.getTitle());
            } else {
                nationFlag.setVisibility(View.GONE);
                productMark.setText(data.getTitle());
            }

        }

        @OnClick({R.id.ll_item})
        void onClick(View v) {
            Map<String, Object> params = ((AbroadBuyActivity) mContext).getParams();
            OcjStoreDataAnalytics.trackEvent(mContext, data.getCodeValue(), data.getTitle(), params);
            RouterModule.globalToDetail(data.getContentCode());
        }
    }

}
