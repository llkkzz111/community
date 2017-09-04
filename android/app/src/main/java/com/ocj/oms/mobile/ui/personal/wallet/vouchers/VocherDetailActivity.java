package com.ocj.oms.mobile.ui.personal.wallet.vouchers;

import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Num;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.VocherBean;
import com.ocj.oms.mobile.bean.VocherList;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.personal.wallet.tao.GrabVocherActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.utils.ViewUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;

import static com.ocj.oms.mobile.ParamKeys.ACCESS_TOKEN;
import static com.ocj.oms.mobile.ParamKeys.COUPON_NO;

/**
 * Created by yy on 2017/5/13.
 * <p>
 * 抵用券列表
 */
@Route(path = RouterModule.AROUTER_PATH_COUPON)
public class VocherDetailActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.tv_vocher_count) TextView tvCount;
    @BindView(R.id.et_exchange_input) EditText etExchange;
    @BindView(R.id.rv_refresh) RecyclerView rvList;
    @BindView(R.id.rg_select_pay) RadioGroup mRadioGroup;
    @BindView(R.id.inc_list) View mIncList;
    @BindView(R.id.rl_content) RelativeLayout contentView;
    List<VocherBean> datas = new ArrayList<>();
    VocherDetailsAdapter adapter;
    private int page;
    private String type;

    private boolean isRefreshMePage = false;//是否刷新RN个人中心标志位

    @Override
    protected int getLayoutId() {
        return R.layout.activity_vocher_detail_layout;
    }

    @Override
    protected void initEventAndData() {
        page = 1;
        type = "all";
        initPtr();
        initView();
        qurryCount();
        qurryVocherList();
        maiDian();
    }

    private void initView() {
        rvList.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new VocherDetailsAdapter(mContext, datas);
        rvList.setAdapter(adapter);
        adapter.setListner(new VocherDetailsAdapter.OnUseVocherListener() {
            @Override
            public void onVocherUse(VocherBean bean) {
//                useVocher(bean);
            }
        });
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                page++;
                qurryVocherList();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, rvList, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, rvList, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                page = 1;
                qurryVocherList();
            }

        });
    }


    private void qurryVocherList() {
        Map<String, Object> params = new HashMap<>();
        params.put(ParamKeys.STUTUS_TYPE, type);
        params.put(ParamKeys.PAGE, page);
        showLoading();
        new WalletMode(mContext).getVocherList(params, new ApiResultObserver<VocherList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                showErrorView(e.getMessage());
                mPtrFrame.refreshComplete();
                hideLoading();
            }


            @Override
            public void onSuccess(VocherList apiResult) {
                hideLoading();
                if (page == 1) {
                    rvList.scrollToPosition(0);
                    datas.clear();
                }
                if (apiResult != null)
                    datas.addAll(apiResult.getMyTicketList());
                adapter.notifyDataSetChanged();
                mPtrFrame.refreshComplete();

                if (page > apiResult.getMaxPage()) {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                } else {
                    mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
                }
                //无数据处理
                if (datas.size() == 0) {
                    showEmptyView();
                } else {
                    mIncList.setVisibility(View.VISIBLE);
                    contentView.removeAllViews();
                }
            }

            @Override
            public void onComplete() {

            }
        });


    }

    private void showEmptyView() {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showEmptyView(R.drawable.ylc_quan, "怎么可以没有抵用券", "你值得拥有～", false, "");
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void showErrorView(String msg) {
        mIncList.setVisibility(View.GONE);
        ViewUtil instance = ViewUtil.getInstance(mContext);
        View empty = instance.showErrorView(R.drawable.ylc_nonet, msg, "", true, "刷新试试", this);
        contentView.addView(empty, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void qurryCount() {
        showLoading();
        Map<String, String> params = new HashMap<>();
        new WalletMode(mContext).getVocherCount(params, new ApiResultObserver<Num>(mContext) {
            @Override
            public void onComplete() {

            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }


            @Override
            public void onSuccess(Num apiResult) {
                tvCount.setText(apiResult.getNum());
                hideLoading();
            }

        });
    }

    @OnClick({R.id.btn_close, R.id.tv_exchange_commit, R.id.tv_go_grabvocher})
    public void onMoreClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                setRefreshMePage();
                finish();
                break;
            case R.id.tv_exchange_commit:
                String code = etExchange.getText().toString();
                if (TextUtils.isEmpty(code)) {
                    ToastUtils.showShortToast("请输入兑换码");
                    break;
                }
                Map<String, String> params = new HashMap<>();
                params.put(ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
                params.put(COUPON_NO, code);
                showLoading();
                new WalletMode(mContext).taoExchange(params, new ApiResultObserver<Result<String>>(mContext) {
                    @Override
                    public void onSuccess(Result<String> apiResult) {
                        hideLoading();
                        ToastUtils.showShortToast(apiResult.getResult());
                        qurryCount();
                        page = 1;
                        qurryVocherList();
                        isRefreshMePage = true;
                        etExchange.setText("");
                    }

                    @Override
                    public void onError(ApiException e) {
                        hideLoading();
                        ToastUtils.showShortToast(e.getMessage());
                    }

                    @Override
                    public void onComplete() {

                    }
                });

                break;
            case R.id.tv_go_grabvocher:
                startActivityForResult(new Intent(mContext, GrabVocherActivity.class), 1);
                break;
        }

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        setRefreshMePage();
    }

    private void setRefreshMePage(){
        if(isRefreshMePage){
            RouterModule.sendAdviceEvent("refreshMePage", true);
        }
    }

    private void maiDian() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C040);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            qurryVocherList();
        }

    }

    @OnCheckedChanged({R.id.rb_all, R.id.rb_used, R.id.rb_unuse})
    void onCheckChenge(RadioButton view, boolean checked) {
        if (checked) {
            switch (view.getId()) {
                case R.id.rb_used:
                    type = "use";
                    break;
                case R.id.rb_all:
                    type = "all";
                    break;
                case R.id.rb_unuse:
                    type = "noUse";
                    break;
            }
            page = 1;
            qurryVocherList();
        }
    }

    @Override
    public void onClick(View view) {
        qurryVocherList();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C040);
    }
}
