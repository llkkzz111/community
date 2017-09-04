package com.ocj.oms.mobile.ui.personal.setting;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.safty.SelectAreaActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import io.reactivex.annotations.NonNull;

/**
 * 设置默认地址
 * Created by yy on 2017/8/1.
 */

public class SetDefaultAdressActivity extends BaseActivity {

    @BindView(R.id.tv_area) TextView tvArean;

    @BindView(R.id.iv_house) ImageView house;
    @BindView(R.id.iv_company) ImageView company;
    @BindView(R.id.et_address) EditText areaDetail;


    //默认是 10.住宅 20.公司
    String addressType = "10";
    String privinId = "", cityId = "", arenId = "";

    @Override
    protected int getLayoutId() {
        return R.layout.activity_set_def_adress_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C066);
        tvArean.setText(getIntent().getStringExtra(IntentKeys.ADDRESS));
        if (!TextUtils.isEmpty(getIntent().getStringExtra(IntentKeys.ADDRESS_DETAIL))) {
            areaDetail.setText(getIntent().getStringExtra(IntentKeys.ADDRESS_DETAIL));
        }
        initView();
    }

    private void initView() {
        privinId = getIntent().getStringExtra(ParamKeys.PROVINCE);
        cityId = getIntent().getStringExtra(ParamKeys.CITY);
        arenId = getIntent().getStringExtra(ParamKeys.AREA);
        addressType = getIntent().getStringExtra(ParamKeys.PLACE_GB);
        if (addressType.equals("10")) {
            house.setBackgroundResource(R.drawable.icon_checkbox_checked_bg);
            company.setBackgroundResource(R.drawable.icon_checkbox_normal_bg);
        } else {
            house.setBackgroundResource(R.drawable.icon_checkbox_normal_bg);
            company.setBackgroundResource(R.drawable.icon_checkbox_checked_bg);
        }


    }

    @OnClick(R.id.btn_close)
    public void onClick(View view) {
        finish();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        String str = intent.getStringExtra(IntentKeys.SELECTNAME);
        tvArean.setText(str);
        privinId = intent.getStringExtra(IntentKeys.PRIVIN_ID);
        cityId = intent.getStringExtra(IntentKeys.CITY_ID);
        arenId = intent.getStringExtra(IntentKeys.AREA_ID);
    }


    @OnClick(R.id.ll_setarea)
    public void onClickArea(View view) {
        Intent intent = new Intent(mContext, SelectAreaActivity.class);
        intent.putExtra(IntentKeys.FROM_DEFAULT_ADDRESS, "");
        startActivity(intent);
    }

    @OnClick({R.id.iv_house, R.id.iv_company})
    public void onRadioClick(View view) {
        switch (view.getId()) {
            case R.id.iv_house:
                resetView();
                house.setBackgroundResource(R.drawable.icon_checkbox_checked_bg);
                addressType = "10";
                break;
            case R.id.iv_company:
                resetView();
                company.setBackgroundResource(R.drawable.icon_checkbox_checked_bg);
                addressType = "20";
                break;

        }
    }

    @OnClick(R.id.btn_set_address)
    public void onCommitClick(View view) {
        if (TextUtils.isEmpty(tvArean.getText())) {
            ToastUtils.showLongToast("请选择地区");
            return;
        }
        if (TextUtils.isEmpty(areaDetail.getText())) {
            ToastUtils.showLongToast("请输入详细地址");
            return;
        }
        doCommit();

    }

    /**
     * 提交请求
     */
    private void doCommit() {
        Map<String, String> param = new HashMap<String, String>();
        param.put(ParamKeys.PROVINCE, privinId);
        param.put(ParamKeys.CITY, cityId);
        param.put(ParamKeys.AREA, arenId);
        param.put(ParamKeys.ADDR, areaDetail.getText().toString());
        param.put(ParamKeys.PLACE_GB, addressType);
        new AccountMode(mContext).editUserStationCode(param, new ApiObserver<ApiResult<Object>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(@NonNull ApiResult<Object> result) {
                if (result.getCode() == 200) {
                    ToastUtils.showLongToast("修改成功");
                    //发通知更新 个人中心的默认地址
                    Intent intent = new Intent();
                    intent.setAction(IntentKeys.FRESH_PROFILE);
                    sendBroadcast(intent);
//                    setResult(RESULT_OK);
                    finish();
                }

            }
        });


    }


    private void resetView() {
        house.setBackgroundResource(R.drawable.icon_checkbox_normal_bg);
        company.setBackgroundResource(R.drawable.icon_checkbox_normal_bg);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C066);
    }


}
