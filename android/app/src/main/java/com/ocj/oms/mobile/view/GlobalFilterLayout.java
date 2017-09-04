package com.ocj.oms.mobile.view;

import android.content.Context;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatImageView;
import android.support.v7.widget.AppCompatTextView;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RadioGroup;

import com.ocj.oms.mobile.R;

/**
 * Created by shizhang.cai on 2017/6/8.
 */

public class GlobalFilterLayout extends LinearLayout {

    private LinearLayout layoutAll;
    private LinearLayout layoutSales;
    private LinearLayout layoutPrice;
    private LinearLayout layoutOption;

    private AppCompatTextView totalTv;
    private AppCompatImageView sortIv;
    private AppCompatTextView saleTv;

    FilterLayoutClick filterLayoutClick;

    private AppCompatTextView tvOption;
    private AppCompatImageView tvOptionImg;

    private int priceType = 0;
    private int saleType = 0;

    private static final int PRICE_NORMAL = 0;
    private static final int PRICE_UP = 1;
    private static final int PRICE_DOWN = 2;

    private boolean isSales = false;//是否点击了销量排行

    public GlobalFilterLayout(Context context) {
        super(context);
        initView(context);
    }

    public GlobalFilterLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initView(context);
    }

    public GlobalFilterLayout(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(context);
    }

    private void initView(Context context) {
        LinearLineWrapLayout.LayoutParams layoutParams = new LinearLineWrapLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        RadioGroup radioGroup = (RadioGroup) View.inflate(context, R.layout.global_filter_layout, null);

        totalTv = (AppCompatTextView) radioGroup.findViewById(R.id.tv_total);
        totalTv.setTextColor(getResources().getColor(R.color.text_red_E5290D));
        
        sortIv = (AppCompatImageView) radioGroup.findViewById(R.id.sortIv);
        saleTv = (AppCompatTextView) radioGroup.findViewById(R.id.tv_sales);

        layoutAll = (LinearLayout) radioGroup.findViewById(R.id.layout1);
        layoutSales = (LinearLayout) radioGroup.findViewById(R.id.layout2);
        layoutPrice = (LinearLayout) radioGroup.findViewById(R.id.layout3);
        layoutOption = (LinearLayout) radioGroup.findViewById(R.id.layout4);
        tvOption = (AppCompatTextView) radioGroup.findViewById(R.id.tv_option);
        tvOptionImg = (AppCompatImageView) radioGroup.findViewById(R.id.tv_option_img);
        layoutAll.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                resetView();
                totalTv.setTextColor(getResources().getColor(R.color.text_red_E5290D));
                if (null != filterLayoutClick) {
                    filterLayoutClick.onTabAllClick();
                }
            }
        });
        layoutSales.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                resetView();
                saleTv.setTextColor(getResources().getColor(R.color.text_red_E5290D));
                if (null != filterLayoutClick) {
                    if (!isSales) {
                        filterLayoutClick.onSaleClick("1");
                        isSales = true;
                    }

                }
            }
        });
        layoutPrice.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                resetView();
                if (null != filterLayoutClick) {
                    priceType = (priceType + 1) % 3;
                    updatePriceView(priceType);
                    filterLayoutClick.onPriceSortClick(priceType + "");
                    saleTv.setTextColor(getResources().getColor(R.color.text_grey_666666));
                    isSales = false;
                }
            }
        });
        layoutOption.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != filterLayoutClick) {
                    filterLayoutClick.onOptionClick();
                }
            }
        });
        radioGroup.setLayoutParams(layoutParams);
        addView(radioGroup);
    }

    public void resetView() {
        totalTv.setTextColor(getResources().getColor(R.color.text_grey_666666));
        saleTv.setTextColor(getResources().getColor(R.color.text_grey_666666));
        setSortIv(R.drawable.icon_asc_gray);
    }

    public void resetSortAndPriceView() {
        saleTv.setTextColor(getResources().getColor(R.color.text_grey_666666));
        setSortIv(R.drawable.icon_asc_gray);
    }

    /**
     *
     * @param flag
     */
    public void setAllStatus(boolean flag){
        if(flag){
            totalTv.setTextColor(getResources().getColor(R.color.text_red_E5290D));
        }else{
            totalTv.setTextColor(getResources().getColor(R.color.text_grey_666666));
        }
    }


    public interface FilterLayoutClick {
        void onTabAllClick();

        void onSaleClick(String type);

        void onPriceSortClick(String type);

        void onOptionClick();
    }

    private void updatePriceView(int type) {
        switch (type) {
            case PRICE_UP:
                setSortIv(R.drawable.icon_asc);
                break;
            case PRICE_DOWN:
                setSortIv(R.drawable.icon_desc);
                break;
            case PRICE_NORMAL:
            default:
                setSortIv(R.drawable.icon_asc_gray);
                break;

        }
    }

    public void setOptionStatus(boolean flag) {
        if (flag) {
            tvOption.setTextColor(getResources().getColor(R.color.text_red_E5290D));
            tvOptionImg.setImageResource(R.drawable.icon_filter_red);
        } else {
            tvOption.setTextColor(getResources().getColor(R.color.text_grey_666666));
            tvOptionImg.setImageResource(R.drawable.icon_filter_gray);
        }
    }

    public FilterLayoutClick getFilterLayoutClick() {
        return filterLayoutClick;
    }

    public void setFilterLayoutClick(FilterLayoutClick filterLayoutClick) {
        this.filterLayoutClick = filterLayoutClick;
    }

    public void setSortIv(int res) {
        sortIv.setImageResource(res);
    }
}
