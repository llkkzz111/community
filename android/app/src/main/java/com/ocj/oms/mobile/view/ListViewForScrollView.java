package com.ocj.oms.mobile.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/11 15:06
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:scrollview 内部嵌套的listview
 */

public class ListViewForScrollView extends ListView{
    public ListViewForScrollView(Context context) {
        super(context);
    }
    public ListViewForScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }
    public ListViewForScrollView(Context context, AttributeSet attrs,
                                 int defStyle) {
        super(context, attrs, defStyle);
    }
    @Override
    /**
     * 重写该方法，达到使ListView适应ScrollView的效果
     */
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
                MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
    }
}
