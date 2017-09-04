package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.EventResultsItem;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by pactera on 2017/4/21.
 */

public class CutEventAdapter extends RecyclerView.Adapter {
    private List<EventResultsItem> mDatas = new ArrayList<>();
    Context mContext;
    OnItemClickListener listener;

    public CutEventAdapter(Context context, List<EventResultsItem> data) {
        this.mDatas = data;
        this.mContext = context;
    }

    @Override
    public TextViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        TextViewHolder holder = new TextViewHolder(LayoutInflater.from(mContext).inflate(R.layout.item_cut_event, parent, false));
        return holder;
    }

    public void setListener(OnItemClickListener listener) {
        this.listener = listener;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int position) {
        final EventResultsItem item = mDatas.get(position);
        TextViewHolder mholder = (TextViewHolder) holder;
        mholder.tvTitle.setText(item.eventName);
        if(TextUtils.isEmpty(item.prizeName)){
            mholder.tvPrizeName.setVisibility(View.GONE);
        }else{
            mholder.tvPrizeName.setVisibility(View.VISIBLE);
            mholder.tvPrizeName.setText(item.prizeName);
        }

        if(TextUtils.equals(item.mark,"1")){
            mholder.btnText.setText("查看活动详情");
        }else{
            mholder.btnText.setText("点击选礼");
        }

        if (position == 0) {
            mholder.viewDividerTop.setVisibility(View.VISIBLE);
        } else {
            mholder.viewDividerTop.setVisibility(View.GONE);
        }
        mholder.btnText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.click(position, item.murl);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }


    class TextViewHolder extends RecyclerView.ViewHolder {
        TextView tvTitle;
        TextView tvPrizeName;
        TextView btnText;
        View viewDividerTop;

        public TextViewHolder(View view) {
            super(view);
            tvTitle = (TextView) view.findViewById(R.id.tv_title);
            tvPrizeName = (TextView) view.findViewById(R.id.tv_prize);
            btnText = (TextView) view.findViewById(R.id.tv_btn);
            viewDividerTop = view.findViewById(R.id.view_divider_top);
        }
    }

    public interface OnItemClickListener {
        void click(int position, String url);
    }


}
