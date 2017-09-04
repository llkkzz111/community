package com.ocj.oms.mobile.ui.adapter;

/**
 * Created by yy on 2017/5/10.
 */

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.ocj.oms.mobile.view.BaseHolder;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yy on 2017/5/10.
 */

public abstract class CommonAdapter<E, T extends BaseHolder> extends BaseAdapter {

    public List<E> mDatas;

    public Context mContext;

    public CommonAdapter(Context context) {
        super();
        this.mContext = context;
        this.mDatas = new ArrayList<E>();
    }

    @Override
    public int getCount() {
        if (mDatas == null) {
            return 0;
        } else
            return mDatas.size();
    }

    public E getItem(int position) {
        return mDatas.get(position);
    }

    @Override
    public long getItemId(int arg0) {
        return arg0;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        T holder = null;
        E item = this.getItem(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext()).inflate(getLayoutResId(), parent, false);
            holder = bindHoler(convertView);
            convertView.setTag(holder);
        } else {
            holder = (T) convertView.getTag();
        }
        bindData(holder, position, item);
        return convertView;
    }

    public abstract T bindHoler(View view);

    public abstract int getLayoutResId();

    public abstract void bindData(T holder, int position, E item);

    public List<E> getData() {
        return this.mDatas;
    }


    public void setData(List<E> data) {
        if (data != null) {
            this.mDatas = data;
        }
        this.notifyDataSetChanged();
    }

    public void clear() {
        this.mDatas.clear();
        this.notifyDataSetChanged();
    }


}