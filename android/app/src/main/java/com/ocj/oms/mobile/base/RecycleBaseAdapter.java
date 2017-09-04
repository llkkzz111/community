package com.ocj.oms.mobile.base;

import android.support.annotation.Nullable;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yy on 2017/5/22.
 */

public abstract class RecycleBaseAdapter<T> extends RecyclerView.Adapter<BaseViewHolder> {

    protected List<T> mData = new ArrayList<>();

    View item;

    public RecycleBaseAdapter(List<T> data) {
        this.mData = data;
    }

    protected RecycleBaseAdapter() {
    }

    @Override
    public BaseViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        item = LayoutInflater.from(parent.getContext()).inflate(viewType, parent, false);
        BaseViewHolder holder = getHolder(item, parent, viewType);
        return holder;
    }

    public abstract BaseViewHolder getHolder(View item, ViewGroup parent, int viewType);


    @Override
    public void onBindViewHolder(BaseViewHolder holder, int position) {
        T data = mData.get(position);
        int viewType = getLayoutRes(position);
        convert(holder, data, position, viewType);
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    /**
     * 返回布局layout
     *
     * @param position 列表位置
     * @return 布局Layout ID
     */
    public abstract int getLayoutRes(int position);


    /**
     * 在这里设置显示
     *
     * @param holder 默认的ViewHolder
     * @param data   对应的数据
     * @param index  对应的列表位置（不一定是数据在数据集合List中的位置）
     */
    public abstract void convert(BaseViewHolder holder, T data, int index, int type);


    @Override
    public int getItemViewType(int position) {
        return getLayoutRes(position);
    }


    /**
     * 设置新数据，会清除掉原有数据，并有可能重置加载更多状态
     *
     * @param data 数据集合
     */
    public void setData(@Nullable List<? extends T> data) {
        mData.clear();
        if (data != null) {
            mData.addAll(data);
            notifyDataSetChanged();
        }
    }


}
