package com.ocj.oms.mobile.ui.global;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.view.WaveSideBar;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 字母排序fragment
 * Created by shizhang.cai on 2017/6/7.
 */

public class GlobalFragment2 extends BaseFragment {

    @BindView(R.id.recycleview)
    RecyclerView recycleview;

    @BindView(R.id.sideBar)
    WaveSideBar sideBar;

    private ArrayList<Contact> contacts = new ArrayList<>();

    private List<Contact> selectList = new ArrayList<>();
    ContactsAdapter  adapter;
    @Override
    protected int getlayoutId() {
        return R.layout.fragment_global2_layout;
    }

    @Override
    protected void initEventAndData() {
        recycleview.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter = new ContactsAdapter(contacts,R.layout.item_contacts_layout);
        adapter.setSelectList(selectList);
        recycleview.setAdapter(adapter);
        sideBar.setOnSelectIndexItemListener(new WaveSideBar.OnSelectIndexItemListener() {
            @Override
            public void onSelectIndexItem(String index) {
                for (int i=0; i<contacts.size(); i++) {
                    if (contacts.get(i).getIndex().equals(index)) {
                        ((LinearLayoutManager) recycleview.getLayoutManager()).scrollToPositionWithOffset(i, 0);
                        return;
                    }
                }
            }
        });
    }

    public void setData(List<Contact> list,List<Contact> selectList){
        this.contacts.clear();
        this.contacts.addAll(list);
        this.selectList.clear();
        this.selectList.addAll(selectList);
        if(adapter!=null){
            adapter.setSelectList(this.selectList);
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    protected void lazyLoadData() {

    }

    public List<Contact> getSelectList(){
        return adapter.getSelectList();
    }

}
