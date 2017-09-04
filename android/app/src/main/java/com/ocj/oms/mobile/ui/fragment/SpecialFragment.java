package com.ocj.oms.mobile.ui.fragment;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.AbroadBuyActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/9.
 */

public class SpecialFragment extends BaseFragment {

    private List<CmsItemsBean> data;
    private PackageListBean packageBean;

    @BindView(R.id.iv_background1) ImageView ivBackground1;
    @BindView(R.id.tv_special_name1) TextView tvSpecialName1;
    @BindView(R.id.tv_description1) TextView tvDescription1;
    @BindView(R.id.rl_friday_special1) ViewGroup rlFridaySpecial1;
    @BindView(R.id.iv_background2) ImageView ivBackground2;
    @BindView(R.id.tv_special_name2) TextView tvSpecialName2;
    @BindView(R.id.tv_description2) TextView tvDescription2;
    @BindView(R.id.rl_friday_special2) ViewGroup rlFridaySpecial2;
    @BindView(R.id.iv_background3) ImageView ivBackground3;
    @BindView(R.id.tv_special_name3) TextView tvSpecialName3;
    @BindView(R.id.tv_description3) TextView tvDescription3;
    @BindView(R.id.rl_friday_special3) ViewGroup rlFridaySpecial3;

    public static SpecialFragment newInstance(PackageListBean packageBean) {
        SpecialFragment fragment = new SpecialFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(IntentKeys.EXTRA, packageBean);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_special_layout;
    }

    @Override
    protected void initEventAndData() {
        packageBean = (PackageListBean) getArguments().get(IntentKeys.EXTRA);
        data = (List<CmsItemsBean>) packageBean.getComponentList();
        if (data != null && data.size() > 2) {
            LoaderFactory.getLoader().loadNet(ivBackground1, data.get(0).getFirstImgUrl(), null);
            tvSpecialName1.setText(data.get(0).getTitle());
            tvDescription1.setText(data.get(0).getSubtitle());

            LoaderFactory.getLoader().loadNet(ivBackground2, data.get(1).getFirstImgUrl(), null);
            tvSpecialName2.setText(data.get(1).getTitle());
            tvDescription2.setText(data.get(1).getSubtitle());

            LoaderFactory.getLoader().loadNet(ivBackground3, data.get(2).getFirstImgUrl(), null);
            tvSpecialName3.setText(data.get(2).getTitle());
            tvDescription3.setText(data.get(2).getSubtitle());
        }
    }

    @Override
    protected void lazyLoadData() {

    }

    @OnClick({R.id.rl_friday_special1, R.id.rl_friday_special2, R.id.rl_friday_special3})
    public void onClick(View view) {
        String url = null;
        switch (view.getId()) {
            case R.id.rl_friday_special1:
                url = data.get(0).getDestinationUrl();
                Map<String,Object> params1 = ((AbroadBuyActivity)mActivity).getParams();
                OcjStoreDataAnalytics.trackEvent(mActivity,data.get(0).getCodeValue(),data.get(0).getTitle(),params1);
                break;
            case R.id.rl_friday_special2:
                url = data.get(1).getDestinationUrl();
                Map<String,Object> params2 = ((AbroadBuyActivity)mActivity).getParams();
                OcjStoreDataAnalytics.trackEvent(mActivity,data.get(1).getCodeValue(),data.get(1).getTitle(),params2);
                break;
            case R.id.rl_friday_special3:
                url = data.get(2).getDestinationUrl();
                Map<String,Object> params3 = ((AbroadBuyActivity)mActivity).getParams();
                OcjStoreDataAnalytics.trackEvent(mActivity,data.get(2).getCodeValue(),data.get(2).getTitle(),params3);
                break;
        }
        if (!TextUtils.isEmpty(url)) {
            RouterModule.globalToWebView(url);
        }

    }
}
