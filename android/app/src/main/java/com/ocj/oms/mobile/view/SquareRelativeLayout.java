package com.ocj.oms.mobile.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

import com.ocj.oms.mobile.R;

/**
 * Created by liu on 2017/6/22.
 */

public class SquareRelativeLayout extends RelativeLayout {

    private int width_percent;
    private int height_percent;

    public SquareRelativeLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        //获取比例值
        TypedArray a = context.obtainStyledAttributes(attrs,
                R.styleable.SquareRelativeLayout);
        width_percent = a.getInt(R.styleable.SquareRelativeLayout_width_percent, 1);
        height_percent = a.getInt(R.styleable.SquareRelativeLayout_height_percent, 1);
        a.recycle();
    }

    public SquareRelativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        //获取比例值
        TypedArray a = context.obtainStyledAttributes(attrs,
                R.styleable.SquareRelativeLayout);
        width_percent = a.getInt(R.styleable.SquareRelativeLayout_width_percent, 0);
        height_percent = a.getInt(R.styleable.SquareRelativeLayout_height_percent, 0);
        a.recycle();
    }

    public SquareRelativeLayout(Context context) {
        super(context);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
//        setMeasuredDimension(getDefaultSize(0, widthMeasureSpec), getDefaultSize(0, heightMeasureSpec));
//
//        int childWidthSize = getMeasuredWidth();
//
//        widthMeasureSpec = MeasureSpec.makeMeasureSpec(childWidthSize, MeasureSpec.EXACTLY);
//        heightMeasureSpec = MeasureSpec.makeMeasureSpec(childWidthSize * height_percent / width_percent, MeasureSpec.EXACTLY);
//
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        //获取宽度的模式和尺寸
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
        int widthMode = MeasureSpec.getMode(widthMeasureSpec);
        //获取高度的模式和尺寸
        int heightSize = MeasureSpec.getSize(heightMeasureSpec);
        int heightMode = MeasureSpec.getMode(heightMeasureSpec);
        //宽确定，高不确定
        if (widthMode == MeasureSpec.EXACTLY && width_percent * height_percent != 0) {
            heightSize = widthSize * height_percent / width_percent;//根据宽度和比例计算高度
            heightMeasureSpec = MeasureSpec.makeMeasureSpec(heightSize, MeasureSpec.EXACTLY);
        } else if (heightMode == MeasureSpec.EXACTLY & width_percent * height_percent != 0) {
            widthSize = heightSize * width_percent / height_percent;
            widthMeasureSpec = MeasureSpec.makeMeasureSpec(widthSize, MeasureSpec.EXACTLY);
        }else{
            setMeasuredDimension(getDefaultSize(0, widthMeasureSpec),
                    getDefaultSize(0, heightMeasureSpec));
            int childWidthSize = getMeasuredWidth();
            // 高度和宽度一样
            heightMeasureSpec = widthMeasureSpec = MeasureSpec.makeMeasureSpec(
                    childWidthSize, MeasureSpec.EXACTLY);
        }
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }
}
