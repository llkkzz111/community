package com.ocj.oms.mobile.ui.global.widget;

import android.content.Context;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatButton;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.ui.global.Contact;
import com.ocj.oms.mobile.view.GlobalScreenExpressLayout;
import com.ocj.oms.mobile.view.GlobalScreenLayout;

import java.util.List;

/**
 * Created by liu on 2017/6/15.
 */

public class GlobalCategeryLayout extends LinearLayout {

    private GlobalScreenLayout brandLayout;
    private GlobalScreenLayout areaLayout;
    private GlobalScreenExpressLayout typeLayout;

    private AppCompatButton resetBtn;
    private AppCompatButton confirmBtn;

    private List<Contact> mBrandList;
    private List<Contact> mBrandSelectList;

    private List<Contact> mAreaList;
    private List<Contact> mAreaSelectList;

    private List<Contact> mTypeList;
    private List<Contact> mTypeSelectList;

    private OnSelectListener onSelectListener;

    public static final short GLOBAL_BRAND = 1;
    public static final short GLOBAL_AREA = 2;
    public static final short GLOBAL_TYPE = 3;

    public GlobalCategeryLayout(Context context) {
        super(context);
        init(context);
    }

    public GlobalCategeryLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }


    public void setOnSelectListener(OnSelectListener onSelectListener) {
        this.onSelectListener = onSelectListener;
    }

    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.global_screen_layout3, this, true);
        brandLayout = (GlobalScreenLayout) findViewById(R.id.brandLayout);
        areaLayout = (GlobalScreenLayout) findViewById(R.id.areaLayout);
        typeLayout = (GlobalScreenExpressLayout) findViewById(R.id.typeLayout);
        resetBtn = (AppCompatButton) findViewById(R.id.resetBtn);
        confirmBtn = (AppCompatButton) findViewById(R.id.confirmBtn);
        initView();
        setListener();
    }


    private void initView() {
        brandLayout.setText("品牌");
        areaLayout.setText("热门地区");
        typeLayout.setText("类别");
        setListener();
    }

    private void setListener() {
        resetBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                brandLayout.reset();
                areaLayout.reset();
                typeLayout.reset();
            }
        });

        confirmBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onSelectListener != null) {
                    onSelectListener.onBackSelectList(brandLayout.getSelectList(), areaLayout.getSelectList(), typeLayout.getSelectList());
                    onSelectListener.onEnterClick(brandLayout.getSelect(), areaLayout.getSelect(), typeLayout.getSelect());
                }
            }
        });

        brandLayout.setOnSelectListener(new GlobalScreenLayout.OnSelectListener() {
            @Override
            public void moreClick() {
                if (onSelectListener != null) {
                    onSelectListener.onBackSelectList(brandLayout.getSelectList(), areaLayout.getSelectList(), typeLayout.getSelectList());
                    onSelectListener.moreClick(GLOBAL_BRAND);
                }
            }
        });

        areaLayout.setOnSelectListener(new GlobalScreenLayout.OnSelectListener() {
            @Override
            public void moreClick() {
                if (onSelectListener != null) {
                    onSelectListener.onBackSelectList(brandLayout.getSelectList(), areaLayout.getSelectList(), typeLayout.getSelectList());
                    onSelectListener.moreClick(GLOBAL_AREA);
                }
            }
        });

    }

    private void updateView() {
        brandLayout.setData(mBrandList, mBrandSelectList);
        areaLayout.setData(mAreaList, mAreaSelectList);
        typeLayout.setData(mBrandList, mBrandSelectList);
    }

    public void setAreaData(List<Contact> mList, List<Contact> mSelectList) {
        this.mAreaList = mList;
        this.mAreaSelectList = mSelectList;
        areaLayout.setData(mAreaList, mAreaSelectList);
    }

    public void setBrandData(List<Contact> mList, List<Contact> mSelectList) {
        this.mBrandList = mList;
        this.mBrandSelectList = mSelectList;
        brandLayout.setData(mBrandList, mBrandSelectList);
    }

    public void setTypeData(List<Contact> mList, List<Contact> mSelectList) {
        this.mTypeList = mList;
        this.mTypeSelectList = mSelectList;
        typeLayout.setData(mTypeList, mTypeSelectList);
    }


    public interface OnSelectListener {
        void moreClick(short type);

        void onEnterClick(Contact brand, Contact area, Contact type);

        void onResetClick();

        void onBackSelectList(List<Contact> brandList, List<Contact> areaList, List<Contact> typeList);
    }

}
