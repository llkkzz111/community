package com.ocj.oms.mobile.view;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.ocj.oms.mobile.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/26.
 */

public class ShoppingRuleLayout extends LinearLayout {

    private Context mContext;
    private OnCloseClickListener onCloseClickListener;

    public ShoppingRuleLayout(Context context) {
        super(context);
        mContext = context;
        init(mContext);
    }

    public void setOnCloseClickListener(OnCloseClickListener onCloseClickListener) {
        this.onCloseClickListener = onCloseClickListener;
    }

    private void init(Context context) {
        LayoutInflater inflater = LayoutInflater.from(context);
        View view = inflater.inflate(R.layout.popupwindow_shopping_rule_layout, null);
        ButterKnife.bind(this, view);
        this.addView(view);
    }

    @OnClick({R.id.iv_close, R.id.tv_confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
                if (onCloseClickListener != null) {
                    onCloseClickListener.onCloseClick();
                }
                break;
            case R.id.tv_confirm:
                if (onCloseClickListener != null) {
                    onCloseClickListener.onCloseClick();
                }
                break;
        }
    }

    public interface OnCloseClickListener {
        void onCloseClick();
    }
}
