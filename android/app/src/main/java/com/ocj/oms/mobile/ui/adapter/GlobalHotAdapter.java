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
import com.ocj.oms.mobile.ui.AbroadBuyActivity;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.global.GlobalListActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_CONTENT_TYPE;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_LG_ROUP;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_SEARCH_ITEM;


/**
 * Created by pactera on 2017/4/
 */

public class GlobalHotAdapter extends RecyclerView.Adapter<GlobalHotAdapter.RecommendHolder> {

    Context mContext;
    List<CmsItemsBean> recomendList = new ArrayList<>();


    public GlobalHotAdapter(Context context) {
        this.mContext = context;
    }

    public void setDatas(List<CmsItemsBean> list) {
        this.recomendList = list;
        this.notifyDataSetChanged();
    }


    @Override
    public RecommendHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_global_hot, null, false);
        RecommendHolder holder = new RecommendHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(RecommendHolder holder, int position) {
        final CmsItemsBean bean = recomendList.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public int getItemCount() {
        return 2;
    }


    class RecommendHolder extends BaseViewHolder<CmsItemsBean> {
        @BindView(R.id.ll_item1) LinearLayout item;
        @BindView(R.id.iv_nation1) ImageView nationFlag;
        @BindView(R.id.iv_product1) ImageView product;
        @BindView(R.id.tv_merchat_name1) TextView merchatName;
        @BindView(R.id.tv_title1) TextView advertTitle;

        @BindView(R.id.ll_item2) LinearLayout item2;
        @BindView(R.id.iv_nation2) ImageView nationFlag2;
        @BindView(R.id.iv_product2) ImageView product2;
        @BindView(R.id.tv_merchat_name2) TextView merchatName2;
        @BindView(R.id.tv_title2) TextView advertTitle2;

        @BindView(R.id.ll_item3) LinearLayout item3;
        @BindView(R.id.iv_nation3) ImageView nationFlag3;
        @BindView(R.id.iv_product3) ImageView product3;
        @BindView(R.id.tv_merchat_name3) TextView merchatName3;
        @BindView(R.id.tv_title3) TextView advertTitle3;

        public RecommendHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, CmsItemsBean bean) {
            if (position == 0) {
                LoaderFactory.getLoader().loadNet(product, recomendList.get(0).getFirstImgUrl());
                advertTitle.setText(recomendList.get(0).getSubtitle());
                setClick(item, recomendList.get(0));
                showCountryIcon(mContext, nationFlag, recomendList.get(0), merchatName);

                LoaderFactory.getLoader().loadNet(product2, recomendList.get(1).getFirstImgUrl());
                advertTitle2.setText(recomendList.get(1).getSubtitle());
                showCountryIcon(mContext, nationFlag2, recomendList.get(1), merchatName2);
                setClick(item2, recomendList.get(1));

                item3.setVisibility(View.GONE);
            } else {
                LoaderFactory.getLoader().loadNet(product, recomendList.get(2).getFirstImgUrl());
                advertTitle.setText(recomendList.get(2).getSubtitle());
                showCountryIcon(mContext, nationFlag, recomendList.get(2), merchatName);
                setClick(item, recomendList.get(2));

                LoaderFactory.getLoader().loadNet(product2, recomendList.get(3).getFirstImgUrl());
                advertTitle2.setText(recomendList.get(3).getSubtitle());
                showCountryIcon(mContext, nationFlag2, recomendList.get(3), merchatName2);
                setClick(item2, recomendList.get(3));

                if (recomendList.size() > 4) {//防止服务器只返回4条数据报错
                    LoaderFactory.getLoader().loadNet(product3, recomendList.get(4).getFirstImgUrl());
                    advertTitle3.setText(recomendList.get(4).getSubtitle());
                    showCountryIcon(mContext, nationFlag3, recomendList.get(4), merchatName3);
                    setClick(item3, recomendList.get(4));
                    item3.setVisibility(View.VISIBLE);
                }

            }
        }


        private void setClick(View view, final CmsItemsBean item) {
            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Map<String, Object> params1 = ((AbroadBuyActivity) mContext).getParams();
                    OcjStoreDataAnalytics.trackEvent(mContext, item.getCodeValue(), item.getTitle(), params1);

                    Intent intent = new Intent(mContext, GlobalListActivity.class);
                    intent.putExtra(GLOBAL_SEARCH_ITEM, item.getTitle());
                    intent.putExtra("title", item.getTitle());
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
        if (bean.getCountryImgUrl() != null && !TextUtils.isEmpty(bean.getCountryImgUrl())) {
            imageView.setVisibility(View.VISIBLE);
            LoaderFactory.getLoader().loadNet(imageView, bean.getCountryImgUrl());
            textView.setText(bean.getTitle());
        } else {
            imageView.setVisibility(View.GONE);
            textView.setText(bean.getTitle());
        }
    }


}
