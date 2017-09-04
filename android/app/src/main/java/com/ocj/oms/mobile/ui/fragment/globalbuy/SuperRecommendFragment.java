package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.GridLayoutManager;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.GridDividerItemDecoration;
import com.ocj.oms.mobile.ui.adapter.SuperRecommendAdapter;
import com.ocj.oms.view.FixHeightRecycleView;

import java.util.List;

import butterknife.BindColor;
import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 超值推荐
 */

public class SuperRecommendFragment extends BaseFragment {

    @BindView(R.id.recy_super_recommend) FixHeightRecycleView recycleView;
    SuperRecommendAdapter adapter;
    protected PackageListBean parentData;
    @BindColor(R.color.grey) int lineColor;

    public static SuperRecommendFragment newInstance() {
        return new SuperRecommendFragment();
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_super_recommend_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();
    }

    private void initView() {
        GridLayoutManager manager = new GridLayoutManager(mActivity, 2);
        recycleView.setLayoutManager(manager);

        GridDividerItemDecoration dividerItemDecoration = new GridDividerItemDecoration(getActivity(),
                GridDividerItemDecoration.GRID_DIVIDER_VERTICAL);
        dividerItemDecoration.setVerticalDivider(getResources().getDrawable(R.drawable.shape_grid_divider));
        dividerItemDecoration.setHorizontalDivider(getResources().getDrawable(R.drawable.shape_grid_divider));

        recycleView.addItemDecoration(dividerItemDecoration);

        recycleView.setNestedScrollingEnabled(false);

        adapter = new SuperRecommendAdapter(mActivity);
        CmsItemsBean beanX = getData().getComponentList().get(0);
        adapter.setDatas(beanX.getComponentList());
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

    public void addData(List<CmsItemsBean> list) {
        adapter.addDatas(list);
    }
}
