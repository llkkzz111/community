package com.ocj.oms.mobile.ui.fragment;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.LinearLayout;

import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.BabyGoodsAdapter;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/8.
 */

public class BabyFragment extends BaseFragment {

    @BindView(R.id.rv_goods_list) RecyclerView goodsList;

    private List<CmsItemsBean> data;
    private PackageListBean packageBean;
    private BabyGoodsAdapter adapter;
    private String url;

    public static BabyFragment newInstance(PackageListBean packageBean,String url) {
        BabyFragment fragment = new BabyFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(IntentKeys.EXTRA, packageBean);
        bundle.putSerializable("url", url);
        fragment.setArguments(bundle);
        return fragment;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_baby_layout;
    }

    @Override
    protected void initEventAndData() {
        packageBean = (PackageListBean) getArguments().getSerializable(IntentKeys.EXTRA);
        data = packageBean.getComponentList().get(0).getComponentList();
        url = getArguments().getString("url");
        adapter = new BabyGoodsAdapter(mActivity, data);
        adapter.setUrl(url);
        LinearLayoutManager layoutManager = new LinearLayoutManager(mActivity, LinearLayout.HORIZONTAL, false);
        goodsList.setLayoutManager(layoutManager);
        goodsList.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }

}
