package com.community.equity.adapter;

import android.view.View;

/**
 * Created by dufeng on 16/9/2.<br/>
 * Description: OnRecyclerViewListener
 */
public interface OnRecyclerViewListener {

    void onItemClick(int position, View view);

    boolean onItemLongClick(int position, View view);
}
