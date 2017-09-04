package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.AreaBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by pactera on 2017/4/21.
 */

public class AreaSlectAdapter extends RecyclerView.Adapter {
    private List<AreaBean> mDatas = new ArrayList<AreaBean>();
    Context mContext;
    private OnAreaSlectListner mListner;

    public AreaSlectAdapter(List<AreaBean> data, Context context) {
        this.mDatas = data;
        this.mContext = context;
    }

    public AreaSlectAdapter(Context context) {
        this.mContext = context;
    }

    public void setmDatas(List<AreaBean> datas) {
        this.mDatas = datas;
        this.notifyDataSetChanged();
    }


    @Override
    public TextViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        TextViewHolder holder = new TextViewHolder(LayoutInflater.from(
                mContext).inflate(R.layout.item_recycle_areaselcter, parent,
                false));
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        TextViewHolder mholder = (TextViewHolder) holder;
        mholder.tv.setText(mDatas.get(position).getSelectName());
        //mholder.tv.setTag(mDatas.get(position));
        mholder.tv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mListner != null) {
                    mListner.onItemClick(mDatas.get(position));
                }

            }
        });


    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }


    class TextViewHolder extends RecyclerView.ViewHolder {
        TextView tv;
        AreaBean bean = null;

        public TextViewHolder(View view) {
            super(view);
            tv = (TextView) view.findViewById(R.id.tv_content);
        }
    }


    public void setSlectListner(OnAreaSlectListner listner) {
        this.mListner = listner;
    }

    public interface OnAreaSlectListner {
        void onItemClick(AreaBean bean);

    }


}
