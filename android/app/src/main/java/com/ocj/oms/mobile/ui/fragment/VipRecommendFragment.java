package com.ocj.oms.mobile.ui.fragment;

import android.os.Bundle;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.ContentListBean;
import com.ocj.oms.mobile.bean.VipNewBean;
import com.ocj.oms.mobile.ui.adapter.VipGoodsGridAdapter;

import java.util.List;

import butterknife.BindView;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 15:32
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class VipRecommendFragment extends BaseFragment {

    @BindView(R.id.iv_goods)
    ImageView ivGoods;
    @BindView(R.id.tv_name)
    TextView tvName;
    @BindView(R.id.tv_detail)
    TextView tvDetail;
    @BindView(R.id.gv_goods)
    GridView gvGoods;
    private VipGoodsGridAdapter adapter;
    private VipNewBean vipNewBean;
    private List<ContentListBean> listbean;

    public static VipRecommendFragment newInstance(VipNewBean vipNewBean) {
        VipRecommendFragment imageFragment = new VipRecommendFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("extra", vipNewBean);
        imageFragment.setArguments(bundle);
        return imageFragment;
    }


    @Override
    protected int getlayoutId() {
        return R.layout.fragment_vip_recommend_layout;
    }

    @Override
    protected void initEventAndData() {
        Bundle bundle = getArguments();
        vipNewBean = (VipNewBean) bundle.get("extra");
        listbean = vipNewBean.getResult().get(1).getSetList().get(0).getContentList();
        adapter = new VipGoodsGridAdapter(mActivity, vipNewBean);
        gvGoods.setAdapter(adapter);
        LoaderFactory.getLoader().loadNet(ivGoods, listbean.get(0).getContentImage());
        if (null != listbean.get(0).getAlt_desc()) {
            tvName.setText(listbean.get(0).getAlt_desc());
        } else {
        }
        if (null != listbean.get(0).getConts_desc()) {
            tvDetail.setText(listbean.get(0).getConts_desc());
        } else {

        }
    }

    @Override
    protected void lazyLoadData() {

    }

}
