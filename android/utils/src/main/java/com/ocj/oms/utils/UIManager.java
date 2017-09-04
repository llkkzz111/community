package com.ocj.oms.utils;

import android.content.Context;


/**
 * Created by liuz on 2016/3/11.
 */
public class UIManager {
    private static UIManager INSTANCE;
    private Context mBaseContext;
    private int mHeight;
    private int mWidth;
    private int mDensity;

    private UIManager() {

    }

    public synchronized static UIManager getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new UIManager();
        }
        return INSTANCE;
    }

    public Context getBaseContext() {
        return mBaseContext;
    }

    public void setBaseContext(Context context) {
        mBaseContext = context;
    }

    /**
     * 获取手机高
     *
     * @return
     */
    public int getHeight() {
        return mHeight;
    }

    /**
     * 保存手机高
     *
     * @param height
     */
    public void setHeight(int height) {
        this.mHeight = height;
    }

    /**
     * 获取手机宽
     *
     * @return
     */
    public int getWidth() {
        return mWidth;
    }

    /**
     * 保存手机宽
     *
     * @param width
     */
    public void setWidth(int width) {
        this.mWidth = width;
    }

    /**
     * 获取手机密度
     *
     * @return
     */
    public int getDensity() {
        return mDensity;
    }

    /**
     * 保存手机密度
     *
     * @param density
     */
    public void setDensity(int density) {
        this.mDensity = density;
    }

    /**
     * 清空 INSTANCE
     */
    public void close() {
        setHeight(0);
        setWidth(0);
        setDensity(0);
    }
}
