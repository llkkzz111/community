package com.ocj.oms.mobile.ui.selecter;

import android.content.Context;
import android.widget.AbsListView;

import com.ocj.oms.utils.DensityUtil;


/**
 * 相册选择页item
 */
public class GalleryPhotoItem extends PhotoItem {

    /**
     * 相册中每行item数量
     */
    private static final int HORIZENTAL_NUM = 3;

    public GalleryPhotoItem(Context context, onPhotoItemCheckedListener listener) {
        super(context, listener);

        int horizentalSpace = DensityUtil.dip2px(context, 2);

        int itemWidth = (DensityUtil.getScreenWidth(context) - (horizentalSpace * (HORIZENTAL_NUM - 1)))
                / HORIZENTAL_NUM;
        AbsListView.LayoutParams itemLayoutParams = new AbsListView.LayoutParams(itemWidth, itemWidth);
        setLayoutParams(itemLayoutParams);
    }
}
