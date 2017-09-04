package com.ocj.oms.mobile.ui.personal.wallet.opoint;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.OcouponsBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/24.
 */

public class OpointDetailsAdapter extends RecycleBaseAdapter<OcouponsBean> {
    private Context mContext;

    public OpointDetailsAdapter(Context activity, List<OcouponsBean> data) {
        super(data);
        this.mContext = activity;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new IntergralViewHolder(LayoutInflater.from(mContext).inflate(viewType, null));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_holder_opoint_detail_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, OcouponsBean data, int index, int type) {
        holder.onBind(index, data);
    }

    class IntergralViewHolder extends BaseViewHolder<OcouponsBean> {

        @BindView(R.id.tv_description) TextView tvDescription;
        @BindView(R.id.tv_opoint) TextView tvOpoint;
        @BindView(R.id.tv_time) TextView tvTime;

        public IntergralViewHolder(View itemView) {
            super(itemView);
            ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            itemView.setLayoutParams(layoutParams);
        }

        @Override
        public void onBind(int position, OcouponsBean bean) {
            if (bean != null) {
                tvDescription.setText("【" + bean.getEvent_name() + "】 " + bean.getItem_name());
                tvTime.setText(bean.getInsert_date());
                if(!TextUtils.isEmpty(bean.getOpoint_num())){
                    if(bean.getOpoint_num().startsWith("+")){
                        tvOpoint.setTextColor(Color.parseColor("#E5290D"));
                    }else if(bean.getOpoint_num().startsWith("-")){
                        tvOpoint.setTextColor(Color.parseColor("#999999"));
                    }
                }
                tvOpoint.setText(bean.getOpoint_num());
            }
        }
    }
}
