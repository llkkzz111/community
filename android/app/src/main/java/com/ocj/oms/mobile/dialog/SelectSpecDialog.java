package com.ocj.oms.mobile.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
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
import com.ocj.oms.mobile.bean.items.ColorsSizeBean;
import com.ocj.oms.mobile.bean.items.SpecItemBean;
import com.zhy.view.flowlayout.FlowLayout;

import java.util.ArrayList;


/**
 * 退换货选择规格弹框
 */

public class SelectSpecDialog extends Dialog implements View.OnClickListener {

    private Activity mActivity;
    private String img_url;
    private String money;
    private String spec;
    private ArrayList<SpecItemBean> mSpecList = new ArrayList<>();
    private ArrayList<SpecItemBean> mSizeList = new ArrayList<>();
    private ArrayList<SpecItemBean> mColorList = new ArrayList<>();

    private String size;
    private String color;

    private ImageView ivItem;
    private TextView tvAmout;
    private TextView tvItemSelSpec;

    private FlowLayout fl_spec;
    private FlowLayout flSize;
    private FlowLayout flColor;

    private ViewGroup ll_spec;//规格布局
    private ViewGroup ll_spec_size;//尺寸
    private ViewGroup ll_spec_color;//颜色

    private ItemSelectListener itemSelectListener;

    private ColorsSizeBean colorsSizeBean;

    private SpecItemBean preSpecItem;
    private SpecItemBean preColorItem;
    private SpecItemBean preSizeItem;


    public SelectSpecDialog(Activity mActivity) {
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

    public void setPreSpecItem(SpecItemBean preSpecItem) {
        this.preSpecItem = preSpecItem;
    }

    public void setPreColorItem(SpecItemBean preColorItem) {
        this.preColorItem = preColorItem;
    }

    public void setPreSizeItem(SpecItemBean preSizeItem) {
        this.preSizeItem = preSizeItem;
    }

    public void setImg_url(String img_url) {
        this.img_url = img_url;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        View view = getLayoutInflater().inflate(R.layout.dialog_reex_items_spec_select, null);
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

        ivItem = (ImageView) view.findViewById(R.id.iv_item);
        tvAmout = (TextView) view.findViewById(R.id.tv_amout);
        tvItemSelSpec = (TextView) view.findViewById(R.id.tv_item_sel_spec);

        fl_spec = (FlowLayout) view.findViewById(R.id.fl_spec);
        flSize = (FlowLayout) view.findViewById(R.id.fl_size);
        flColor = (FlowLayout) view.findViewById(R.id.fl_color);

        ll_spec = (ViewGroup) view.findViewById(R.id.ll_spec);
        ll_spec_size = (ViewGroup) view.findViewById(R.id.ll_spec_size);
        ll_spec_color = (ViewGroup) view.findViewById(R.id.ll_spec_color);

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
        LoaderFactory.getLoader().loadNet(ivItem, img_url, null);
        tvItemSelSpec.setText("已选" + spec);
        tvAmout.setText(money);

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

                    if (mTagsColorList.size() > 0) {
                        if (getSelectItem(mTagsColorList) == null) {
                            ToastUtils.showShortToast("请选择颜色");
                            return;
                        }
                        unitCode = getSelectItem(mTagsColorList).getCs_code();
                        content = getSelectItem(mTagsColorList).getCs_name();
                    }

                    if (mTagSizeList.size() > 0) {
                        if (getSelectItem(mTagSizeList) == null) {
                            ToastUtils.showShortToast("请选择尺寸");
                            return;
                        }
                        if (!TextUtils.isEmpty(unitCode)) {
                            unitCode += ":" + getSelectItem(mTagSizeList).getCs_code();
                            content += "/" + getSelectItem(mTagSizeList).getCs_name();
                        }

                    }

                    if (mTagsSpecList.size() > 0) {
                        if (getSelectItem(mTagsSpecList) == null) {
                            ToastUtils.showShortToast("请选择规格");
                            return;
                        }
                        unitCode = getSelectItem(mTagsSpecList).getCs_code();
                        content = getSelectItem(mTagsSpecList).getCs_name();
                    }

                    if (TextUtils.isEmpty(unitCode)) {
                        unitCode = "001";
                    }
                    itemSelectListener.select(getSelectItem(mTagSizeList)
                            , getSelectItem(mTagsColorList)
                            , getSelectItem(mTagsSpecList));
                    itemSelectListener.selectItem(unitCode, content);
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
            values = size;
        }
        if (!TextUtils.isEmpty(color)) {
            values += "/" + color;
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
        void select(SpecItemBean size, SpecItemBean color, SpecItemBean spec);

        void selectItem(String unitCode, String content);
    }
}
