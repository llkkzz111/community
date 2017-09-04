package com.ocj.oms.mobile.ui.register;

import android.content.Context;
import android.text.TextUtils;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.basekit.presenter.BasePresenter;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.service.ApiService;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.bean.VerifyBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.utils.OCJPreferencesUtils;

import java.util.HashMap;
import java.util.Map;


/**
 * Created by liuzhao on 2017/4/12.
 */

public class RegisterPresenter extends BasePresenter<RigesterContract.View> implements RigesterContract.Presenter {

    private Context context;
    AccountMode accountMode;
    private String internetID;

    public RegisterPresenter(Context mContext, RigesterContract.View view) {
        this.view = view;
        this.context = mContext;
        accountMode = new AccountMode(context);
    }


    @Override
    public void rigsterCommit(String thirdPartyID, final String mobile, final String code, final String pwd) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, mobile);
        params.put(ParamKeys.VERIFY_CODE, code);
        params.put(ParamKeys.NEW_PASSWORD, pwd);
        params.put(ParamKeys.INTERNAT_ID, internetID);
        if (!TextUtils.isEmpty(thirdPartyID)) {
            params.put(ParamKeys.ASSOCIATE_STATE, thirdPartyID);
        }
        accountMode.rapidRigester(params, new ApiResultObserver<UserInfo>(context) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onSuccess(UserInfo apiResult) {
                OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                OCJPreferencesUtils.setCustName(apiResult.getCust_name());
                OCJPreferencesUtils.setCustNo(apiResult.getCust_no());
                OCJPreferencesUtils.setLoginType("3");
                OCJPreferencesUtils.setVisitor(false);
                OCJPreferencesUtils.setLoginID(mobile);
                view.succed(apiResult);
            }

            @Override
            public void onComplete() {

            }
        });
    }

    @Override
    public void sendMobileCode(String phone, String purpose) {
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.MOBILE, phone);
        params.put(ParamKeys.PURPOSE, ApiService.SMS_PURPOSE_QUICK_REGISTER);
        new AccountMode(context).getVerifyCode(params, new ApiObserver<ApiResult<VerifyBean>>(context) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<VerifyBean> result) {
                if (null == result || result.getCode() != 200) {
                    ToastUtils.showLongToast("验证码发送失败！");
                    return;
                }
                internetID = result.getData().getInternetId();
                ToastUtils.showLongToast("验证码发送成功");
                view.showTimmer(result.getData().getVerifyode());
            }

            @Override
            public void onComplete() {

            }
        });


    }


}
