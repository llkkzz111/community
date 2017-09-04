package com.ocj.oms.mobile.ui.personal.order;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;

import java.util.ArrayList;


/**
 * Created by xiaozongkang111 on 2016-08-01.
 */
public abstract class ImageAdapter extends BaseAdapter {

    private GridView mGridView;
    private Context mContext;
    private ArrayList<String> mList;
    private int max_num = 9;//默认
    private int columns = 3;//默认

    private OnDeleteClickListener onDeleteClickListener;

    public void setOnDeleteClickListener(OnDeleteClickListener onDeleteClickListener) {
        this.onDeleteClickListener = onDeleteClickListener;
    }

    @Override
    public int getCount() {
        return (mList == null ? 0 : mList.size()) + (mList.size() < max_num ? 1 : 0);
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    public ImageAdapter(Context mContext, ArrayList<String> list, GridView mGridView) {
        this.mContext = mContext;
        this.mList = list;
        this.mGridView = mGridView;
    }

    public ImageAdapter(Context mContext, ArrayList<String> list, GridView mGridView, int max_num, int columns) {
        this.mContext = mContext;
        this.mList = list;
        this.mGridView = mGridView;
        this.max_num = max_num;
        this.columns = columns;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int horizontalSpacing = mGridView.getHorizontalSpacing();
        int width = (mGridView.getWidth() - (columns - 1) * horizontalSpacing - mGridView.getPaddingLeft() - mGridView.getPaddingRight()) / columns;
        ViewHolder holder = null;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.item_return_exchange_img, null);
            holder.icon_delete = convertView.findViewById(R.id.icon_delete);
            holder.iv = (ImageView) convertView.findViewById(R.id.iv);
            holder.layout_pic = convertView.findViewById(R.id.layout_pic);
            convertView.setTag(holder);
            AbsListView.LayoutParams params = new AbsListView.LayoutParams(width, width);
            convertView.setLayoutParams(params);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.icon_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onDeleteClickListener != null) {
                    onDeleteClickListener.delete(position);
                }
            }
        });


        if (position < getCount() - 1 || position == mList.size() - 1) {
            String url = mList.get(position);
            if (null != url) {
                LoaderFactory.getLoader().loadNet(holder.iv,url);
            }

            holder.icon_delete.setVisibility(View.VISIBLE);
            holder.layout_pic.setVisibility(View.GONE);
            holder.iv.setVisibility(View.VISIBLE);
        } else {
            holder.icon_delete.setVisibility(View.GONE);
            holder.layout_pic.setVisibility(View.VISIBLE);
            holder.iv.setVisibility(View.INVISIBLE);
        }
        return convertView;
    }

    @Override
    public void notifyDataSetChanged() {
        super.notifyDataSetChanged();
        updateView();
    }

    protected abstract void updateView();

    public class ViewHolder {
        public View icon_delete;
        public View layout_pic;
        public ImageView iv;

    }

    public interface OnDeleteClickListener {
        void delete(int position);
    }

}
