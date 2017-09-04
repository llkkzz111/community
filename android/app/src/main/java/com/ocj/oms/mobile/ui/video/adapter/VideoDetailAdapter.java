package com.ocj.oms.mobile.ui.video.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.video.holder.BaseHolder;
import com.ocj.oms.mobile.ui.video.holder.GHolder;
import com.ocj.oms.mobile.ui.video.holder.HHolder;
import com.ocj.oms.mobile.ui.video.holder.VHolder;
import com.ocj.oms.mobile.ui.video.listener.ItemClickListener;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liu on 2017/5/23.
 */

public class VideoDetailAdapter extends RecyclerView.Adapter<BaseHolder<Integer>> {
    private List<PackageListBean> packageList = new ArrayList<>();

    private int fragmentTab = 0;

    private ItemClickListener itemClickListener;
    private Context mContext;


    public VideoDetailAdapter(Context mContex, List<PackageListBean> packageList) {
        this.packageList.clear();
        this.packageList.addAll(packageList);
        this.mContext = mContex;
    }

    public void setTab(int tag) {
        this.fragmentTab = tag;
    }

    public void setItemClickListener(ItemClickListener itemClickListener) {
        this.itemClickListener = itemClickListener;
    }

    @Override
    public BaseHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_holder_video_player_layout, parent, false);
        switch (viewType) {
            case 36:
                return new VHolder(view, fragmentTab, itemClickListener);
            case 13:
                return new HHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_holder_video_more_recommend_layout, parent, false));
            case 41:
                return new GHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_holder_video_more_video_layout, parent, false));
            default:
                return null;
        }
    }

    @Override
    public void onBindViewHolder(BaseHolder holder, int position) {
        holder.onBind(position, packageList.get(position));
    }

    @Override
    public int getItemViewType(int position) {
        return Integer.parseInt(packageList.get(position).getPackageId());
    }


    @Override
    public int getItemCount() {
        return packageList.size();
    }

    //添加购物车
    public interface OnAddItemToShopCartListener {
        void addItemToShopCart();
    }
}
