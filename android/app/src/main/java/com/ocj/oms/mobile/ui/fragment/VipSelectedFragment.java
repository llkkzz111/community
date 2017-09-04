package com.ocj.oms.mobile.ui.fragment;

import android.os.Bundle;
import android.widget.ListView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.ContentListBean;
import com.ocj.oms.mobile.bean.VipNewBean;
import com.ocj.oms.mobile.ui.adapter.VipSelectedLvAdapter;

import java.util.List;

import butterknife.BindView;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 16:30
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class VipSelectedFragment extends BaseFragment {
    @BindView(R.id.lv_goods)
    ListView lvGoods;
    private VipSelectedLvAdapter adapter;
    private VipNewBean vipNewBean;
    private List<ContentListBean> listbean;

    public static VipSelectedFragment newInstance(VipNewBean vipNewBean) {
        VipSelectedFragment imageFragment = new VipSelectedFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("extra",vipNewBean);
        imageFragment.setArguments(bundle);
        return imageFragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_vip_selected_layout;
    }

    @Override
    protected void initEventAndData() {
        Bundle bundle = getArguments();
        vipNewBean = (VipNewBean) bundle.get("extra");
        listbean = vipNewBean.getResult().get(2).getSetList().get(0).getContentList();
        adapter = new VipSelectedLvAdapter(mActivity,listbean);
        lvGoods.setAdapter(adapter);
    }

    @Override
    protected void lazyLoadData() {

    }


}
