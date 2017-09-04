package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ContentListBean;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 类描述：
 * 创建人：yanglinchuan
 * 邮箱：linchuan.yang@pactera.com
 * 创建日期：2017/6/8 17:37
 */
public class VipSelectedLvAdapter extends BaseAdapter {
    private final Context mContext;
    private final LayoutInflater mInflater;
    private List<ContentListBean> listbean;
    private ContentListBean bean;

    public VipSelectedLvAdapter(Context context, List<ContentListBean> listbean) {
        this.mContext = context;
        this.mInflater = LayoutInflater.from(context);
        this.listbean = listbean;
    }

    @Override
    public int getCount() {
        return listbean.size();
    }

    @Override
    public Object getItem(int i) {
        return listbean.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
        final ViewHolder viewHolder;
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.item_vip_selected, null);
            viewHolder = new ViewHolder(convertView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        //填充数据
        bean = listbean.get(position);
        LoaderFactory.getLoader().loadNet(viewHolder.ivPic, bean.getItem_image());

        if (!TextUtils.isEmpty(bean.getContent_nm())) {
            viewHolder.tvTips.setVisibility(View.VISIBLE);
            viewHolder.tvName.setText(String.format(mContext.getString(R.string.space_text_vip), bean.getConts_title_nm()));
        } else {
            viewHolder.tvName.setText(bean.getConts_title_nm());
            viewHolder.tvTips.setVisibility(View.GONE);
        }
        viewHolder.tvPrice.setText("¥" + bean.getSale_price() + "");

        if (bean.getSave_amt() == 0) {
            viewHolder.llScore.setVisibility(View.GONE);
        } else {
            viewHolder.llScore.setVisibility(View.VISIBLE);
            viewHolder.tvIntegral.setText(bean.getSave_amt() + "");
        }
        if (TextUtils.isEmpty(bean.getPromo_last_name())) {
            viewHolder.giftLayout.setVisibility(View.GONE);
        } else {
            viewHolder.giftLayout.setVisibility(View.VISIBLE);
            viewHolder.tvGift.setText(bean.getPromo_last_name());
        }

        viewHolder.item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RouterModule.vipToDetail(listbean.get(position).getItem_code());
            }
        });
        return convertView;
    }


    static class ViewHolder {
        @BindView(R.id.tv_name) TextView tvName;
        @BindView(R.id.tv_color) TextView tvColor;
        @BindView(R.id.tv_gift) TextView tvGift;
        @BindView(R.id.tv_price) TextView tvPrice;
        @BindView(R.id.tv_integral) TextView tvIntegral;
        @BindView(R.id.iv_pic) ImageView ivPic;
        @BindView(R.id.ll_select_item) View item;
        @BindView(R.id.tv_tips) ImageView tvTips;

        @BindView(R.id.ll_intergral) LinearLayout llScore;

        @BindView(R.id.ll_gift) View giftLayout;


        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
