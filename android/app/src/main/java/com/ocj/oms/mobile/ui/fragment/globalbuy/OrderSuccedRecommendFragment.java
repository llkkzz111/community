package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.bean.items.SameRecommendBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.adapter.OrderRecommendAdapter;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;

import java.util.List;

import butterknife.BindView;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 订单成功页下面的推荐
 */

public class OrderSuccedRecommendFragment extends BaseFragment {

    @BindView(R.id.recy_order_recommend) RecyclerView recycleView;
    OrderRecommendAdapter adapter;
    protected PackageListBean parentData;


    public static OrderSuccedRecommendFragment newInstance() {
        return new OrderSuccedRecommendFragment();
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_order_recommend_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();
        requstData();
    }

    private void initView() {
        GridLayoutManager manager = new GridLayoutManager(mActivity, 1);
        recycleView.setLayoutManager(manager);
        recycleView.addItemDecoration(new SpacesItemDecoration(mActivity, LinearLayoutManager.HORIZONTAL, 1));
        recycleView.setNestedScrollingEnabled(false);

        adapter = new OrderRecommendAdapter(mActivity);
        recycleView.setAdapter(adapter);
    }

    private void requstData() {

        //TODO 需要获取商品 itemcode
        new ItemsMode(mActivity).getSameRecommendList("101", new ApiResultObserver<List<SameRecommendBean>>(mActivity) {
            @Override
            public void onSuccess(List<SameRecommendBean> result) {
                if (result == null || result.size() == 0) {
                    ToastUtils.showLongToast("暂无推荐数据");
                    return;
                }
                adapter.setDatas(result);
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }
        });
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
