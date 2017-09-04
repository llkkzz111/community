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
import com.ocj.oms.mobile.ui.adapter.FridayGoodsAdapter;

import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/9.
 */

public class FridayFragment extends BaseFragment {

    private List<CmsItemsBean> data;
    private PackageListBean packageBean;
    private FridayGoodsAdapter adapter;

    @BindView(R.id.rv_friday_goods)
    RecyclerView rvFridayGoods;

    public static FridayFragment newInstance(PackageListBean packageBean) {
        FridayFragment fragment = new FridayFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(IntentKeys.EXTRA, packageBean);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_friday_layout;
    }

    @Override
    protected void initEventAndData() {
        packageBean = (PackageListBean) getArguments().getSerializable(IntentKeys.EXTRA);
        data = packageBean.getComponentList().get(0).getComponentList();
        adapter = new FridayGoodsAdapter(mActivity, data);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayout.HORIZONTAL, false);
        rvFridayGoods.setLayoutManager(linearLayoutManager);
        rvFridayGoods.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }
}
