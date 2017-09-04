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
import com.ocj.oms.mobile.bean.items.SameRecommendBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;


/**
 * Created by pactera on 2017/4/
 */

public class OrderRecommendAdapter extends RecyclerView.Adapter<OrderRecommendAdapter.SuperHolder> {

    Context mContext;
    List<SameRecommendBean> recomendList = new ArrayList<>();


    public OrderRecommendAdapter(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<SameRecommendBean> list) {
        this.recomendList = list;
        this.notifyDataSetChanged();
    }


    @Override
    public SuperHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_recommend, parent, false);
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


    class SuperHolder extends BaseViewHolder<SameRecommendBean> {


        @BindView(R.id.iv_product) ImageView product;
        @BindView(R.id.tv_hot) TextView hotAlarm;
        @BindView(R.id.tv_description) TextView descrip;
        @BindView(R.id.tv_product_title) TextView productTitle;
        @BindView(R.id.tv_price) TextView price;
        @BindView(R.id.tv_storage) TextView storage;
        @BindView(R.id.tv_score) TextView score;

        private SameRecommendBean data;

        public SuperHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, SameRecommendBean bean) {
            this.data = bean;
            productTitle.setText(data.getITEM_NAME());
            price.setText("￥" + data.getSALE_PRICE());
            descrip.setText(data.getITEM_NAME());

            if (TextUtils.isEmpty(data.getSALES_VOLUME())) {
                storage.setVisibility(View.GONE);
            } else {
                storage.setVisibility(View.VISIBLE);
                storage.setText(data.getSALES_VOLUME());
            }
            score.setText(bean.getDc());
            LoaderFactory.getLoader().loadNet(product, bean.getUrl());
        }

        @OnClick({R.id.ll_item})
        void onClick(View v) {
            RouterModule.mainToDetail(data.getITEM_CODE());
        }
    }

}
