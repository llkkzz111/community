package com.ocj.oms.mobile.ui.video.holder;

import android.content.Context;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.adapter.GridDividerItemDecoration;
import com.ocj.oms.mobile.ui.adapter.VideoGridAdapter;

import butterknife.BindView;

/**
 * Created by liu on 2017/5/23.
 */

public class GHolder extends BaseHolder<PackageListBean> {

    @BindView(R.id.recle_grid) RecyclerView gridView;
    private VideoGridAdapter mAdapter;
    private Context mContext;

    public GHolder(View itemView) {
//        itemView = LayoutInflater.from(itemView.getContext()).inflate(R.layout.item_holder_video_more_recommend_layout, null);
        super(itemView);
        this.mContext = itemView.getContext();
    }


    @Override
    public void onBind(int position, PackageListBean iItem) {
        mAdapter = new VideoGridAdapter(gridView.getContext());
        mAdapter.setData(iItem.getComponentList().get(0).getComponentList());
        gridView.setLayoutManager(new GridLayoutManager(gridView.getContext(), 2));
        gridView.setAdapter(mAdapter);

        GridDividerItemDecoration dividerItemDecoration = new GridDividerItemDecoration(mContext,
                GridDividerItemDecoration.GRID_DIVIDER_VERTICAL);
        dividerItemDecoration.setVerticalDivider(mContext.getResources().getDrawable(R.drawable.shape_grid_divider));
        dividerItemDecoration.setHorizontalDivider(mContext.getResources().getDrawable(R.drawable.shape_grid_divider));

        gridView.addItemDecoration(dividerItemDecoration);
    }


}
