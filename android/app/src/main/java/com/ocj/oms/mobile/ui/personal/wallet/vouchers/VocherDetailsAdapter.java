package com.ocj.oms.mobile.ui.personal.wallet.vouchers;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.VocherBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yy on 2017/5/20.
 */

public class VocherDetailsAdapter extends RecyclerView.Adapter {

    Context mContext;
    List<VocherBean> datas = new ArrayList<>();

    OnUseVocherListener listner;

    public VocherDetailsAdapter(Context context) {
        this.mContext = context;
    }

    public VocherDetailsAdapter(Context context, List<VocherBean> list) {
        this.mContext = context;
        this.datas = list;
    }


    public void setListner(OnUseVocherListener mlistner) {
        this.listner = mlistner;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        VocherHolder holder = new VocherHolder(LayoutInflater.from(
                mContext).inflate(R.layout.item_holder_vocher_layout, parent,
                false));
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        VocherHolder mHolder = (VocherHolder) holder;
        final VocherBean bean = datas.get(position);//COUPON_AMT
        if (TextUtils.equals(bean.getDc_gb(), "10")) {
            mHolder.dicountRate.setText(bean.getCoupon_amt() + "");
            mHolder.tvPricePre.setVisibility(View.VISIBLE);
        } else {
            mHolder.tvPricePre.setVisibility(View.GONE);
            mHolder.dicountRate.setText(bean.getCoupon_amt() + "");
        }
        mHolder.vocherHead.setText(bean.getDccoupon_name());
        mHolder.vocherCotent.setText(bean.getCoupon_note());
        mHolder.vocherValidTime.setText("有效期至" + bean.getExp_dc_edate());
    }

    @Override
    public int getItemCount() {
        return datas.size();
    }


    class VocherHolder extends RecyclerView.ViewHolder {
        TextView dicountRate;
        TextView vocherHead;
        TextView vocherCotent;
        TextView vocherValidTime;
        TextView tvPricePre;

        public VocherHolder(View view) {
            super(view);
            dicountRate = (TextView) view.findViewById(R.id.tv_discount_rate);
            vocherHead = (TextView) view.findViewById(R.id.tv_vocher_name);
            vocherCotent = (TextView) view.findViewById(R.id.tv_content);
            vocherValidTime = (TextView) view.findViewById(R.id.tv_vocher_valid_time);
            tvPricePre = (TextView) view.findViewById(R.id.tv_price_pre);
        }
    }

    public interface OnUseVocherListener {
        void onVocherUse(VocherBean bean);
    }
}
