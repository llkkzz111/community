package com.ocj.oms.mobile.ui.sign;

import android.support.annotation.IdRes;
import android.support.v7.widget.AppCompatButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.LotteryListBean;
import com.ocj.oms.mobile.bean.LotteryListDataBean;
import com.ocj.oms.mobile.bean.OcustBean;
import com.ocj.oms.mobile.bean.SignBean;
import com.ocj.oms.mobile.bean.SignDetailBean;
import com.ocj.oms.mobile.bean.SignPacksBean;
import com.ocj.oms.mobile.bean.SignPacksListBean;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.adapter.LotteryAdapter;
import com.ocj.oms.mobile.ui.adapter.SignPacksAdapter;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.view.SignView;
import com.ocj.oms.utils.OCJPreferencesUtils;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import io.reactivex.annotations.NonNull;

/**
 * Created by shizhang.cai on 2017/6/11.
 */
@Route(path = RouterModule.AROUTER_PATH_SIGN)
public class SignActivity extends BaseActivity {

    @BindView(R.id.ptr_view)
    PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.btn_sign)
    AppCompatButton btnSign;
    @BindView(R.id.sv_layout)
    SignView svLayout;
    @BindView(R.id.rv_list)
    RecyclerView rvList;
    @BindView(R.id.rg_select_pay)
    RadioGroup select;
    @BindView(R.id.tv_sign_days)
    TextView tvSignDays;
    @BindView(R.id.tv_points)
    TextView tvPoints;
    @BindView(R.id.drl_layout)
    DragRelativeLayout dragLayout;
    @BindView(R.id.ll_empty)
    LinearLayout llEmpty;

    private List<LotteryListDataBean> lotteryData;
    private List<OcustBean> signPacksData;
    private LotteryAdapter lotteryAdapter;
    private SignPacksAdapter signPacksAdapter;
    private LotteryDialog lotteryDialog;

    private int days = 0;
    private SignDetailBean signDetailBean;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_sign_layout;
    }

    @Override
    protected void initEventAndData() {
        dragLayout.initView();
        lotteryData = new ArrayList<>();
        signPacksData = new ArrayList<>();
        lotteryAdapter = new LotteryAdapter(mContext, lotteryData);
        signPacksAdapter = new SignPacksAdapter(mContext, signPacksData);
        LinearLayoutManager layoutManager = new LinearLayoutManager(mContext, LinearLayout.VERTICAL, false);
        rvList.setLayoutManager(layoutManager);
        rvList.setAdapter(lotteryAdapter);

        select.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                switch (checkedId) {
                    case R.id.rb_all:
                        getLotteryList();
                        break;
                    case R.id.rb_unuse:
                        getSignPacksList();
                        break;
                }
            }
        });
        lotteryDialog = new LotteryDialog(mContext);
        lotteryDialog.setOnLotteryButtonClickListener(new LotteryDialog.OnLotteryButtonClickListener() {
            @Override
            public void onConfirmClick(String name, String id, String phone) {
                signGetLottery(name, id, phone);
            }

            @Override
            public void onCancelClick() {
                lotteryDialog.dismiss();
            }
        });
        svLayout.setOnItemClickListener(new SignView.OnItemClickListener() {
            @Override
            public void onFifteenClick() {
                if (signDetailBean != null && days >= 15 && equalsTwo(signDetailBean.getFctG(), "fctn")) {
                    lotteryDialog.show();
                }
            }

            @Override
            public void onTwentyClick() {
                if (signDetailBean != null && days >= 20 && equalsTwo(signDetailBean.getLiBaoYn(), "libaon")) {
                    signGetPacks();
                }
            }
        });
        getSignDetail();
        getLotteryList();
        initPtr();
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {

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
                if (select.getCheckedRadioButtonId() == R.id.rb_all) {
                    getLotteryList();
                } else {
                    getSignPacksList();
                }
            }

        });
    }

    private void signGetLottery(String name, String id, String phone) {
        new AccountMode(mContext).signGetLottery(name, phone, id, OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<String>(mContext) {
            @Override
            public void onSuccess(String apiResult) {
                if (signDetailBean != null) {
                    signDetailBean.setFctYn("fctY");
                    svLayout.setLottery(true);
                }
                lotteryDialog.dismiss();
                getLotteryList();
                showTipsDialog();
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }

    private void signGetPacks() {
        new AccountMode(mContext).signGetPacks(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignPacksBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<SignPacksBean> resultApiResult) {
                if (signDetailBean != null) {
                    signDetailBean.setFctYn("libaoY");
                    svLayout.setSignPacks(true);
                }
                showTipsDialog();
                getSignPacksList();
            }
        });
    }

    private void sign() {
        new AccountMode(mContext).sign(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<SignBean> signBeanApiResult) {
                EventBus.getDefault().post(IntentKeys.SIGN_SUCCESS);
                days = signBeanApiResult.getData().getDays();
                svLayout.setCurrentPosition(days);
                tvSignDays.setText(String.format("%s", days + ""));
                btnSign.setText("已签到");
                btnSign.setBackgroundResource(R.drawable.bg_white_line);
                btnSign.setTextColor(getResources().getColor(R.color.white));
                btnSign.setEnabled(false);
            }
        });
    }

    private void showTipsDialog() {
        DialogFactory.showNoIconDialog(getString(R.string.sign_string), null, "确认", new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        }).show(getFragmentManager(), "edit");
    }

    private void getSignDetail() {
        showLoading();
        new AccountMode(mContext).signDetail(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignDetailBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onNext(ApiResult<SignDetailBean> signDetailBeanApiResult) {
                hideLoading();
                signDetailBean = signDetailBeanApiResult.getData();
                days = signDetailBean.getMonthDay();
                svLayout.setCurrentPosition(days, equalsTwo(signDetailBean.getFctG(), "fcty"), equalsTwo(signDetailBean.getLiBaoYn(), "libaoy"));
                tvSignDays.setText(String.format(" %s ", days + ""));
                tvPoints.setText(String.format(" %s ", signDetailBean.getOpoint_money()));
                if (equalsTwo(signDetailBean.getSignYn(), "todayy")) {
                    btnSign.setText("已签到");
                    btnSign.setBackgroundResource(R.drawable.bg_white_line);
                    btnSign.setTextColor(getResources().getColor(R.color.white));
                    btnSign.setEnabled(false);
                } else if (equalsTwo(signDetailBean.getSignYn(), "todayn")) {

                    btnSign.setText("签到得好礼");
                    btnSign.setBackgroundResource(R.drawable.bg_red_packet_tip);
                    btnSign.setTextColor(getResources().getColor(R.color.text_red_ed1c41));
                    btnSign.setEnabled(true);
                }
            }
        });
    }

    private void getLotteryList() {
        new AccountMode(mContext).getLotteryList(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<LotteryListBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onNext(@NonNull ApiResult<LotteryListBean> apiResult) {
                if (TextUtils.isEmpty(apiResult.getData().getDataOK())) {
                    rvList.setVisibility(View.GONE);
                    llEmpty.setVisibility(View.VISIBLE);
                } else {
                    rvList.setVisibility(View.VISIBLE);
                    llEmpty.setVisibility(View.GONE);
                }
                if (!TextUtils.isEmpty(apiResult.getData().getDataOK())) {
                    lotteryData.clear();
                    try {
                        List<LotteryListDataBean> lotteryListBeen = new Gson().fromJson(apiResult.getData().getDataOK(),
                                new TypeToken<ArrayList<LotteryListDataBean>>() {
                                }.getType());
                        lotteryData.addAll(lotteryListBeen);
                    } catch (JsonSyntaxException e) {
                        e.printStackTrace();
                    }
                }
                lotteryAdapter.notifyDataSetChanged();
                if (select.getCheckedRadioButtonId() == R.id.rb_all) {
                    rvList.setAdapter(lotteryAdapter);
                }
                mPtrFrame.refreshComplete();
            }
        });
    }

    private void getSignPacksList() {
        new AccountMode(mContext).getSignPacksList(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignPacksListBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onNext(@NonNull ApiResult<SignPacksListBean> signPacksListBeanApiResult) {
                if (signPacksListBeanApiResult.getData().getOcust() == null || signPacksListBeanApiResult.getData().getOcust().size() <= 0) {
                    rvList.setVisibility(View.GONE);
                    llEmpty.setVisibility(View.VISIBLE);
                } else {
                    rvList.setVisibility(View.VISIBLE);
                    llEmpty.setVisibility(View.GONE);
                }
                if (signPacksListBeanApiResult.getData().getOcust() != null) {
                    signPacksData.clear();
                    signPacksData.addAll(signPacksListBeanApiResult.getData().getOcust());
                }
                signPacksAdapter.notifyDataSetChanged();
                if (select.getCheckedRadioButtonId() == R.id.rb_unuse) {
                    rvList.setAdapter(signPacksAdapter);
                }
                mPtrFrame.refreshComplete();
            }
        });
    }


    @OnClick({R.id.btn_sign, R.id.btn_close})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_sign:
                sign();
                break;
            case R.id.btn_close:
                finish();
                break;
        }
    }

}
