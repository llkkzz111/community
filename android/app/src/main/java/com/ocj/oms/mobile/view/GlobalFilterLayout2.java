package com.ocj.oms.mobile.view;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatButton;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RadioGroup;

import com.ocj.oms.mobile.R;

/**
 * Created by shizhang.cai on 2017/6/9.
 */

public class GlobalFilterLayout2 extends LinearLayout {

    public AppCompatButton singleBtn;
    public AppCompatButton areaBtn;
    public AppCompatButton brandBtn;
    private FilterLayoutClick filterLayoutClick;
    private Drawable defaultDrawable;
    private Drawable selectDrawable;
    private Drawable grayRight;
    private Drawable redRight;

    private boolean isSingle = false;

    public GlobalFilterLayout2(Context context) {
        super(context);
        initView(context);

    }

    public GlobalFilterLayout2(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initView(context);
    }

    public GlobalFilterLayout2(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(context);
    }

    private void initView(Context context) {
        initDrawable();
        LinearLineWrapLayout.LayoutParams layoutParams = new LinearLineWrapLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        RadioGroup radioGroup = (RadioGroup) View.inflate(context, R.layout.global_filter_layout2, null);
        singleBtn = (AppCompatButton) radioGroup.findViewById(R.id.singleBtn);
        areaBtn = (AppCompatButton) radioGroup.findViewById(R.id.areaBtn);
        brandBtn = (AppCompatButton) radioGroup.findViewById(R.id.brandBtn);
        radioGroup.setLayoutParams(layoutParams);
        singleBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != filterLayoutClick) {
                    isSingle = !isSingle;
                    if (isSingle) {
                        singleBtn.setTextColor(getResources().getColor(R.color.text_red_ed1c41));
                        singleBtn.setBackgroundDrawable(selectDrawable);
                    } else {
                        singleBtn.setTextColor(getResources().getColor(R.color.text_grey_666666));
                        singleBtn.setBackgroundDrawable(defaultDrawable);
                    }
                    singleBtn.setTag(isSingle);
                    filterLayoutClick.onTabClick(0, singleBtn);
                }
            }
        });
        areaBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != filterLayoutClick) {
                    filterLayoutClick.onTabClick(1, areaBtn);
                }
            }
        });
        brandBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != filterLayoutClick) {
                    filterLayoutClick.onTabClick(2, areaBtn);
                }
            }
        });
        addView(radioGroup);
    }

    public boolean isSinglePro() {
        return isSingle;
    }

    public void setSingle(boolean flag){
        isSingle = flag;
        if(flag){
            singleBtn.setTextColor(getResources().getColor(R.color.text_red_ed1c41));
            singleBtn.setBackgroundDrawable(selectDrawable);
        }else{
            singleBtn.setTextColor(getResources().getColor(R.color.text_grey_666666));
            singleBtn.setBackgroundDrawable(defaultDrawable);
        }
        singleBtn.setTag(isSingle);
    }

    /**
     * 初始化drawable
     */
    private void initDrawable() {
        defaultDrawable = getContext().getResources().getDrawable(R.drawable.bg_global_btn);
        selectDrawable = getContext().getResources().getDrawable(R.drawable.bg_global_select_btn);
        grayRight = getContext().getResources().getDrawable(R.drawable.icon_right_gray);
        redRight = getContext().getResources().getDrawable(R.drawable.icon_right_red);
    }

    /**
     * 清除样式
     */
    public void clearStyle() {
        singleBtn.setBackgroundDrawable(defaultDrawable);
        areaBtn.setBackgroundDrawable(defaultDrawable);
        brandBtn.setBackgroundDrawable(defaultDrawable);
        areaBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, grayRight, null);
        brandBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, grayRight, null);
    }

    public void setAreBtnText(String text) {
        if (TextUtils.isEmpty(text)) {
            areaBtn.setText("热门地区");
            areaBtn.setTextColor(getResources().getColor(R.color.text_grey_666666));
            areaBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, grayRight, null);
            areaBtn.setBackgroundDrawable(defaultDrawable);
        } else {
            areaBtn.setText(text);
            areaBtn.setTextColor(getResources().getColor(R.color.text_red_ed1c41));
            areaBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, redRight, null);
            areaBtn.setBackgroundDrawable(selectDrawable);
        }
    }

    public void setBrandBtnText(String text) {
        if (TextUtils.isEmpty(text)) {
            brandBtn.setText("品牌");
            brandBtn.setTextColor(getResources().getColor(R.color.text_grey_666666));
            brandBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, grayRight, null);
            brandBtn.setBackgroundDrawable(defaultDrawable);
        } else {
            brandBtn.setText(text);
            brandBtn.setTextColor(getResources().getColor(R.color.text_red_ed1c41));
            brandBtn.setCompoundDrawablesWithIntrinsicBounds(null, null, redRight, null);
            brandBtn.setBackgroundDrawable(selectDrawable);
        }
    }

    /**
     * 设置样式
     */
    public void selectStyle(AppCompatButton btn, boolean right) {
        btn.setBackground(selectDrawable);
        if (right) {
            btn.setCompoundDrawablesWithIntrinsicBounds(null, null, redRight, null);
        }
    }

    public interface FilterLayoutClick {
        void onTabClick(int position, AppCompatButton button);
    }

    public FilterLayoutClick getFilterLayoutClick() {
        return filterLayoutClick;
    }

    public void setFilterLayoutClick(FilterLayoutClick filterLayoutClick) {
        this.filterLayoutClick = filterLayoutClick;
    }
}
