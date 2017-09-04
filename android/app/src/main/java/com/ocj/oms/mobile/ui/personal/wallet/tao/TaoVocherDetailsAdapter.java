package com.ocj.oms.mobile.ui.personal.wallet.tao;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.TaoVocherBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/20.
 */

public class TaoVocherDetailsAdapter extends RecyclerView.Adapter<TaoVocherDetailsAdapter.VocherHolder> {

    Context mContext;
    List<TaoVocherBean> datas = new ArrayList<>();

    OnObtainVocherListener listner;

    public TaoVocherDetailsAdapter(Context context, List<TaoVocherBean> list) {
        this.mContext = context;
        this.datas = list;
    }

    public void setListner(OnObtainVocherListener mlistner) {
        this.listner = mlistner;
    }


    @Override
    public VocherHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_holder_vocher_layout, parent, false);
        VocherHolder holder = new VocherHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(VocherHolder holder, int position) {
        final TaoVocherBean bean = datas.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public int getItemCount() {
        return datas.size();
    }


    class VocherHolder extends BaseViewHolder<TaoVocherBean> {
        @BindView(R.id.tv_discount_rate) TextView dicountRate;
        @BindView(R.id.tv_accept_vocher) TextView btnAccept;
        @BindView(R.id.tv_vocher_name) TextView vocherHead;
        @BindView(R.id.tv_content) TextView vocherCotent;
        @BindView(R.id.tv_vocher_valid_time) TextView vocherValidTime;
        @BindView(R.id.tv_price_pre) TextView tvPricePre;
        @BindView(R.id.iv_coupon) ImageView ivCoupon;

        TaoVocherBean bean;

        public VocherHolder(View view) {
            super(view);
        }

        @Override
        public void onBind(int position, final TaoVocherBean bean) {
            this.bean = bean;
            tvPricePre.setVisibility(View.VISIBLE);
            dicountRate.setText(bean.getDCAMT() + "");
            btnAccept.setVisibility(View.VISIBLE);
            btnAccept.setText("立即领取");
            vocherHead.setText(bean.getDCCOUPONNAME());
            vocherCotent.setText(bean.getDCCOUPONCONTENT());
            vocherValidTime.setText(bean.getDCEDATE());
            ivCoupon.setVisibility(View.GONE);
        }

        @OnClick(R.id.tv_accept_vocher)
        void onClick(View v) {
            listner.onVocherObtain(bean);
        }
    }

    public interface OnObtainVocherListener {
        void onVocherObtain(TaoVocherBean bean);
    }
}
