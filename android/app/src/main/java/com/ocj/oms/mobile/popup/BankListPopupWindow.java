package com.ocj.oms.mobile.popup;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.OrderBean;
import com.ocj.oms.mobile.ui.adapter.BankAdapter;

import java.util.List;


/**
 * Created by liuzhao on 16/5/3.
 */
public class BankListPopupWindow extends BasePopupWindow {

    private View view;
    private ListView mlistview;
    private BankAdapter adapter;
    private onSelectPayStyleListener listener;

    public BankListPopupWindow(Context mContext, onSelectPayStyleListener onSelectPayStyle) {
        super(mContext);
        listener = onSelectPayStyle;
    }

    public void setmDatas(List<OrderBean.LastPaymentBean> mDatas) {
        mlistview = (ListView) view.findViewById(R.id.lv_banklist);

        adapter = new BankAdapter(mContext, mDatas);
        mlistview.setAdapter(adapter);

        view.findViewById(R.id.btn_submit).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (adapter.getSelector() != null) {
                    listener.onPay(adapter.getSelector());
                    mPopupWindow.dismiss();
                } else {
                    ToastUtils.showShortToast("请选择支付方式");
                }
            }
        });

        mPopupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                listener.cancleSelect();
            }
        });

    }


    @Override
    public View getPopupWindow() {
        view = LayoutInflater.from(mContext).inflate(R.layout.base_popup_window_layout, null);
        view.findViewById(R.id.iv_cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
            }
        });
        return view;
    }

    public interface onSelectPayStyleListener {
        void onPay(OrderBean.LastPaymentBean bean);

        void cancleSelect();
    }

}
