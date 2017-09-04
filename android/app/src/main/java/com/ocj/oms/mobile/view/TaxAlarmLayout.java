package com.ocj.oms.mobile.view;

import android.content.Context;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.ocj.oms.mobile.R;

/**
 * Created by yy on 2017/5/10.
 * 跟税务说明相关的浮层
 */

public class TaxAlarmLayout extends LinearLayout {
    private Context mContext;


    public TaxAlarmLayout(Context context, String content) {
        super(context);
        this.mContext = context;
        init(mContext, content);
    }

    public TaxAlarmLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        this.mContext = context;

    }


    private void init(Context mContext, String content) {
        //TODO 税务说明是否可以写死？
        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.popupwindow_tax_alarm_layout, null);
        this.addView(view);
    }


}
