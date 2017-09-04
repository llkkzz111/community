package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.SortAdapter;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 商品分类(更多分类)
 */

public class ProductSortFragment extends BaseFragment {

    @BindView(R.id.recy_sort) RecyclerView recycleView;

    List<CmsItemsBean> datas = new ArrayList<>();
    protected PackageListBean parentData;
    protected SortAdapter adapter;


    public static ProductSortFragment newInstance() {
        return new ProductSortFragment();
    }


    @Override
    protected int getlayoutId() {
        return R.layout.fragment_sort_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();
    }


    private void initView() {

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.HORIZONTAL, false);

        recycleView.setLayoutManager(linearLayoutManager);

        adapter = new SortAdapter(mActivity);
        if (getData() != null && getData().getComponentList() != null && getData().getComponentList().size() > 0) {
            datas.addAll(getData().getComponentList());
            Iterator<CmsItemsBean> iterator = datas.iterator();
            while (iterator.hasNext()) {
                if (TextUtils.isEmpty(iterator.next().getLgroup())) {
                    iterator.remove();
                }
            }
        }
        adapter.setDatas(datas);
        recycleView.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }


    public void setData(PackageListBean data) {
        this.parentData = data;
    }


    protected PackageListBean getData() {
        return parentData;
    }
}
