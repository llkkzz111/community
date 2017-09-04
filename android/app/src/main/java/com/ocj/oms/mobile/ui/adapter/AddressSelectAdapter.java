package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by MJJ on 2015/7/25.
 */
public class AddressSelectAdapter extends RecyclerView.Adapter<AddressSelectAdapter.ItemViewHolder> {
    private OnItemClickListener listener;
    private Context mContext;
    private List<ReceiversBean> mDatas = new ArrayList<>();

    public AddressSelectAdapter(Context context, OnItemClickListener listener) {
        mContext = context;
        this.listener = listener;
    }

    public void setDatas(List<ReceiversBean> data) {
        this.mDatas = data;
        notifyDataSetChanged();
    }


    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    @Override
    public void onBindViewHolder(final ItemViewHolder holder, final int position) {
        final ReceiversBean bean = mDatas.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public ItemViewHolder onCreateViewHolder(ViewGroup arg0, int arg1) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_address_select_layout, arg0, false);
        ItemViewHolder holder = new ItemViewHolder(view);
        return holder;
    }


    class ItemViewHolder extends BaseViewHolder<ReceiversBean> {

        @BindView(R.id.tv_name) TextView tvName;
        @BindView(R.id.tv_mobile) TextView tvMobile;
        @BindView(R.id.tv_defalt) TextView tvDefault;
        @BindView(R.id.tv_address) TextView tvAdress;
        private ReceiversBean bean;

        public ItemViewHolder(View view) {
            super(view);
        }

        @Override
        public void onBind(int position, ReceiversBean bean) {
            this.bean = bean;
            tvName.setText(bean.getReceiver_name());
            tvMobile.setText(bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3());
            tvAdress.setText(bean.getAddr_m() + bean.getReceiver_addr());
            tvDefault.setVisibility(bean.getDefault_yn().equals("1") ? View.VISIBLE : View.GONE);

        }
        @OnClick(R.id.ll_address_items)
        void onClick(){
            listener.onItemClick(bean);
        }

    }

    public interface OnItemClickListener {
        void onItemClick(ReceiversBean bean);
    }

}

