package com.ocj.oms.mobile.ui.personal.order;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.ReasonBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import butterknife.BindView;

/**
 * Created by liu on 2017/6/7.
 */

public class ReasonAdapter extends RecycleBaseAdapter<ReasonBean> {

    OnItemClickListener onItemClickListener;

    public ReasonAdapter() {
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new ReasonViewHolder(LayoutInflater.from(parent.getContext()).inflate(viewType, parent, false));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_exchange_reason_layout;
    }

    @Override
    public void convert(final BaseViewHolder holder, ReasonBean data, final int index, int type) {
        holder.onBind(index, data);
        if (onItemClickListener != null) {
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int position = holder.getLayoutPosition();
                    onItemClickListener.onItemClick(position);
                }
            });
        }
    }


    public class ReasonViewHolder extends BaseViewHolder<ReasonBean> {

        @BindView(R.id.tv_content) TextView tv_content;
        @BindView(R.id.cb_content) CheckBox cb_content;
        @BindView(R.id.ll_bottom_divider) View ll_bottom_divider;
        ReasonBean bean;

        public ReasonViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, ReasonBean bean) {
            this.bean = bean;
            tv_content.setText(bean.getREASON());
            cb_content.setChecked(bean.isChecked());
            ll_bottom_divider.setVisibility(position == mData.size() - 1 ? View.GONE : View.VISIBLE);

        }
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
