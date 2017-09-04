package com.ocj.oms.mobile.view;

import android.content.Context;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.BaseEventBean;
import com.ocj.oms.mobile.bean.CouponListBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.adapter.CouponAdapter;
import com.ocj.oms.utils.OCJPreferencesUtils;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static com.ocj.oms.mobile.ParamKeys.ACCESS_TOKEN;
import static com.ocj.oms.mobile.ParamKeys.CODE;

/**
 * Created by liutao on 2017/6/21.
 */

public class CouponLayout extends LinearLayout {

    @BindView(R.id.rv_list) RecyclerView rvList;
    @BindView(R.id.et_number) EditText etNumber;
    private Context mContext;
    private CouponAdapter adapter;
    private OnCloseClickListener onCloseClickListener;
    private List<CouponListBean> couponListBeen;

    public void setOnCloseClickListener(OnCloseClickListener onCloseClickListener) {
        this.onCloseClickListener = onCloseClickListener;
    }

    public CouponLayout(Context context) {
        super(context);
        mContext = context;
        init(mContext);
    }

    public void setCouponListBeen(List<CouponListBean> couponListBeen) {
        if (couponListBeen != null && couponListBeen.size() > 0) {
            this.couponListBeen.clear();
            this.couponListBeen.addAll(couponListBeen);
            adapter = new CouponAdapter(mContext, couponListBeen);
            adapter.setOnItemClickListener(new CouponAdapter.OnItemClickListener() {
                @Override
                public void onItemClick(int position) {
                    adapter.resetFlag(position);
                }
            });
            etNumber.clearFocus();

            LinearLayoutManager layoutManager = new LinearLayoutManager(mContext, LinearLayout.VERTICAL, false);
            rvList.setLayoutManager(layoutManager);
            rvList.setAdapter(adapter);
        }
    }

    private void init(Context mContext) {
        couponListBeen = new ArrayList<>();
        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.popupwindow_coupon_layout, null);
        ButterKnife.bind(this, view);
        this.addView(view);
    }

    @OnClick({R.id.iv_close, R.id.tv_confirm, R.id.tv_exchange})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_close:
                if (onCloseClickListener != null) {
                    onCloseClickListener.onCloseClick();
                }
                break;
            case R.id.tv_confirm:
                EventBus.getDefault().post(new BaseEventBean(IntentKeys.COUPON, adapter.getCurrentSelect()));
                if (onCloseClickListener != null) {
                    onCloseClickListener.onCloseClick();
                }
                break;
            case R.id.tv_exchange:
                String code = etNumber.getText().toString();
                if (TextUtils.isEmpty(code)) {
                    ToastUtils.showShortToast("请输入兑换码");
                    break;
                }
                Map<String, String> params = new HashMap<>();
                params.put(ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
                params.put(CODE, code);
                new WalletMode(mContext).drawCoupon(params, new ApiResultObserver<Result<String>>(mContext) {
                    @Override
                    public void onSuccess(Result<String> apiResult) {
                        ToastUtils.showShortToast(apiResult.getResult());
                    }

                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showShortToast(e.getMessage());
                    }

                    @Override
                    public void onComplete() {

                    }
                });
                break;
        }
    }

    public interface OnCloseClickListener {
        void onCloseClick();
    }
}
