package com.ocj.oms.mobile.ui.adapter.holder;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.android.arouter.launcher.ARouter;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.view.FixGridLayout;
import com.ocj.oms.mobile.view.LinearLineWrapLayout;
import com.ocj.oms.utils.UIManager;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;

import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_VIDEO;

/**
 * Created by liu on 2017/5/23.
 */
public class VideoGridHolder extends BaseViewHolder<CmsItemsBean> {

    @BindView(R.id.iv_video) ImageView vedio;
    @BindView(R.id.tv_content_title) TextView title;
    @BindView(R.id.fix_gridlayout) FixGridLayout label;
    @BindView(R.id.ll_item_grid) View item;

    private Context mContext;

    public VideoGridHolder(View itemView) {
        super(itemView);
        mContext = itemView.getContext();
    }

    @Override
    public void onBind(int position, final CmsItemsBean bean) {
        title.setText(bean.getTitle());

        if (bean.getLabelName() != null && bean.getLabelName().size() > 0) {
            for (String lable : bean.getLabelName()) {
                addItemView(label, lable);
            }
        }
        LoaderFactory.getLoader().loadNet(vedio, bean.getFirstImgUrl());

        item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, Object> params1 = new HashMap<>();
                OcjStoreDataAnalytics.trackEvent(mContext, bean.getCodeValue(), bean.getTitle(), params1);
                ARouter.getInstance().build(AROUTER_PATH_VIDEO)
                        .withString("from", "RNActivity")
                        .withString("id", bean.getContentCode())
                        .navigation();
            }
        });
    }

    private void addItemView(LinearLineWrapLayout viewGroup, String text) {
        final View v = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.textview_layout, null);
        TextView tvItem = (TextView) v.findViewById(R.id.textview);
        tvItem.setTextColor(Color.parseColor("#999999"));
        tvItem.setText(text);
        viewGroup.addView(v);
    }
}
