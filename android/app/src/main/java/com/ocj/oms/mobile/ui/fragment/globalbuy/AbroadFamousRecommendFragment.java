package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.GridLayoutManager;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.AbroadRecommendAdapter;
import com.ocj.oms.mobile.ui.adapter.GridDividerItemDecoration;
import com.ocj.oms.view.FixHeightRecycleView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 海外大牌推荐
 */

public class AbroadFamousRecommendFragment extends BaseFragment {

    @BindView(R.id.recy_abroad_commend) FixHeightRecycleView recommendRecy;
    protected AbroadRecommendAdapter adapter;
    protected List<CmsItemsBean> list = new ArrayList<>();

    public static AbroadFamousRecommendFragment newInstance() {
        return new AbroadFamousRecommendFragment();
    }


    @Override
    protected int getlayoutId() {
        return R.layout.fragment_abroad_recommend_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();

    }

    private void initView() {
        recommendRecy.setLayoutManager(new GridLayoutManager(mActivity, 3));
        GridDividerItemDecoration dividerItemDecoration = new GridDividerItemDecoration(getActivity(),
                GridDividerItemDecoration.GRID_DIVIDER_VERTICAL);
        dividerItemDecoration.setVerticalDivider(getResources().getDrawable(R.drawable.shape_grid_divider2));
        dividerItemDecoration.setHorizontalDivider(getResources().getDrawable(R.drawable.shape_grid_divider2));
        recommendRecy.addItemDecoration(dividerItemDecoration);
        recommendRecy.setNestedScrollingEnabled(false);

        adapter = new AbroadRecommendAdapter(mActivity);
        adapter.setDatas(list);
        recommendRecy.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }


    public void setData(List<CmsItemsBean> data) {
        if (data != null) {
            this.list.addAll(data);
        }
    }


    protected List<CmsItemsBean> getData() {
        return list;
    }
}
