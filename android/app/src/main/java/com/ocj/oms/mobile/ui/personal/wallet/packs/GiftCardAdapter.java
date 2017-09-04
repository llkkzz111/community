package com.ocj.oms.mobile.ui.personal.wallet.packs;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.GiftCardBean;

import java.util.List;

/**
 * Created by yy on 2017/5/20.
 */

public class GiftCardAdapter extends RecyclerView.Adapter {

    Context mContext;
    List<GiftCardBean> datas = null;

    public GiftCardAdapter(Context context) {
        this.mContext = context;
    }

    public GiftCardAdapter(Context context, List<GiftCardBean> list) {
        this.mContext = context;
        this.datas = list;
    }


    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        GiftCardHolder holder = new GiftCardHolder(LayoutInflater.from(
                mContext).inflate(R.layout.item_giftcard, parent,
                false));
        return holder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        GiftCardHolder mHolder = (GiftCardHolder) holder;
        GiftCardBean bean = datas.get(position);
        mHolder.giftName.setText(bean.getDEPOSIT_NOTE_APP());
        mHolder.time.setText(bean.getPROC_DATE());
        mHolder.score.setText(bean.getUSE_AMT_APP());
    }

    @Override
    public int getItemCount() {
        return datas.size();
    }


    class GiftCardHolder extends RecyclerView.ViewHolder {
        TextView giftName;
        TextView time;
        TextView score;

        public GiftCardHolder(View view) {
            super(view);
            giftName = (TextView) view.findViewById(R.id.tv_gitftitle);
            time = (TextView) view.findViewById(R.id.tv_valid_time);
            score = (TextView) view.findViewById(R.id.tv_score);
        }
    }


}
