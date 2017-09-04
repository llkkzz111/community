package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.LotteryListDataBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/12.
 */

public class LotteryAdapter extends RecyclerView.Adapter<LotteryAdapter.MyViewHolder> {

    private List<LotteryListDataBean> data;
    private Context context;

    public LotteryAdapter(Context context, List<LotteryListDataBean> data) {
        this.context = context;
        this.data = data;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_lottery_layout, parent, false);
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

    class MyViewHolder extends BaseViewHolder<LotteryListDataBean> {

        @BindView(R.id.tv_name) TextView tvName;
        @BindView(R.id.tv_status) TextView tvStatus;
        @BindView(R.id.tv_number1) TextView tvNumber1;
        @BindView(R.id.tv_number2) TextView tvNumber2;
        @BindView(R.id.tv_number3) TextView tvNumber3;
        @BindView(R.id.tv_number4) TextView tvNumber4;
        @BindView(R.id.tv_number5) TextView tvNumber5;
        @BindView(R.id.tv_number6) TextView tvNumber6;
        @BindView(R.id.tv_number7) TextView tvNumber7;

        public MyViewHolder(View itemView) {
            super(itemView);
        }

        @Override
        public void onBind(int position, LotteryListDataBean bean) {
            if (!TextUtils.isEmpty(bean.getBall())) {
                String[] numbers = bean.getBall().split(",");
                tvNumber1.setText(numbers[0]);
                tvNumber2.setText(numbers[1]);
                tvNumber3.setText(numbers[2]);
                tvNumber4.setText(numbers[3]);
                tvNumber5.setText(numbers[4]);
                tvNumber6.setText(numbers[5]);
                tvNumber7.setText(numbers[6]);
            }

            tvName.setText(String.format("第%s期 双色球", bean.getDrawNo()));

            switch (bean.getDrawYN()) {
                case "drawN":
                    tvStatus.setTextColor(context.getResources().getColor(R.color.text_black_333333));
                    tvStatus.setText("未中奖");
                    break;
                case "drawY":
                    tvStatus.setTextColor(context.getResources().getColor(R.color.text_red_E5290D));
                    tvStatus.setText("中奖");
                    break;
                case "drawF":
                    tvStatus.setTextColor(context.getResources().getColor(R.color.text_black_333333));
                    tvStatus.setText("失败");
                    break;
                case "drawW":
                    tvStatus.setTextColor(context.getResources().getColor(R.color.text_grey_666666));
                    tvStatus.setText("等待开奖");
                    break;
                case "drawYN":
                    tvStatus.setTextColor(context.getResources().getColor(R.color.text_grey_666666));
                    tvStatus.setText("等待开奖");
                    break;
            }
        }
    }

}
