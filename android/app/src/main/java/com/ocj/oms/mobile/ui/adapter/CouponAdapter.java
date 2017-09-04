package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.CouponListBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/21.
 */

public class CouponAdapter extends RecyclerView.Adapter<CouponAdapter.MyViewHolder> {

    private List<CouponListBean> data;
    private Context context;
    private List<Boolean> flag;
    private OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public CouponAdapter(Context context, List<CouponListBean> data) {
        CouponListBean bean = new CouponListBean();
        if (data != null) {
            data.add(bean);
            this.data = data;
            flag = new ArrayList<>();
            for (CouponListBean temp : data) {
                flag.add(false);
            }
        }
        this.context = context;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_coupon_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.onBind(position, data.get(position));
    }

    @Override
    public int getItemCount() {
        return data != null ? data.size() : 0;
    }

    public void resetFlag(int position) {
        if (flag.get(position)) {
            flag.set(position, false);
        } else {
            for (int i = 0; i < flag.size(); i++) {
                flag.set(i, false);
            }
            flag.set(position, true);
        }
        notifyDataSetChanged();
    }

    public CouponListBean getCurrentSelect() {
        if (data == null) {
            return null;
        }
        for (int i = 0; i < flag.size(); i++) {
            if (flag.get(i)) {
                return data.get(i);
            }
        }
        return null;
    }


    class MyViewHolder extends BaseViewHolder<CouponListBean> {

        @BindView(R.id.tv_discount_rate) TextView tvDiscountRate;
        @BindView(R.id.tv_accept_vocher) TextView tvAcceptVocher;
        @BindView(R.id.tv_vocher_name) TextView tvVocherName;
        @BindView(R.id.tv_content) TextView tvContent;
        @BindView(R.id.tv_vocher_valid_time) TextView tvVocherValidTime;
        @BindView(R.id.iv_select) ImageView ivSelect;
        @BindView(R.id.ll_coupon) LinearLayout llCoupon;
        @BindView(R.id.iv_select2) ImageView ivSelect2;
        @BindView(R.id.ll_no_coupon) LinearLayout llNoCoupon;

        public MyViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(final int position, CouponListBean bean) {
            if (position < data.size() - 1) {
                llNoCoupon.setVisibility(View.GONE);
                llCoupon.setVisibility(View.VISIBLE);
                if (flag.get(position)) {
                    ivSelect.setImageResource(R.drawable.icon_checkbox_checked_bg);
                } else {
                    ivSelect.setImageResource(R.drawable.icon_checkbox_normal_bg);
                }
                llCoupon.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (onItemClickListener != null) {
                            onItemClickListener.onItemClick(position);
                        }
                    }
                });
                tvVocherName.setText(bean.getCoupon_note());
                tvVocherValidTime.setText(String.format("有效期至%s", bean.getDc_endDate()));
                if (TextUtils.equals(bean.getDc_gb(),"10")) {
                    tvDiscountRate.setText(String.format("￥%s", bean.getReal_coupon_amt()));
                } else {
                    tvDiscountRate.setText(String.format("%s折", bean.getReal_coupon_amt()));
                }
            } else {
                llNoCoupon.setVisibility(View.VISIBLE);
                llCoupon.setVisibility(View.GONE);
                if (flag.get(position)) {
                    ivSelect2.setImageResource(R.drawable.icon_checkbox_checked_bg);
                } else {
                    ivSelect2.setImageResource(R.drawable.icon_checkbox_normal_bg);
                }
                llNoCoupon.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (onItemClickListener != null) {
                            onItemClickListener.onItemClick(position);
                        }
                    }
                });
            }
        }
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
