package com.ocj.oms.mobile.ui;


import android.annotation.TargetApi;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.ScrollView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.AbroadRecomendBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.fragment.BabyFragment;
import com.ocj.oms.mobile.ui.fragment.BannerFragment;
import com.ocj.oms.mobile.ui.fragment.FridayFragment;
import com.ocj.oms.mobile.ui.fragment.ImageFragment;
import com.ocj.oms.mobile.ui.fragment.SpecialFragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.AbroadFamousRecommendFragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.FreeBuy200Fragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.GlobalHotFragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.ProductSortFragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.SuperRecommendFragment;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

/**
 * Created by yy on 2017/6/8.
 * 全球购
 */
@Route(path = RouterModule.AROUTER_PATH_ABROAD_BUY)
public class AbroadBuyActivity extends BaseActivity {

    private FragmentTransaction transaction;

    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.scrollview) ScrollView mScrollView;
    @BindView(R.id.iv_scroll_top) ImageView scrollTop;

    private int pageNo = 1;
    private static final int PAGE_SIZE = 6;
    private String id;

    private SuperRecommendFragment superFragment;
    private CmsContentBean apiResul = null;
    private List<CmsItemsBean> mdatas = new ArrayList<>();
    private List<CmsItemsBean> mAbroadFamous = new ArrayList<>();

    @Override
    protected int getLayoutId() {
        return R.layout.activity_abroad_buy_layout;
    }

    @Override
    protected void initEventAndData() {
        initView();


    }

    private void initView() {
        if(Build.VERSION_CODES.M <= Build.VERSION.SDK_INT) {
            initScroll();
        }

        mPtrFrame.setMode(PtrFrameLayout.Mode.LOAD_MORE);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                loadMore();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, mScrollView, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, mScrollView, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {

            }
        });
        showLoading();
        new ItemsMode(mContext).getAbroadItems(new ApiResultObserver<CmsContentBean>(mContext) {
            @Override
            public void onSuccess(CmsContentBean apiResult) {
                apiResul = apiResult;
                OcjStoreDataAnalytics.trackPageBegin(mContext, apiResult.getCodeValue() + apiResult.getPageVersionName());
                showContent(apiResult);
                hideLoading();
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                hideLoading();
            }
        });
        transaction = getSupportFragmentManager().beginTransaction();
    }


    /**
     * 初始化跟Scroll相关控件
     */
    @TargetApi(Build.VERSION_CODES.M)
    private void initScroll() {
        mScrollView.setOnScrollChangeListener(new View.OnScrollChangeListener() {
            @Override
            public void onScrollChange(View v, int scrollX, int scrollY, int oldScrollX, int oldScrollY) {
                if (scrollY > mScrollView.getMeasuredHeight()) {
                    if (scrollTop.getVisibility() != View.VISIBLE) {
                        scrollTop.setVisibility(View.VISIBLE);
                    }
                } else {
                    scrollTop.setVisibility(View.GONE);
                }
            }
        });
    }

    @OnClick(R.id.iv_scroll_top)
    public void onTopScroll(View view) {
        mScrollView.post(new Runnable() {
            @Override
            public void run() {
                mScrollView.fullScroll(ScrollView.FOCUS_UP);
                scrollTop.setVisibility(View.GONE);
            }
        });

    }


    public Map<String, Object> getParams() {
        Map<String, Object> params = new HashMap<>();
        params.put("pID", apiResul.getCodeValue());
        params.put("vID", apiResul.getPageVersionName());
        return params;
    }

    private void loadMore() {
        if (TextUtils.isEmpty(id + "")) {
            mPtrFrame.refreshComplete();
            return;
        }
        if (superFragment == null) {
            return;
        }

        new ItemsMode(mContext).getMoreAbroadItem(id + "", pageNo, PAGE_SIZE, new ApiResultObserver<AbroadRecomendBean>(mContext) {
            @Override
            public void onSuccess(AbroadRecomendBean apiResult) {
                mPtrFrame.refreshComplete();
                if (apiResult != null && apiResult.list != null && apiResult.list.size() != 0) {
                    pageNo++;
                    superFragment.addData(apiResult.list);
                    if (apiResult.list.size() < PAGE_SIZE) {
                        mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
                    }
                } else {
                    ToastUtils.showShortToast("暂无更多数据");
                }
            }

            @Override
            public void onError(ApiException e) {

                mPtrFrame.refreshComplete();
                ToastUtils.showShortToast("数据错误");
            }
        });
    }

    private String h5Url_first;
    private String h5Url_second;

    private void showContent(CmsContentBean apiResult) {
        for (PackageListBean packageBean : apiResult.getPackageList()) {
            String type = packageBean.getShortNumber() + "-" + packageBean.getPackageId();
            switch (type) {
                case "0-2":
                    transaction.add(R.id.fl_banner, BannerFragment.newInstance(packageBean));
                    break;
                case "1-4":
                    ProductSortFragment sortfragment = ProductSortFragment.newInstance();
                    sortfragment.setData(packageBean);
                    transaction.add(R.id.ll_sort, sortfragment);
                    break;
                case "2-42":
                    FreeBuy200Fragment freeBuyFragment = FreeBuy200Fragment.newInstance();
                    freeBuyFragment.setData(packageBean);
                    transaction.add(R.id.ll_freebuy, freeBuyFragment);
                    break;
                case "3-43":
                    transaction.add(R.id.fl_friday, FridayFragment.newInstance(packageBean));
                    break;
                case "4-14":
                    transaction.add(R.id.fl_special, SpecialFragment.newInstance(packageBean));
                    break;
                case "5-10":
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() > 0) {
                        h5Url_first = packageBean.getComponentList().get(0).getDestinationUrl();
                    }
                    transaction.add(R.id.fl_baby_image, ImageFragment.newInstance(packageBean));
                    break;
                case "6-42":
                    transaction.add(R.id.fl_baby, BabyFragment.newInstance(packageBean, h5Url_first));
                    break;
                case "7-10":
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() > 0) {
                        h5Url_second = packageBean.getComponentList().get(0).getDestinationUrl();
                    }
                    transaction.add(R.id.fl_good_image, ImageFragment.newInstance(packageBean));
                    break;
                case "8-42":
                    transaction.add(R.id.fl_good, BabyFragment.newInstance(packageBean, h5Url_second));
                    break;
                case "9-14":
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() != 0) {
                        mAbroadFamous.addAll(packageBean.getComponentList());
                    }
                    break;
                case "10-14":
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() != 0) {
                        mAbroadFamous.addAll(packageBean.getComponentList());
                    }
                    if (mAbroadFamous != null && mAbroadFamous.size() != 0) {
                        AbroadFamousRecommendFragment recomendFragment = AbroadFamousRecommendFragment.newInstance();
                        recomendFragment.setData(mAbroadFamous);
                        transaction.add(R.id.ll_abroad_recommend, recomendFragment);
                    }
                    break;
                case "11-14":
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() != 0) {
                        mdatas.addAll(packageBean.getComponentList());
                    }
                    break;
                case "12-14"://全球热门
                    if (packageBean.getComponentList() != null) {
                        mdatas.addAll(packageBean.getComponentList());
                    }
                    if (mdatas.size() != 0) {
                        GlobalHotFragment hotFragment = GlobalHotFragment.newInstance();
                        hotFragment.setDataList(mdatas);
                        transaction.add(R.id.ll_global_hot, hotFragment);
                    }
                    break;
                case "13-44"://超值推荐
                    if (packageBean.getComponentList() != null && packageBean.getComponentList().size() != 0) {
                        id = packageBean.getComponentList().get(0).getId();
                        superFragment = SuperRecommendFragment.newInstance();
                        superFragment.setData(packageBean);
                        transaction.add(R.id.ll_super_recomend, superFragment);
                    }
                    break;


            }
        }
        transaction.commit();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (apiResul != null)
            OcjStoreDataAnalytics.trackPageEnd(mContext, apiResul.getCodeValue() + apiResul.getPageVersionName());
    }

    @OnClick(R.id.rl_close)
    public void onItemClick(View view) {
        finish();
    }

    @OnClick(R.id.rl_message)
    public void onMessageClick(View view) {
        RouterModule.globalToMessageList();
    }


}
