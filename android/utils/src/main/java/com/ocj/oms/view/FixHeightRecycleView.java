package com.ocj.oms.view;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;

/**
 * 固定高度的RecycleView
 * Created by liuqiang
 */
public class FixHeightRecycleView extends RecyclerView {
    public FixHeightRecycleView(Context context) {
        super(context);
    }

    public FixHeightRecycleView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public FixHeightRecycleView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {

        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
    }
}
