package com.ocj.oms.mobile.ui.video.holder;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.RecommendAdapter;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/23.
 */

public class HHolder extends BaseHolder<PackageListBean> {

    @BindView(R.id.recle_horizonlist) RecyclerView horizonList;//横向list
    private RecommendAdapter horizonAdapter;

    public HHolder(View itemView) {
        super(itemView);
    }

    @Override
    public void onBind(int position, PackageListBean iItem) {
        initHorizonRecycleView(iItem);
    }

    private void initHorizonRecycleView(PackageListBean iItem) {
        horizonAdapter = new RecommendAdapter(horizonList.getContext());
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(horizonList.getContext(), LinearLayoutManager.HORIZONTAL, false);
        horizonList.setLayoutManager(linearLayoutManager);

        //  horizonList.addItemDecoration(new SpacesItemDecoration(itemView.getContext(), LinearLayoutManager.VERTICAL));

        horizonList.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    if (horizonList.getChildCount() > 0) {
                        horizonList.getChildAt(0).requestFocus();
                    }
                }
            }
        });
        horizonAdapter.setData(iItem.getComponentList().get(0).getComponentList());
        horizonList.setAdapter(horizonAdapter);

    }


}
