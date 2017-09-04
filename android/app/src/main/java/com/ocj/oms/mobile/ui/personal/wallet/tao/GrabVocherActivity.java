package com.ocj.oms.mobile.ui.personal.wallet.tao;

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.TaoVocherBean;
import com.ocj.oms.mobile.bean.TaoVocherList;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import io.reactivex.ObservableSource;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * Created by yy on 2017/5/13.
 * <p>
 * 抢券
 */

public class GrabVocherActivity extends BaseActivity implements TaoVocherDetailsAdapter.OnObtainVocherListener {
    @BindView(R.id.rv_refresh) RecyclerView rvRefresh;
    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    private List<TaoVocherBean> datas = new ArrayList<>();
    private TaoVocherDetailsAdapter adapter;
    private int page;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_grab_vocher_layout;
    }

    @Override
    protected void initEventAndData() {
        page = 1;
        initPtr();
        initView();
        qurryVocherList();
    }

    private void initView() {
        rvRefresh.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new TaoVocherDetailsAdapter(mContext, datas);
        adapter.setListner(this);
        rvRefresh.setAdapter(adapter);
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
                return checkContentCanBePulledDown(frame, rvRefresh, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, rvRefresh, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                page = 1;
                qurryVocherList();
            }

        });
    }


    private void qurryVocherList() {

        new WalletMode(mContext).getTaoVocherList(page, new ApiResultObserver<TaoVocherList>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                mPtrFrame.refreshComplete();
                mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
            }

            @Override
            public void onSuccess(TaoVocherList apiResult) {
                showData(apiResult);

            }

            @Override
            public void onComplete() {

            }
        });


    }

    private void showData(TaoVocherList apiResult) {
        if (page == 1) {
            rvRefresh.scrollToPosition(0);
            datas.clear();
        }
        if (apiResult != null)
            datas.addAll(apiResult.getTaolist());
        adapter.notifyDataSetChanged();
        mPtrFrame.refreshComplete();

        if (page >= apiResult.getMaxPage()) {
            mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
        } else {
            mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);
        }
    }


    @OnClick({R.id.btn_close})
    public void onClick(View view) {
        finish();

    }


    /**
     * 点击领取抵用券
     *
     * @param bean
     */
    private void obtainVocher(TaoVocherBean bean) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.COUPON_NO, bean.getCOUPONNO());
        new WalletMode(mContext).taoDrawcoupon(params)
                .subscribeOn(Schedulers.newThread())
                .flatMap(new Function<ApiResult<Result<String>>, ObservableSource<ApiResult<TaoVocherList>>>() {

                    @Override
                    public ObservableSource<ApiResult<TaoVocherList>> apply(ApiResult<Result<String>> resultApiResult) throws Exception {
                        return new WalletMode(mContext).getTaoVocherList(page);
                    }
                })
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new ApiObserver<ApiResult<TaoVocherList>>(mContext) {


                    @Override
                    public void onNext(ApiResult<TaoVocherList> apiResult) {
                        ToastUtils.showShortToast("抢券成功！");
                        showData(apiResult.getData());
                    }

                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showShortToast(e.getMessage());
                    }

                });


    }

    @Override
    public void onVocherObtain(TaoVocherBean bean) {
        obtainVocher(bean);
    }
}
