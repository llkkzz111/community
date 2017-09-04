package com.ocj.oms.basekit.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuzhao on 2017/4/6.
 */

public abstract class BaseAdapter<T> extends android.widget.BaseAdapter {
    public List<T> data;
    public Context activity;



    public BaseAdapter(Activity activity) {
        this.activity = activity;
    }

    public BaseAdapter(Activity activity, ArrayList<T> data) {
        this.activity = activity;
        this.data = data;
    }

    public void setData(List<T> data) {
        this.data = data;
    }

    public List<T> getData() {
        return data;
    }

    @Override
    public int getCount() {
        return null != data ? data.size() : 0;
    }

    public T getItem(int position) {
        return data.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return view(position, convertView, parent);
    }

    public abstract View view(int position, View convertView, ViewGroup parent);
}
