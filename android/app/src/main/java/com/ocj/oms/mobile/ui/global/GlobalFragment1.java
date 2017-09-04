package com.ocj.oms.mobile.ui.global;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 选择fragment
 * Created by shizhang.cai on 2017/6/7.
 */

public class GlobalFragment1 extends BaseFragment {

    @BindView(R.id.recyclerView)
    RecyclerView recyclerView;

    GlobalAdapter1 mAdapter;

    private ArrayList<Contact> contacts = new ArrayList<>();

    private List<Contact> mSelectList = new ArrayList<>();

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_global1_layout;
    }

    @Override
    protected void initEventAndData() {
        mAdapter = new GlobalAdapter1(getActivity(), R.layout.item_global_layout,contacts);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        recyclerView.setAdapter(mAdapter);
        mAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter adapter, View view, int position) {
                if(!mSelectList.contains(contacts.get(position))){
                    mSelectList.add(contacts.get(position));
                }else{
                    mSelectList.remove(contacts.get(position));
                }
                mAdapter.notifyDataSetChanged();
            }
        });
        mAdapter.setSelectList(mSelectList);
        mAdapter.notifyDataSetChanged();
    }

    public void setData(List<Contact> list,List<Contact> brandSelectList){
        this.contacts.clear();
        this.contacts.addAll(list);
        this.mSelectList.clear();
        this.mSelectList.addAll(brandSelectList);
        if(mAdapter!=null){
            mAdapter.setSelectList(this.mSelectList);
            mAdapter.notifyDataSetChanged();
        }
    }

    @Override
    protected void lazyLoadData() {

    }
    public List<Contact> getSelectList(){
        return mSelectList;
    }

}
