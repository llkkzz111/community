package com.ocj.oms.mobile.ui.personal.wallet.integral;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.SaveamtBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/24.
 */

public class IntergralDetailsAdapter extends RecycleBaseAdapter<SaveamtBean> {
    private Context mContext;

    public IntergralDetailsAdapter(Context activity, List<SaveamtBean> data) {
        super(data);
        this.mContext = activity;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new IntergralViewHolder(LayoutInflater.from(mContext).inflate(viewType, null));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_holder_intergral_detail_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, SaveamtBean data, int index, int type) {
        holder.onBind(index, data);
    }

    class IntergralViewHolder extends BaseViewHolder<SaveamtBean> {
        @BindView(R.id.tv_description)
        TextView tvDescription;
        @BindView(R.id.tv_integral)
        TextView tvIntegral;
        @BindView(R.id.tv_time)
        TextView tvTime;


        public IntergralViewHolder(View itemView) {
            super(itemView);
            ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            itemView.setLayoutParams(layoutParams);
        }

        @Override
        public void onBind(int position, SaveamtBean bean) {
            if (bean != null) {
                if (TextUtils.isEmpty(bean.getSaveAmtExpireDate())) {
                    tvDescription.setText(bean.getSaveAmtName());
                } else {
                    tvDescription.setText(bean.getSaveAmtName() + "  有效期至" + bean.getSaveAmtExpireDate());
                }

                tvTime.setText(bean.getSaveAmtGetDate());
                tvIntegral.setText(bean.getSaveAmt() + " 分");
                if (bean.getSaveAmt().startsWith("+")) {
                    tvIntegral.setTextColor(Color.parseColor("#E5290D"));
                } else {
                    tvIntegral.setTextColor(Color.parseColor("#999999"));
                }


            }
        }
    }
}
