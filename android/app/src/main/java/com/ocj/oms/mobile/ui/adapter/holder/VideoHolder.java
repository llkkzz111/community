package com.ocj.oms.mobile.ui.adapter.holder;

import android.content.Context;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.video.listener.ItemClickListener;
import com.ocj.oms.utils.convert.NumberUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindColor;
import butterknife.BindView;

/**
 * Created by liu on 2017/5/23.
 */
public class VideoHolder extends BaseViewHolder<CmsItemsBean> {

    @BindView(R.id.iv_shop_cart_url) ImageView ivItems;
    @BindView(R.id.iv_shop_cart) ImageView ivShopCart;
    @BindView(R.id.tv_baking_name) TextView tvTitle;
    @BindView(R.id.tv_current_price) TextView tvCurrentPrice;
    @BindView(R.id.tv_buy_note) TextView tvBuyNote;
    @BindView(R.id.ll_item) View item;
    @BindView(R.id.tv_integral) TextView tvIntegral;
    @BindView(R.id.tv_inte) TextView tvInte;
    @BindView(R.id.tv_gift) TextView tvGift;
    @BindView(R.id.ll_gift) LinearLayout llGift;


    @BindColor(R.color.backgrou_vocher_end) int saleColor;
    @BindColor(R.color.text_grey_999999) int hintColor;

    int mType = 0;

    private ItemClickListener itemClickListener;

    private Context mContext;

    public VideoHolder(View itemView, int type) {
        super(itemView);
        mContext = itemView.getContext();
        this.mType = type;
    }

    public VideoHolder(View itemView, int type, ItemClickListener itemClickListener) {
        super(itemView);
        this.mType = type;
        this.itemClickListener = itemClickListener;
    }

    public void setItemClickListener(ItemClickListener itemClickListener) {
        this.itemClickListener = itemClickListener;
    }

    @Override
    public void onBind(int position, final CmsItemsBean bean) {

        LoaderFactory.getLoader().loadNet(ivItems, bean.getFirstImgUrl());

        tvTitle.setText(bean.getTitle());

        tvCurrentPrice.setText("￥ " + bean.getSalePrice());

        if (TextUtils.isEmpty(bean.getIntegral()) || NumberUtil.convertToDouble(bean.getIntegral()) == 0) {
            tvIntegral.setVisibility(View.GONE);
            tvInte.setVisibility(View.GONE);
        } else {
            tvIntegral.setText(bean.getIntegral());
            tvInte.setVisibility(View.VISIBLE);
            tvIntegral.setVisibility(View.VISIBLE);
        }
        if (bean.getGifts() != null) {
            if (bean.getGifts().size() >= 1) {
                tvGift.setText(bean.getGifts().get(0));
                llGift.setVisibility(View.VISIBLE);
            } else {
                llGift.setVisibility(View.INVISIBLE);
            }
        } else {
            llGift.setVisibility(View.INVISIBLE);
        }
        switch (mType) {
            case Constants.VIDEO_TO_PLAY:
                String value = "";
                float sale = 0;
                if (!TextUtils.isEmpty(bean.getOriginalPrice()) && !TextUtils.isEmpty(bean.getSalePrice())) {
                    sale = Float.valueOf(bean.getOriginalPrice()) - Float.valueOf(bean.getSalePrice());
                    value = sale + "";
                    if (value.contains(".")) {
                        value = value.substring(0, value.indexOf("."));
                    }
                }
                if (sale >= 0) {
                    SpannableStringBuilder builder = new SpannableStringBuilder("比直播便宜¥" + value);
                    ForegroundColorSpan startSpan = new ForegroundColorSpan(hintColor);
                    ForegroundColorSpan endSpan = new ForegroundColorSpan(saleColor);
                    builder.setSpan(startSpan, 0, 5, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                    builder.setSpan(endSpan, 5, builder.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                    tvBuyNote.setText(builder);
                }
                break;

            case Constants.VIDEO_PLAYING:
                if (bean.getSalesVolume() != null && !TextUtils.isEmpty(bean.getSalesVolume())) {
                    tvBuyNote.setText(bean.getSalesVolume() + "人已购买");
                } else {
                    tvBuyNote.setVisibility(View.GONE);
                }
                break;

            case Constants.VIDEO_REPLAY:
                if (bean.getSalesVolume() != null && !TextUtils.isEmpty(bean.getSalesVolume())) {
                    tvBuyNote.setText(bean.getSalesVolume() + "人已购买");
                } else {
                    tvBuyNote.setVisibility(View.GONE);
                }
                break;

        }

        item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, Object> params1 = new HashMap<>();
                OcjStoreDataAnalytics.trackEvent(mContext, bean.getCodeValue(), bean.getTitle(), params1);
                RouterModule.videoToDetail(bean.getContentCode());
            }
        });


        ivShopCart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemClickListener.itemClick(bean);
            }
        });
    }


}
