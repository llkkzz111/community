package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.OcustBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/12.
 */

public class SignPacksAdapter extends RecyclerView.Adapter<SignPacksAdapter.MyViewHolder> {

    private List<OcustBean> data;
    private Context context;

    public SignPacksAdapter(Context context, List<OcustBean> data) {
        this.context = context;
        this.data = data;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_sign_packs_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.onBind(position, data.get(position));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    class MyViewHolder extends BaseViewHolder<OcustBean> {

        @BindView(R.id.tv_name) TextView tvName;
        @BindView(R.id.tv_status) TextView tvStatus;
        @BindView(R.id.tv_date) TextView tvDate;

        public MyViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, OcustBean bean) {
            if (!TextUtils.isEmpty(bean.getCoupon_note())) {
                tvName.setText(bean.getCoupon_note());
            }
            String time;
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy.MM.dd");
            Date date = new Date(bean.getInsert_dat());
            time = simpleDateFormat.format(date);
            tvDate.setText(time);
            if (!TextUtils.isEmpty(bean.getUse_yn())) {
                switch (bean.getUse_yn()) {
                    case "0":
                        tvStatus.setText("未使用");
                        tvStatus.setTextColor(context.getResources().getColor(R.color.text_red_E5290D));
                        break;
                }
            }
        }
    }
}
