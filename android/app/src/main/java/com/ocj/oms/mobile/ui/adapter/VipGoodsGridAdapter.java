package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ContentListBean;
import com.ocj.oms.mobile.bean.VipNewBean;
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
public class VipGoodsGridAdapter extends BaseAdapter {
    private final Context mContext;
    private final LayoutInflater mInflater;
    private VipNewBean vipNewBean;
    private ContentListBean contentListBean;
    private List<ContentListBean> setListBean;

    public VipGoodsGridAdapter(Context context, VipNewBean vipNewBean) {
        this.mContext = context;
        this.mInflater = LayoutInflater.from(context);
        this.vipNewBean = vipNewBean;
        this.setListBean = vipNewBean.getResult().get(1).getSetList().get(0).getContentList();
    }

    @Override
    public int getCount() {
        return setListBean.size() - 1;
    }

    @Override
    public Object getItem(int i) {
        return setListBean.get(i + 1);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
        final ViewHolder viewHolder;
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.item_vipgoods_grid, null);
            viewHolder = new ViewHolder(convertView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        //填充数据
        contentListBean = setListBean.get(position + 1);

        LoaderFactory.getLoader().loadNet(viewHolder.ivPic, contentListBean.getItem_image());

        if (null != contentListBean.getBrand_name()) {
            viewHolder.tvName.setText(contentListBean.getBrand_name());
        } else {
            // viewHolder.tvName.setText(vipRecommendTwoBean.getBrand_name());
        }

        if (null != contentListBean.getItem_name()) {
            viewHolder.tvDetail.setText(contentListBean.getItem_name());
        } else {

        }
        viewHolder.tvPrice.setText("¥" + contentListBean.getSale_price());

        viewHolder.item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO 类似了contentCode
                RouterModule.vipToDetail(contentListBean.getItem_code());
            }
        });


        return convertView;
    }


    static class ViewHolder {
        @BindView(R.id.iv_pic)
        ImageView ivPic;
        @BindView(R.id.tv_name)
        TextView tvName;
        @BindView(R.id.tv_detail)
        TextView tvDetail;
        @BindView(R.id.tv_price)
        TextView tvPrice;
        @BindView(R.id.ll_item)
        View item;


        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
