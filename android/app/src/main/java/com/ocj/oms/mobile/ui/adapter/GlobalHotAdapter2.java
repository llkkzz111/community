package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.global.GlobalListActivity;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_CONTENT_TYPE;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_LG_ROUP;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_SEARCH_ITEM;


/**
 * Created by pactera on 2017/4/
 */

public class GlobalHotAdapter2 extends RecyclerView.Adapter<GlobalHotAdapter2.RecommendHolder> {

    Context mContext;
    List<CmsItemsBean> recomendList = new ArrayList<>();


    public GlobalHotAdapter2(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<CmsItemsBean> list) {
        this.recomendList.addAll(list);
        this.notifyDataSetChanged();
    }


    @Override
    public RecommendHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_global_hot2, null, false);
        RecommendHolder holder = new RecommendHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(RecommendHolder holder, int position) {
        if (recomendList.size() > 0) {
            if(position<recomendList.size()){
                final CmsItemsBean bean = recomendList.get(position);
                holder.onBind(position, bean);
            }
        }
    }

    @Override
    public int getItemCount() {
        return 5;
    }


    class RecommendHolder extends BaseViewHolder<CmsItemsBean> {
        @BindView(R.id.ll_item) LinearLayout item;
        @BindView(R.id.iv_nation) ImageView nationFlag;
        @BindView(R.id.iv_product) ImageView product;
        @BindView(R.id.tv_merchat_name) TextView merchatName;
        @BindView(R.id.tv_title) TextView advertTitle;

        public RecommendHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, CmsItemsBean bean) {
            LoaderFactory.getLoader().loadNet(product, bean.getFirstImgUrl());
            advertTitle.setText(bean.getSubtitle());
            setClick(item, bean);
            showCountryIcon(mContext, nationFlag, bean, merchatName);
        }

        private void setClick(View view, final CmsItemsBean item) {
            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(mContext, GlobalListActivity.class);
                    intent.putExtra(GLOBAL_SEARCH_ITEM, item.getTitle());
                    if (!TextUtils.isEmpty(item.getLgroup())) {
                        intent.putExtra(GLOBAL_LG_ROUP, item.getLgroup());
                    }
                    if (!TextUtils.isEmpty(item.getContentType())) {
                        intent.putExtra(GLOBAL_CONTENT_TYPE, item.getContentType());
                    }
                    mContext.startActivity(intent);
                }
            });


        }


    }

    /**
     * 显示国旗icon
     *
     * @param context
     * @param imageView
     * @param bean
     * @param textView
     */
    private void showCountryIcon(Context context, ImageView imageView, CmsItemsBean bean, TextView textView) {
        if (bean.getCountryImgUrl() != null && !TextUtils.isEmpty(bean.getCountryImgUrl()) && !bean.getCountryImgUrl().equals("null")) {
            imageView.setVisibility(View.VISIBLE);
            LoaderFactory.getLoader().loadNet(imageView, bean.getCountryImgUrl());
            textView.setText(bean.getTitle());
        } else {
            imageView.setVisibility(View.GONE);
            textView.setText(bean.getTitle());
        }
    }


}
