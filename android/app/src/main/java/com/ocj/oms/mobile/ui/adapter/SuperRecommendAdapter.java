package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
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
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.rn.NumUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;


/**
 * Created by pactera on 2017/4/
 */

public class SuperRecommendAdapter extends RecyclerView.Adapter<SuperRecommendAdapter.SuperHolder> {

    Context mContext;
    List<CmsItemsBean> recomendList = new ArrayList<>();


    public SuperRecommendAdapter(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<CmsItemsBean> list) {
        this.recomendList = list;
        this.notifyDataSetChanged();
    }

    public void addDatas(List<CmsItemsBean> list) {
        if (list != null) {
            this.recomendList.addAll(list);
            this.notifyDataSetChanged();
        }
    }


    @Override
    public SuperHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_super_recommend, parent, false);
        SuperHolder holder = new SuperHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(SuperHolder holder, int position) {
        holder.onBind(position, recomendList.get(position));
    }

    @Override
    public int getItemCount() {
        return recomendList.size();
    }


    class SuperHolder extends BaseViewHolder<CmsItemsBean> {


        @BindView(R.id.iv_product)
        ImageView product;
        @BindView(R.id.iv_nation)
        ImageView nationFlag;
        @BindView(R.id.tv_description)
        TextView descrip;
        @BindView(R.id.tv_discount)
        TextView discount;
        @BindView(R.id.tv_price)
        TextView price;

        @BindView(R.id.tv_unit)
        TextView tvUnit;

        @BindView(R.id.tv_storage)
        TextView storage;


        @BindView(R.id.tv_product)
        TextView tv_product;


        private CmsItemsBean data;


        public SuperHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, CmsItemsBean bean) {
            this.data = bean;
            if (isNotNull(data.getDiscount())) {
                discount.setText(data.getDiscount() + "折");
                discount.setVisibility(View.VISIBLE);
            } else {
                discount.setVisibility(View.GONE);
            }

            if (isNotNull(data.getSalePrice())) {
                String value = data.getSalePrice();
                if (value.contains(".")) {
                    value = value.substring(0, value.indexOf("."));
                }
                price.setText(value);
                price.setVisibility(View.VISIBLE);
                tvUnit.setVisibility(View.VISIBLE);
            } else {
                price.setVisibility(View.INVISIBLE);
                tvUnit.setVisibility(View.GONE);
            }

            descrip.setText(data.getSubtitle());

            if (isNotNull(data.getInStock()) && !NumUtils.checkStringIsNum(data.getInStock())) {
                storage.setVisibility(View.VISIBLE);
                storage.setText(data.getInStock());

            } else {
                storage.setVisibility(View.GONE);
            }


            LoaderFactory.getLoader().loadNet(product, bean.getFirstImgUrl(), R.drawable.icon_dougou_def);

            if (isNotNull(data.getCountryImgUrl())) {
                nationFlag.setVisibility(View.VISIBLE);
                LoaderFactory.getLoader().loadNet(nationFlag, bean.getCountryImgUrl());
                if (isNotNull(data.getDiscount())) {
                    tv_product.setText(mContext.getString(R.string.space_text_20, data.getTitle()));
                } else {
                    tv_product.setText(mContext.getString(R.string.space_text_7, data.getTitle()));
                }
            } else {
                nationFlag.setVisibility(View.GONE);
                if (isNotNull(data.getDiscount())) {
                    tv_product.setText(mContext.getString(R.string.space_text_7, data.getTitle()));
                } else {
                    tv_product.setText(bean.getTitle());
                }
            }
        }

        @OnClick({R.id.ll_item})
        void onClick(View v) {
            Map<String, Object> params1 = ((AbroadBuyActivity) mContext).getParams();
            OcjStoreDataAnalytics.trackEvent(mContext, data.getCodeValue(), data.getTitle(), params1);
            RouterModule.globalToDetail(data.getContentCode());
        }
    }

    private boolean isNotNull(String values) {
        return values != null && !TextUtils.isEmpty(values) && !values.equals("null") && !values.equals("0.0") && !values.equals("10") && !values.equals("0");
    }

}
