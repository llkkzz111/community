package com.choudao.equity.selector;

import android.content.Context;
import android.widget.AbsListView;

import com.choudao.equity.R;
import com.choudao.equity.utils.ConstantUtils;


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

        int horizentalSpace = context.getResources().getDimensionPixelSize(
                R.dimen.sticky_item_horizontalSpacing
        );
        int itemWidth = (ConstantUtils.SCREEN_WIDTH - (horizentalSpace * (HORIZENTAL_NUM - 1)))
                / HORIZENTAL_NUM;
        AbsListView.LayoutParams itemLayoutParams = new AbsListView.LayoutParams(itemWidth, itemWidth);
        setLayoutParams(itemLayoutParams);
    }
}
