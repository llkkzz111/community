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
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.List;
import java.util.Map;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/9.
 */

public class FridayGoodsAdapter extends RecyclerView.Adapter<FridayGoodsAdapter.MyViewHolder> {

    private Context mContext;
    private List<CmsItemsBean> data;

    public FridayGoodsAdapter(Context context, List<CmsItemsBean> data) {
        this.mContext = context;
        this.data = data;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_friday_goods, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.onBind(position, data.get(position));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    class MyViewHolder extends BaseViewHolder<CmsItemsBean> {
        @BindView(R.id.iv_goods)
        ImageView goods;
        @BindView(R.id.iv_icon)
        ImageView icon;
        @BindView(R.id.tv_name)
        TextView name;
        @BindView(R.id.tv_description)
        TextView description;
        @BindView(R.id.tv_money)
        TextView money;
        @BindView(R.id.rl_item)
        View item;
        @BindView(R.id.tv_price_pre) TextView tvPricePre;


        public MyViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, final CmsItemsBean bean) {
            LoaderFactory.getLoader().loadNet(goods, bean.getFirstImgUrl());
            description.setText(bean.getSubtitle());
            String value = bean.getSalePrice();
            if (value != null) {
                if (value.contains(".")) {
                    value = value.substring(0, value.indexOf("."));
                }
                money.setText(value);
                tvPricePre.setVisibility(View.VISIBLE);
            }
            item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Map<String, Object> params = ((AbroadBuyActivity) mContext).getParams();
                    OcjStoreDataAnalytics.trackEvent(mContext, bean.getCodeValue(), bean.getTitle(), params);
                    RouterModule.globalToDetail(bean.getContentCode());
                }
            });

            if (bean.getCountryImgUrl() != null && !TextUtils.isEmpty(bean.getCountryImgUrl())) {
                icon.setVisibility(View.VISIBLE);
                LoaderFactory.getLoader().loadNet(icon, bean.getCountryImgUrl(), null);
                name.setText("      " + bean.getTitle());
            } else {
                icon.setVisibility(View.GONE);
                name.setText(bean.getTitle());
            }
        }
    }
}
