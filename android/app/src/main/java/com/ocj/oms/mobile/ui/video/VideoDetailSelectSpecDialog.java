package com.ocj.oms.mobile.ui.video;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Paint;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ItemEventBean;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.ColorsSizeBean;
import com.ocj.oms.mobile.bean.items.SpecItemBean;
import com.ocj.oms.mobile.view.NumberAddSubView;
import com.zhy.view.flowlayout.FlowLayout;

import java.util.ArrayList;


/**
 * 视频详情页面商品选择规格接口
 */

public class VideoDetailSelectSpecDialog extends Dialog implements View.OnClickListener {

    private Activity mActivity;
    private ArrayList<SpecItemBean> mSpecList = new ArrayList<>();
    private ArrayList<SpecItemBean> mSizeList = new ArrayList<>();
    private ArrayList<SpecItemBean> mColorList = new ArrayList<>();

    private ImageView ivItem;
    private TextView tvItemSelSpec;
    private TextView tvPrePrice;//抢先价
    private TextView tvOriginPrice;//原始价格
    private TextView tvCheapThanLive;//比直播还便宜
    private TextView tvNumMax;//数量
    private TextView tvZpTitle;

    private ViewGroup ll_gift;

    private FlowLayout fl_spec;
    private FlowLayout flSize;
    private FlowLayout flColor;

    private ViewGroup ll_spec;//规格布局
    private ViewGroup ll_spec_size;//尺寸
    private ViewGroup ll_spec_color;//颜色

    private NumberAddSubView mNumberView;

    private ItemSelectListener itemSelectListener;

    private ColorsSizeBean colorsSizeBean;

    private SpecItemBean preSpecItem;
    private SpecItemBean preColorItem;
    private SpecItemBean preSizeItem;

    private ItemEventBean itemEventBean;

    private int videoType;

    private int max_num_limit = 99;//最多购买商品数
    private int min_num_limit = 1;//最多购买商品数
    private CmsItemsBean cmsItemsBean;
    private TextView tvGift;

    private ArrayList<ItemEventBean.EventMapItem> mGifts = new ArrayList<>();//赠品
    private ItemEventBean.EventMapItem giftSelect;

    public VideoDetailSelectSpecDialog(Activity mActivity) {
        //设置全屏样式
        super(mActivity, R.style.Dialog_Fullscreen);
        this.mActivity = mActivity;
    }

    public void setItemSelectListener(ItemSelectListener itemSelectListener) {
        this.itemSelectListener = itemSelectListener;
    }

    public void setColorsSizeBean(ColorsSizeBean colorsSizeBean) {
        this.colorsSizeBean = colorsSizeBean;
    }

    public void setItemEventBean(ItemEventBean itemEventBean) {
        this.itemEventBean = itemEventBean;
    }

    public void setmGifts(ArrayList<ItemEventBean.EventMapItem> mGifts) {
        this.mGifts = mGifts;
    }

    public void setCmsItemsBean(CmsItemsBean cmsItemsBean) {
        this.cmsItemsBean = cmsItemsBean;
    }

    public void setVideoType(int videoType) {
        this.videoType = videoType;
    }

    public void setMax_num_limit(int max_num_limit) {
        this.max_num_limit = max_num_limit;
    }

    public int getMin_num_limit() {
        return min_num_limit;
    }

    public void setMin_num_limit(int min_num_limit) {
        this.min_num_limit = min_num_limit;
    }

    public void setGiftSelect(ItemEventBean.EventMapItem giftSelect) {
        this.giftSelect = giftSelect;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        View view = getLayoutInflater().inflate(R.layout.dialog_video_deatil_items_spec_select, null);
        setContentView(view);
        Window window = getWindow();
        window.getDecorView().setPadding(0, 0, 0, 0);
        window.setWindowAnimations(R.style.main_menu_animstyle);
        WindowManager.LayoutParams wl = window.getAttributes();
        wl.x = 0;
        wl.y = mActivity.getWindowManager().getDefaultDisplay().getHeight();

        wl.width = ViewGroup.LayoutParams.MATCH_PARENT;
        wl.height = ViewGroup.LayoutParams.WRAP_CONTENT;

        onWindowAttributesChanged(wl);
        setCanceledOnTouchOutside(true);

        view.findViewById(R.id.iv_close).setOnClickListener(this);
        view.findViewById(R.id.btn_enter).setOnClickListener(this);

        tvZpTitle = (TextView) view.findViewById(R.id.tv_zp_title);

        mNumberView = (NumberAddSubView) view.findViewById(R.id.num_add_sub_view);
        mNumberView.setMinValue(min_num_limit);
        mNumberView.setMaxValue(max_num_limit);
        mNumberView.setOnButtonClickListenter(new NumberAddSubView.OnButtonClickListenter() {
            @Override
            public void onButtonAddClick(View view, int value) {

            }

            @Override
            public void onButtonSubClick(View view, int value) {

            }
        });


        ivItem = (ImageView) view.findViewById(R.id.iv_item);
        LoaderFactory.getLoader().loadNet(ivItem, cmsItemsBean.getFirstImgUrl(), null);

        tvPrePrice = (TextView) view.findViewById(R.id.tv_pre_price);
        tvPrePrice.setText(cmsItemsBean.getSalePrice());

        tvOriginPrice = (TextView) view.findViewById(R.id.tv_origin_price);
        if (!cmsItemsBean.getOriginalPrice().equals("0")) {
            tvOriginPrice.setText(cmsItemsBean.getOriginalPrice());
            tvOriginPrice.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);
        } else {
            tvOriginPrice.setVisibility(View.GONE);
        }


        tvNumMax = (TextView) view.findViewById(R.id.tv_num_max);
        tvCheapThanLive = (TextView) view.findViewById(R.id.tv_cheap_than_live);

        if (max_num_limit != 0) {
            tvNumMax.setText(mActivity.getString(R.string.quantity_choice, max_num_limit));
        }
        switch (videoType) {
            case 1:
                float sale = Float.valueOf(cmsItemsBean.getOriginalPrice()) - Float.valueOf(cmsItemsBean.getSalePrice());
                if (sale > 0) {
                    tvCheapThanLive.setText(Html.fromHtml(mActivity.getString(R.string.cheap_than_live, sale + "")));
                }
                break;
            case 2:
            case 3:
                tvCheapThanLive.setText(mActivity.getString(R.string.people_already_buy, cmsItemsBean.getSalesVolume()));
                break;
        }

        tvItemSelSpec = (TextView) view.findViewById(R.id.tv_item_sel_spec);

        fl_spec = (FlowLayout) view.findViewById(R.id.fl_spec);
        flSize = (FlowLayout) view.findViewById(R.id.fl_size);
        flColor = (FlowLayout) view.findViewById(R.id.fl_color);

        ll_spec = (ViewGroup) view.findViewById(R.id.ll_spec);
        ll_spec_size = (ViewGroup) view.findViewById(R.id.ll_spec_size);
        ll_spec_color = (ViewGroup) view.findViewById(R.id.ll_spec_color);


        ll_gift = (ViewGroup) view.findViewById(R.id.ll_gift);
        if (itemEventBean != null && itemEventBean.zpMap != null && itemEventBean.zpMap.size() > 0) {
            ll_gift.setVisibility(View.VISIBLE);
        }
        ll_gift.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemSelectListener.showGiftDialog(mGifts, giftSelect);
            }
        });

        tvGift = (TextView) view.findViewById(R.id.tv_gift);

        initData();
        initView();
    }

    @Override
    public void show() {
        super.show();
        updateTagStatus(preColorItem, mTagsColorList);
        updateTagStatus(preSizeItem, mTagSizeList);
        updateTagStatus(preSpecItem, mTagsSpecList);
    }

    /**
     * 更新标签状态
     *
     * @param bean
     * @param mList
     */
    private void updateTagStatus(SpecItemBean bean, ArrayList<RadioButton> mList) {
        if (bean != null) {
            for (int i = 0; i < mList.size(); i++) {
                RadioButton rb = mList.get(i);
                SpecItemBean colorItem = (SpecItemBean) rb.getTag();
                if (colorItem.getCs_code().equals(bean.getCs_code())) {
                    rb.performClick();
                }
            }
        }
    }

    private void initFlowLayout(ArrayList<SpecItemBean> list, ArrayList<SpecItemBean> mList, ViewGroup vgContainer) {
        if (colorsSizeBean != null && list != null && list.size() > 0) {
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i).getHidden_wu().equals("N")) {
                    mList.add(list.get(i));
                }
            }
            if (mList.size() > 0) {
                vgContainer.setVisibility(View.VISIBLE);
            } else {
                vgContainer.setVisibility(View.GONE);
            }
        } else {
            vgContainer.setVisibility(View.GONE);
        }
    }

    private void initData() {
        if (colorsSizeBean != null && colorsSizeBean.getColorsizes() != null) {
            initFlowLayout(colorsSizeBean.getColorsizes(), mSpecList, ll_spec);
        }
        if (colorsSizeBean != null && colorsSizeBean.getSizes() != null) {
            initFlowLayout(colorsSizeBean.getSizes(), mSizeList, ll_spec_size);
        }
        if (colorsSizeBean != null && colorsSizeBean.getColors() != null) {
            initFlowLayout(colorsSizeBean.getColors(), mColorList, ll_spec_color);
        }
    }

    private ArrayList<RadioButton> mTagsSpecList = new ArrayList<>();
    private ArrayList<RadioButton> mTagsColorList = new ArrayList<>();
    private ArrayList<RadioButton> mTagSizeList = new ArrayList<>();

    private void initView() {
        setFlowLayout(mSpecList, mTagsSpecList, fl_spec);//初始化规格
        setFlowLayout(mColorList, mTagsColorList, flColor);//初始化颜色
        setFlowLayout(mSizeList, mTagSizeList, flSize);//初始化大小

        setTagClickListener(mTagSizeList, mTagsColorList, 1);
        setTagClickListener(mTagsColorList, mTagSizeList, 2);
        setTagClickListener(mTagsSpecList);
    }

    private int sizePos = -1;
    private int colorPos = -1;
    private int specPos = -1;

    public void setGiftText(String strs) {
        tvGift.setText(strs);
    }

    /**
     * @param first
     * @param second
     * @param category 1尺寸 2颜色
     */
    private void setTagClickListener(final ArrayList<RadioButton> first, final ArrayList<RadioButton> second, final int category) {
        for (int i = 0; i < first.size(); i++) {
            final RadioButton rb = first.get(i);
            final int finalI = i;
            final SpecItemBean sizeItem = (SpecItemBean) rb.getTag();
            rb.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    for (int j = 0; j < first.size(); j++) {
                        if (first.get(j).isEnabled()) {
                            first.get(j).setChecked(false);
                        }
                    }
                    if (rb.isEnabled()) {
                        rb.setChecked(true);
                        if (category == 1) {
                            sizePos = finalI;
                        } else {
                            colorPos = finalI;
                        }

                    }

                    //刷新联动标签
                    for (int k = 0; k < second.size(); k++) {
                        RadioButton rb = second.get(k);
                        SpecItemBean colorItem = (SpecItemBean) rb.getTag();

                        if (category == 1) {
                            if (colorPos == k) {
                                rb.setChecked(true);
                            }
                        } else {
                            if (sizePos == k) {
                                rb.setChecked(true);
                            }
                        }

                        if (sizeItem.getCs_off().contains(colorItem.getCs_code())) {
                            rb.setChecked(false);
                            rb.setEnabled(false);
                        } else {
                            if (colorItem.getIs_show().equals("Y")) {
                                rb.setEnabled(true);
                            }
                        }
                    }
                    updateSizeColorText();
                }
            });
        }
    }

    /**
     * @param alone
     */
    private void setTagClickListener(final ArrayList<RadioButton> alone) {
        for (int i = 0; i < alone.size(); i++) {
            final RadioButton rb = alone.get(i);
            final int finalI = i;
            final SpecItemBean sizeItem = (SpecItemBean) rb.getTag();
            rb.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    for (int j = 0; j < alone.size(); j++) {
                        if (alone.get(j).isEnabled()) {
                            alone.get(j).setChecked(false);
                        }
                    }
                    if (rb.isEnabled()) {
                        rb.setChecked(true);
                        specPos = finalI;
                    }
                    updateSpecText();
                }
            });
        }
    }

    private void setFlowLayout(ArrayList<SpecItemBean> list, final ArrayList<RadioButton> rbList, FlowLayout flowLayout) {
        for (int i = 0; i < list.size(); i++) {
            final RadioButton rb = (RadioButton) LayoutInflater.from(mActivity).inflate(R.layout.radion_button_tag,
                    flColor, false);
            rb.setTag(list.get(i));
            rb.setText(list.get(i).getCs_name());
            if (list.get(i).getIs_show().equals("N")) {
                rb.setEnabled(false);
            }
            rbList.add(rb);
            flowLayout.addView(rb);
        }
    }

    /**
     * 获取选择项
     *
     * @param aloneList
     * @return
     */
    private SpecItemBean getSelectItem(ArrayList<RadioButton> aloneList) {
        SpecItemBean specTag = null;
        for (int i = 0; i < aloneList.size(); i++) {
            if (aloneList.get(i).isChecked()) {
                RadioButton rb = aloneList.get(i);
                specTag = (SpecItemBean) rb.getTag();
                break;
            }
        }
        return specTag;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_close:
                dismiss();
                break;
            case R.id.btn_enter:
                //回传数据

                String unitCode = "";
                String content = "";
                if (itemSelectListener != null) {

                    if (mTagSizeList.size() > 0) {
                        if (getSelectItem(mTagSizeList) == null) {
                            ToastUtils.showShortToast("请选择尺寸");
                            return;
                        }
                        unitCode = getSelectItem(mTagSizeList).getCs_code();
                        content = "“" + getSelectItem(mTagSizeList).getCs_name() + "”";
                    }

                    if (mTagsColorList.size() > 0) {
                        if (getSelectItem(mTagsColorList) == null) {
                            ToastUtils.showShortToast("请选择颜色");
                            return;
                        }
                        if (!TextUtils.isEmpty(unitCode)) {
                            unitCode += ":" + getSelectItem(mTagsColorList).getCs_code();
                        } else {
                            unitCode = getSelectItem(mTagsColorList).getCs_code();
                        }
                        content += "“" + getSelectItem(mTagsColorList).getCs_name() + "”";
                    }

                    if (mTagsSpecList.size() > 0) {
                        if (getSelectItem(mTagsSpecList) == null) {
                            ToastUtils.showShortToast("请选择规格");
                            return;
                        }
                        unitCode = getSelectItem(mTagsSpecList).getCs_code();
                        content = "“" + getSelectItem(mTagsSpecList).getCs_name() + "”";
                    }

                    if (mGifts != null && mGifts.size() > 0 && giftSelect == null) {
                        ToastUtils.showShortToast("请选择赠品");
                        return;
                    }
                    if (TextUtils.isEmpty(unitCode)) {
                        unitCode = "001";
                    }
                    itemSelectListener.selectItem(mNumberView.getValue(), unitCode, giftSelect);
                }
                dismiss();
                break;
        }
    }

    /**
     * 有颜色和尺寸的时候
     */
    private void updateSizeColorText() {
        String size = "";
        String color = "";
        SpecItemBean sizeBean = getSelectItem(mTagSizeList);
        if (sizeBean != null) {
            size = sizeBean.getCs_name();
        }
        SpecItemBean colorBean = getSelectItem(mTagsColorList);
        if (colorBean != null) {
            color = colorBean.getCs_name();
        }
        String values = "";
        if (!TextUtils.isEmpty(size)) {
            values = "“" + size + "”";
        }
        if (!TextUtils.isEmpty(color)) {
            values += "“" + color + "”";
        }
        tvItemSelSpec.setText(mActivity.getString(R.string.item_select_spec, values));
    }

    /**
     * 只有一项规格时候
     */
    private void updateSpecText() {
        String spec = null;
        SpecItemBean specBean = getSelectItem(mTagsSpecList);
        if (specBean != null) {
            spec = specBean.getCs_name();
        }
        tvItemSelSpec.setText(mActivity.getString(R.string.item_select_spec, spec));
    }

    public interface ItemSelectListener {

        void selectItem(int num, String item_unit_Code, ItemEventBean.EventMapItem select);

        void showGiftDialog(ArrayList<ItemEventBean.EventMapItem> mLists, ItemEventBean.EventMapItem select);
    }
}
