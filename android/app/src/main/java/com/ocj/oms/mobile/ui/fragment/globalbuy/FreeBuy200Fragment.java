package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.FreeBuyAdapter;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 200 元全球购
 */

public class FreeBuy200Fragment extends BaseFragment {

    @BindView(R.id.recy_200freebuy) RecyclerView recycleView;
    FreeBuyAdapter adapter;
    protected PackageListBean parentData;

    public static FreeBuy200Fragment newInstance() {
        return new FreeBuy200Fragment();
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_200freebuy_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();

    }

    private void initView() {

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.HORIZONTAL, false);

        recycleView.setLayoutManager(linearLayoutManager);
//        recycleView.addItemDecoration(new SpacesItemDecoration(mActivity, LinearLayoutManager.HORIZONTAL, 1));
//        recycleView.addItemDecoration(new SpacesItemDecoration(mActivity, LinearLayoutManager.VERTICAL, 1));

        adapter = new FreeBuyAdapter(mActivity);
        CmsItemsBean beanX = null;
        if (parentData != null && parentData.getComponentList() != null)
            beanX = parentData.getComponentList().get(0);
        if (beanX != null && beanX.getComponentList() != null)
            adapter.setDatas(beanX.getComponentList());
        recycleView.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }


    public void setData(PackageListBean data) {
        this.parentData = data;
    }
}
