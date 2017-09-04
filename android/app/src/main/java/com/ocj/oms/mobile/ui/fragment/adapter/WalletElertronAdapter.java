package com.ocj.oms.mobile.ui.fragment.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.RecycleBaseAdapter;
import com.ocj.oms.mobile.bean.ElectronBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.utils.Utils;

import java.util.List;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liu on 2017/5/24.
 */

public class WalletElertronAdapter extends RecycleBaseAdapter<ElectronBean> {
    private Context mContext;

    public WalletElertronAdapter(Context activity, List<ElectronBean> data) {
        super(data);
        this.mContext = activity;
    }

    @Override
    public BaseViewHolder getHolder(View item, ViewGroup parent, int viewType) {
        return new IntergralViewHolder(LayoutInflater.from(mContext).inflate(viewType, null));
    }

    @Override
    public int getLayoutRes(int position) {
        return R.layout.item_holder_wallet_elertron_layout;
    }

    @Override
    public void convert(BaseViewHolder holder, ElectronBean data, int index, int type) {
        holder.onBind(index, data);
    }

    class IntergralViewHolder extends BaseViewHolder<ElectronBean> {
        @BindView(R.id.tv_no) TextView tvNo;
        @BindView(R.id.tv_card_no) TextView tvCardNo;
        @BindView(R.id.tv_card_pass) TextView tvCardPwd;
        @BindView(R.id.tv_copy_card_no) TextView tvCopyNo;
        @BindView(R.id.tv_copy_card_pwd) TextView tvCopyPwd;
        @BindView(R.id.ll_card_pass) LinearLayout llCardPass;
        @BindView(R.id.tv_card_money) TextView tvCardMoney;
        @BindView(R.id.tv_card_state) TextView tvCardState;

        @BindColor(R.color.text_grey_999999) int grey999999;
        @BindColor(R.color.text_black_333333) int black333333;

        public IntergralViewHolder(View itemView) {
            super(itemView);
            ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            itemView.setLayoutParams(layoutParams);
        }

        @Override
        public void onBind(int position, ElectronBean bean) {
            if (bean != null) {
                if (position == 0) {
                    tvNo.setText("序号");
                    tvCardMoney.setText("面额");
                    tvCardState.setText("状态");
                    tvCardNo.setText("卡号信息");
                    tvCopyNo.setVisibility(View.GONE);
                    llCardPass.setVisibility(View.GONE);
                } else {
                    tvNo.setText("0" + String.valueOf(position));
                    tvCardState.setText(bean.getCard_state());
                    if ("未激活".equals(bean.getCard_state())) {
                        tvCardNo.setText("-");
                        llCardPass.setVisibility(View.GONE);
                        tvCardState.setTextColor(grey999999);
                    } else {
                        tvCardState.setTextColor(black333333);
                        tvCardMoney.setText(String.valueOf(bean.getCard_amt()));
                        tvCardNo.setText("卡号：" + bean.getCard_no());
                        tvCardPwd.setText("卡密：" + bean.getCard_pass());
                    }
                }
            }
        }

        @OnClick({R.id.tv_copy_card_no, R.id.tv_copy_card_pwd})
        void onClick(View view) {
            switch (view.getId()) {
                case R.id.tv_copy_card_no:
                    Utils.copy(tvCardNo.getText().toString(), mContext);
                    break;
                case R.id.tv_copy_card_pwd:
                    Utils.copy(tvCardPwd.getText().toString(), mContext);
                    break;
            }
        }
    }
}
