package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.ui.adapter.holder.BaseViewHolder;
import com.ocj.oms.mobile.ui.personal.adress.AddressEditActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

import static com.ocj.oms.mobile.IntentKeys.ADDRESS_BEAN;

/**
 * Created by MJJ on 2015/7/25.
 */
public class AddressManagerAdapter extends RecyclerView.Adapter<AddressManagerAdapter.ItemViewHolder> {
    private OnItemClickListener listener;
    private Context mContext;
    public static final int DELETE = 0;
    public static final int CHENGE = 1;
    private List<ReceiversBean> mDatas = new ArrayList<>();

    public AddressManagerAdapter(Context context, OnItemClickListener listener) {
        mContext = context;
        this.listener = listener;
    }

    public void setDatas(List<ReceiversBean> data) {
        this.mDatas = data;
        notifyDataSetChanged();
    }


    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    @Override
    public void onBindViewHolder(final ItemViewHolder holder, final int position) {
        final ReceiversBean bean = mDatas.get(position);
        holder.onBind(position, bean);
    }

    @Override
    public ItemViewHolder onCreateViewHolder(ViewGroup arg0, int arg1) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_adress_manager, arg0, false);
        ItemViewHolder holder = new ItemViewHolder(view);
        return holder;
    }


    class ItemViewHolder extends BaseViewHolder<ReceiversBean> {

        @BindView(R.id.tv_name) TextView tvName;
        @BindView(R.id.tv_mobile) TextView tvMobile;
        @BindView(R.id.cb_default) CheckBox cbDefault;
        @BindView(R.id.tv_address) TextView tvAdress;
        @BindView(R.id.tv_delete) TextView tvDelete;
        @BindView(R.id.tv_edit) TextView tvEdit;
        private ReceiversBean bean;

        public ItemViewHolder(View view) {
            super(view);
        }

        @Override
        public void onBind(int position, ReceiversBean bean) {
            this.bean = bean;
            tvName.setText(bean.getReceiver_name());
            tvMobile.setText(bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3());
            tvAdress.setText(bean.getAddr_m() + bean.getReceiver_addr());
            cbDefault.setChecked(bean.getDefault_yn().equals("1"));

        }

        @OnCheckedChanged(R.id.cb_default)
        void onCheckChenge(CheckBox view, boolean checked) {

        }

        @OnClick({R.id.tv_edit, R.id.tv_delete, R.id.cb_default})
        void onClick(View v) {
            switch (v.getId()) {
                case R.id.tv_edit:
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C062F012001O006001);
                    Intent intent = new Intent(mContext, AddressEditActivity.class);
                    intent.putExtra(ADDRESS_BEAN, bean);
                    mContext.startActivity(intent);
                    break;
                case R.id.tv_delete:
                    listener.onItemClick(bean, DELETE, false);
                    break;
                case R.id.cb_default:
                    if (cbDefault.isChecked()) {
                        listener.onItemClick(bean, CHENGE, true);
                    } else {
                        listener.onItemClick(bean, CHENGE, false);
                    }
                    cbDefault.setChecked(!cbDefault.isChecked());
                    break;
            }
        }
    }

    public interface OnItemClickListener {
        void onItemClick(ReceiversBean bean, int type, boolean checked);
    }


}

