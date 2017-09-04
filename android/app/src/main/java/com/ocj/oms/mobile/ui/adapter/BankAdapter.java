package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.OrderBean;
import com.ocj.oms.mobile.view.BaseHolder;

import java.util.List;

import butterknife.BindView;

/**
 * Created by yy on 2017/5/8.
 */

public class BankAdapter extends CommonAdapter {

    Context mContext;
    private OrderBean.LastPaymentBean selectBean;

    public BankAdapter(Context context, List<OrderBean.LastPaymentBean> date) {
        super(context);
        this.mContext = context;
        this.setData(date);
        if (date != null) {
            for (OrderBean.LastPaymentBean bean : date) {
                if (bean.isCheck()) {
                    selectBean = bean;
                    break;
                }
            }
        }
    }


    @Override
    public BaseHolder bindHoler(View view) {
        return new ViewHolder(view);
    }

    @Override
    public int getLayoutResId() {
        return R.layout.item_banklist;
    }

    @Override
    public void bindData(BaseHolder holder, final int position, Object item) {
        ViewHolder mholder = (ViewHolder) holder;
        final OrderBean.LastPaymentBean bankBean = (OrderBean.LastPaymentBean) this.getItem(position);
        mholder.tvBankcard.setText(bankBean.getTitle());
        if (bankBean.isCheck()) {
            mholder.tvBankcard.setTextColor(mContext.getResources().getColor(R.color.text_grey_333));
            mholder.ivVerifyTag.setVisibility(View.VISIBLE);

        } else {
            mholder.tvBankcard.setTextColor(mContext.getResources().getColor(R.color.text_grey_999999));
            mholder.ivVerifyTag.setVisibility(View.GONE);

        }
        mholder.tvEvent.setText(bankBean.getEventContent());
        LoaderFactory.getLoader().loadNet(mholder.bankIcon, bankBean.getIocnUrl());

        final int size = this.getCount();
        mholder.viewItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bankBean.setCheck(!bankBean.isCheck());
                for (int i = 0; i < size; i++) {
                    if (i != position) {
                        OrderBean.LastPaymentBean bean = (OrderBean.LastPaymentBean) getItem(i);
                        bean.setCheck(false);
                    } else {
                        if (bankBean.isCheck())
                            selectBean = bankBean;
                        else
                            selectBean = null;
                    }
                }
                notifyDataSetChanged();
            }
        });


    }

    public OrderBean.LastPaymentBean getSelector() {
        return selectBean;
    }

    static class ViewHolder extends BaseHolder {
        @BindView(R.id.tv_bankcard) TextView tvBankcard;
        @BindView(R.id.tv_event) TextView tvEvent;
        @BindView(R.id.im_circle) ImageView bankIcon;
        @BindView(R.id.iv_verify_tag) ImageView ivVerifyTag;
        @BindView(R.id.view_item) LinearLayout viewItem;

        ViewHolder(View view) {
            super(view);
        }
    }
}
