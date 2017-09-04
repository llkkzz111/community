package com.ocj.oms.mobile.ui;

import android.content.Intent;
import android.support.v4.app.FragmentTransaction;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ScrollView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.VipNewBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.fragment.VipRecommendFragment;
import com.ocj.oms.mobile.ui.fragment.VipSelectedFragment;
import com.ocj.oms.mobile.ui.fragment.globalbuy.VipItemFragment;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.login.media.MobileReloginActivity;
import com.ocj.oms.utils.OCJPreferencesUtils;

import butterknife.BindView;
import butterknife.OnClick;

import static com.ocj.oms.mobile.ui.rn.RouterModule.AROUTER_PATH_VIP;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 17:36
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:展示vip部分页面
 */
@Route(path = AROUTER_PATH_VIP)
public class VipInfoActivity extends BaseActivity {
    FragmentTransaction transaction;
    @BindView(R.id.ll_goods)
    LinearLayout llGoods;
    @BindView(R.id.ll_selected_vip)
    LinearLayout llSelected;
    @BindView(R.id.ll_parent)
    LinearLayout parent;

    @BindView(R.id.scrollview_parent)
    ScrollView scrollView;

    @BindView(R.id.rl_empty)
    View emptyView;


    private VipNewBean vipNewBean;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_vip;
    }

    @Override
    protected void initEventAndData() {
        showLoading();
        new ItemsMode(mContext).getVipItems(new ApiResultObserver<VipNewBean>(mContext) {
            @Override
            public void onSuccess(VipNewBean apiResult) {
                showContentView();
                vipNewBean = apiResult;
                transaction = getSupportFragmentManager().beginTransaction();
                transaction.add(R.id.ll_goods, VipRecommendFragment.newInstance(vipNewBean));
                transaction.add(R.id.ll_selected_vip, VipSelectedFragment.newInstance(vipNewBean));
                transaction.commit();
                initView();
                hideLoading();
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                if (e.getCode() == 4010) {
                    Intent intent = new Intent();
                    if (TextUtils.isEmpty(OCJPreferencesUtils.getLoginId())) {
                        intent.setClass(mContext, LoginActivity.class);
                    } else {
                        intent.setClass(mContext, MobileReloginActivity.class);
                    }
                    startActivity(intent);
                    finish();
                } else {
                    showEmptyView();
                }


            }
        });
    }

    //显示空页面
    private void showContentView() {
        scrollView.setVisibility(View.VISIBLE);
        emptyView.setVisibility(View.GONE);
    }


    //显示空页面
    private void showEmptyView() {
        scrollView.setVisibility(View.GONE);
        emptyView.setVisibility(View.VISIBLE);
    }


    private void initView() {
        int size = parent.getChildCount();
        transaction = getSupportFragmentManager().beginTransaction();
        for (int i = 0; i < size; i++) {
            VipItemFragment fragment = VipItemFragment.newInstance();
            fragment.setTag(i + 1);
            transaction.add(parent.getChildAt(i).getId(), fragment);
        }
        transaction.commit();
    }

    @OnClick(R.id.btn_close)
    public void onItemClick(View view) {
        finish();
    }


}
