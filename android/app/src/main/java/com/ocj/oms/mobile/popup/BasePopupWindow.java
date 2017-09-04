package com.ocj.oms.mobile.popup;

import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.PopupWindow;

/**
 * Created by liuzhao on 16/7/22.
 */

public abstract class BasePopupWindow {

    public int id;
    public boolean isCurrent = false;
    public Context mContext;

    public PopupWindow mPopupWindow;

    public BasePopupWindow(Context mContext) {
        this.mContext = mContext;
        makePopupWindow(getPopupWindow());
    }

    public BasePopupWindow(Context mContext, int id) {
        this.id = id;
        this.mContext = mContext;
        makePopupWindow(getPopupWindow());
    }

    public BasePopupWindow(Context mContext, int id, boolean isCurrent) {
        this.id = id;
        this.mContext = mContext;
        this.isCurrent = isCurrent;
        makePopupWindow(getPopupWindow());
    }

    private PopupWindow makePopupWindow(View v) {
        mPopupWindow = new PopupWindow(v, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT, false);
        mPopupWindow.setOutsideTouchable(true);
        mPopupWindow.setFocusable(true);
        mPopupWindow.setBackgroundDrawable(new BitmapDrawable());
        return mPopupWindow;
    }


    public void popShow(View v) {
        if (mPopupWindow != null && !mPopupWindow.isShowing()) {
            mPopupWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
            mPopupWindow.showAtLocation(v, Gravity.NO_GRAVITY, 0, 0);
        }
    }

    public abstract View getPopupWindow();
}
