package com.ocj.oms.mobile.ui.redpacket;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/11.
 */
@Route(path = RouterModule.AROUTER_PATH_LOTTERY)
public class LotteryActivity extends BaseActivity {

    @BindView(R.id.vp_lottery) ViewPager vpLottery;

//    private String[] nos = {"2016032910001", "2016082510001", "2015072410001", "2016030410001", "2016022310001", "2016032810002", "2016041110003", "A20170413105255"};

    private List<Fragment> fragments;

    private List<PackageListBean> packageListBeen;
    private CmsContentBean apiResul = null;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_lottery_layout;
    }

    @Override
    protected void initEventAndData() {
        fragments = new ArrayList<>();
        packageListBeen = new ArrayList<>();

        getSMGList();
    }

    private void getSMGList() {
        showLoading();
        new AccountMode(mContext).getSMGList(new ApiResultObserver<CmsContentBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onSuccess(CmsContentBean apiResult) {
                hideLoading();
                apiResul = apiResult;
                OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A002);
                setContent(apiResult.getPackageList());
            }
        });
    }

    private void setContent(List<PackageListBean> packageListBeen) {
        for (PackageListBean packageListBean : packageListBeen) {
            if (packageListBean != null && packageListBean.getComponentList() != null) {
                fragments.add(LotteryFragment.newInstance(packageListBean));
                this.packageListBeen.add(packageListBean);
            }
        }
        LotteryPageAdapter adapter = new LotteryPageAdapter(getSupportFragmentManager());
        vpLottery.setPageMargin(DensityUtil.dip2px(mContext, 20));
        vpLottery.setOffscreenPageLimit(3);
        vpLottery.setAdapter(adapter);
    }

    public Map<String, Object> getParams() {
        Map<String, Object> params = new HashMap<>();

        if(apiResul!=null){
            params.put("pID", apiResul.getCodeValue());
            params.put("vID", apiResul.getPageVersionName());
        }

        return params;
    }

    @OnClick({R.id.iv_close, R.id.tv_rule})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_close:
                finish();
                break;
            case R.id.tv_rule:
                Intent intent = new Intent(this, LotteryRuleActivity.class);
                intent.putExtra(IntentKeys.LOTTERY_RULE, packageListBeen.get(vpLottery.getCurrentItem()).getComponentList().get(0).getGraphicText());
                startActivity(intent);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (apiResul != null)
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A002);
    }

    class LotteryPageAdapter extends FragmentPagerAdapter {
        public LotteryPageAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }

        @Override
        public int getCount() {
            return fragments.size();
        }
    }
}
