package com.ocj.oms.mobile.ui.personal.wallet.imprest;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.DepositBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/24.
 */

public class ImprestDetailsAdapter extends RecycleBaseAdapter<DepositBean> {
    private Context mContext;

    public ImprestDetailsAdapter(Context activity, List<DepositBean> data) {
        super(data);
        this.mContext = activity;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new IntergralViewHolder(LayoutInflater.from(mContext).inflate(viewType, null));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_holder_imprest_detail_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, DepositBean data, int index, int type) {
        holder.onBind(index, data);
    }

    class IntergralViewHolder extends BaseViewHolder<DepositBean> {

        @BindView(R.id.tv_description) TextView tvDescription;
        @BindView(R.id.tv_imprest) TextView tvImprest;
        @BindView(R.id.tv_time) TextView tvTime;

        public IntergralViewHolder(View itemView) {
            super(itemView);
            ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            itemView.setLayoutParams(layoutParams);
        }

        @Override
        public void onBind(int position, DepositBean bean) {
            if (bean != null) {
                tvDescription.setText(bean.getDeposit_note());
                tvTime.setText(bean.getProc_date());
                tvImprest.setText(bean.getDepositamt());
            }
        }
    }
}
