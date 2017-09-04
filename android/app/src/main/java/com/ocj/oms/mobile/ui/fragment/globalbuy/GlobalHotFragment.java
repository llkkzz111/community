package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.ui.adapter.GlobalHotAdapter;
import com.ocj.oms.mobile.ui.adapter.GridDividerItemDecoration;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 全球热搜
 */

public class GlobalHotFragment extends BaseFragment {

    @BindView(R.id.recy_global_hot) RecyclerView recycleView;

    GlobalHotAdapter adapter;
//    GlobalHotAdapter2 adapter2;

    List<CmsItemsBean> datas = new ArrayList<>();


    public static GlobalHotFragment newInstance() {
        return new GlobalHotFragment();
    }

    public void setDataList(List<CmsItemsBean> list) {
        this.datas = list;
    }


    @Override
    protected int getlayoutId() {
        return R.layout.fragment_global_hot_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();

    }


    private void initView() {

        GridLayoutManager manager = new GridLayoutManager(mActivity, 1, GridLayoutManager.VERTICAL, false);

        GridLayoutManager layoutManager = new GridLayoutManager(getActivity(), 3, GridLayoutManager.VERTICAL, false);
        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                return position == 0 ? 2 : 1;
            }
        });

        recycleView.setLayoutManager(manager);
//        recycleView.setLayoutManager(layoutManager);

        GridDividerItemDecoration dividerItemDecoration = new GridDividerItemDecoration(getActivity(),
                GridDividerItemDecoration.GRID_DIVIDER_VERTICAL);
        dividerItemDecoration.setVerticalDivider(getResources().getDrawable(R.drawable.shape_grid_divider));
        dividerItemDecoration.setHorizontalDivider(getResources().getDrawable(R.drawable.shape_grid_divider));
        recycleView.addItemDecoration(dividerItemDecoration);

        recycleView.setNestedScrollingEnabled(false);

        adapter = new GlobalHotAdapter(mActivity);
//        adapter2 = new GlobalHotAdapter2(mActivity);

        if (datas.size() == 0) {
            ToastUtils.showLongToast("全球热门暂无数据!");
            return;
        }

        adapter.setDatas(datas);
        recycleView.setAdapter(adapter);

//        adapter2.setDatas(datas);
//        recycleView.setAdapter(adapter2);
    }

    @Override
    protected void lazyLoadData() {

    }


}
