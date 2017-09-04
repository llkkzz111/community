package com.ocj.oms.mobile.ui.safty;

import android.content.Context;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.basekit.presenter.BasePresenter;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.bean.ItemsBean;
import com.ocj.oms.mobile.bean.TvSafeVerifyBean;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.register.SecurityCheckContract;

import java.util.List;
import java.util.Map;

/**
 * Created by yy on 2017/5/15.
 */

public class SecurityCheckPresenter extends BasePresenter<SecurityCheckContract.View> implements SecurityCheckContract.Presenter {

    private Context context;
    AccountMode accountMode;

    public SecurityCheckPresenter(Context mContext, SecurityCheckContract.View view) {
        this.view = view;
        this.context = mContext;
        accountMode = new AccountMode(context);
    }


    @Override
    public void getImgList(String menberId) {
        new AccountMode(context).getTvUserSafeImglist(menberId, "s", new ApiObserver<ApiResult<TvSafeVerifyBean>>(context) {
            @Override
            public void onError(ApiException e) {
                view.onVerifyFail(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<TvSafeVerifyBean> result) {
                if (result.getData() == null) {
                    ToastUtils.showLongToast("没有获取到数据");
                    return;
                }
                List<ItemsBean> datas = result.getData().getItemList();
                if (null == datas || datas.size() == 0) {
                    ToastUtils.showLongToast("没有获取到数据");
                    return;
                }
                view.showList(datas);
            }

            @Override
            public void onComplete() {

            }
        });


    }

    @Override
    public void commitTvUserVerfy(Map<String, String> param) {
        new AccountMode(context).tvUserSafeLogin(param, new ApiObserver<ApiResult<UserInfo>>(context) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<UserInfo> apiResult) {
                view.onVerifySucced(apiResult.getData());
            }

            @Override
            public void onComplete() {

            }
        });
    }
}
