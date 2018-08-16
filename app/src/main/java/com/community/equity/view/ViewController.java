package com.community.equity.view;

import android.view.View;

public interface ViewController {
    /**
     * 显示加载框
     */
    void showLoadView();


    /**
     * 显示内容
     */
    void showContentView();


    /**
     * 显示空数据提示
     */
    View showEmptyView(String msg);

    /**
     * 显示异常提示
     */
    View showErrorView(String msg);


}
