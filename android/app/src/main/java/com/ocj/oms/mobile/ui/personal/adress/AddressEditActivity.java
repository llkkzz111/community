package com.ocj.oms.mobile.ui.personal.adress;

import android.content.Intent;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.ReceiversBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.http.service.address.AddressModel;
import com.ocj.oms.mobile.ui.safty.SelectAreaActivity;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/22.
 * <p>
 * 新增收货地址
 */

public class AddressEditActivity extends BaseActivity {

    boolean isSave = false;

    @BindView(R.id.btn_save) TextView btnSave;
    @BindView(R.id.rl_default) RelativeLayout rlDefault;
    @BindView(R.id.tv_save) TextView tvSave;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.tv_delete) TextView tvDelete;
    @BindView(R.id.et_name) ClearEditText etName;
    @BindView(R.id.et_mobile) ClearEditText etMobile;
    @BindView(R.id.tv_area) TextView tvArea;
    @BindView(R.id.et_address) EditText etAddress;
    @BindView(R.id.switch_default) Switch switchDefault;

    ReceiversBean bean;
    String privinId = "";
    String cityId = "";
    String arenId = "";
    private String isDefault = "0";

    @Override
    protected int getLayoutId() {
        return R.layout.activity_add_adress_layout;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        String str = intent.getStringExtra(IntentKeys.SELECTNAME);
        tvArea.setText(str);
        privinId = intent.getStringExtra(IntentKeys.PRIVIN_ID);
        cityId = intent.getStringExtra(IntentKeys.CITY_ID);
        arenId = intent.getStringExtra(IntentKeys.AREA_ID);
    }

    @Override
    protected void initEventAndData() {
        initView();
    }

    private void initView() {
        switchDefault.setChecked(isDefault.equals("1"));
        if (getIntent().hasExtra(IntentKeys.ADDRESS_ADD)) {
            tvTitle.setText("添加收货地址");
            tvDelete.setVisibility(View.GONE);
            // rlDefault.setVisibility(View.GONE);
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C063);

        } else {
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C064);
            tvTitle.setText("编辑收货地址");
            tvDelete.setVisibility(View.VISIBLE);
            bean = (ReceiversBean) getIntent().getSerializableExtra(IntentKeys.ADDRESS_BEAN);
            if (null != bean) {
                etName.setText(bean.getReceiver_name());
                etMobile.setText(bean.getReceiver_hp1() + bean.getReceiver_hp2() + bean.getReceiver_hp3());
                tvArea.setText(bean.getAddr_m());
                etAddress.setText(bean.getReceiver_addr());
                privinId = bean.getArea_lgroup();
                cityId = bean.getArea_mgroup();
                arenId = bean.getArea_sgroup();
                isDefault = bean.getDefault_yn();
                switchDefault.setChecked(isDefault.equals("1"));
            }
        }
    }

    @OnClick({R.id.btn_close, R.id.tv_save, R.id.btn_save, R.id.tv_area, R.id.tv_delete})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                checkDialog();
                break;
            case R.id.btn_save:
            case R.id.tv_save:
                Map<String, String> params = checkInput();
                if (params == null) {
                    return;
                }
                if (getIntent().hasExtra(IntentKeys.ADDRESS_ADD)) {
                    addAddress(params);
                } else {
                    editAddress(params);
                }
                break;
            case R.id.tv_area:
                if (getIntent().hasExtra(IntentKeys.ADDRESS_ADD)) {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C063D010001C010001);
                } else {
                    OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C064D010001C010001);
                }
                Intent intent = new Intent(mContext, SelectAreaActivity.class);
                intent.putExtra(IntentKeys.FROM_ADDRESS, "");
                startActivity(intent);
                break;
            case R.id.tv_delete:
                deleteAddress();
                break;
        }
    }

    @Override
    public void onBackPressed() {
        checkDialog();
    }

    private void checkDialog() {
        if (!getIntent().hasExtra(IntentKeys.ADDRESS_ADD)) {
            if (!isSave) {
                DialogFactory.showNoIconDialog("信息还未保存，确认现在返回吗？", "取消", "确认", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        finish();
                    }
                }).show(getFragmentManager(), "edit");
            }
            OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C064C005001C003001);
        } else {
            OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C063C005001C003001);
            finish();
        }
    }

    private void deleteAddress() {
        showLoading();
        Map<String, String> deleteParams = new HashMap<>();
        deleteParams.put(ParamKeys.ADDRESS_ID, bean.getReceivermanage_seq());
        new AddressModel(mContext).deleteReceiver(deleteParams, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast("删除失败");
            }

            @Override
            public void onSuccess(Result<String> apiResult) {
                hideLoading();
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C064F008001O008001);
                ToastUtils.showShortToast("删除成功");
                finish();
            }
        });
    }

    private void editAddress(Map<String, String> params) {
        showLoading();
        if (params == null) return;
        params.put(ParamKeys.ADDRESS_ID, bean.getReceivermanage_seq());
        new AddressModel(mContext).editReceiver(params, new ApiResultObserver<ReceiversBean>(mContext) {
            @Override
            public void onSuccess(ReceiversBean apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C064C005001A001001);
                hideLoading();
                isSave = true;
                ToastUtils.showShortToast("地址修改成功");
                Intent intent = new Intent();
                intent.setAction(IntentKeys.Fresh_ADESS);
                sendBroadcast(intent);
                finish();
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }

    @OnCheckedChanged(R.id.switch_default)
    void onCheckChenge(boolean isChecked) {
        if (isChecked) {
            isDefault = "1";
        } else {
            isDefault = "0";
        }
    }

    private void addAddress(Map<String, String> params) {
        showLoading();
        if (params == null) return;
        new AddressModel(mContext).addReceiver(params, new ApiResultObserver<ReceiversBean>(mContext) {
            @Override
            public void onSuccess(ReceiversBean apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C063C005001A001001);
                hideLoading();
                ToastUtils.showShortToast("地址添加成功");
                Intent intent = new Intent();
                intent.setAction(IntentKeys.Fresh_ADESS);
                sendBroadcast(intent);
                finish();
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }

    @Nullable
    private Map<String, String> checkInput() {
        String mobile = etMobile.getText().toString();
        String name = etName.getText().toString();
        String area = tvArea.getText().toString();
        String address = etAddress.getText().toString();
        if (TextUtils.isEmpty(name)) {
            ToastUtils.showShortToast("请输入收货人姓名");
            return null;
        }
        if (TextUtils.isEmpty(mobile)) {
            ToastUtils.showShortToast("请输入手机号");
            return null;
        }
        if (TextUtils.isEmpty(area)) {
            ToastUtils.showShortToast("请选择地区");
            return null;
        }
        if (TextUtils.isEmpty(address)) {
            ToastUtils.showShortToast("请输入具体地址");
            return null;
        }
        if (etAddress.getText().length() < 5) {
            ToastUtils.showShortToast("详细地址地址不能少于5个字符");
            return null;
        }

        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.IS_DEFAULT_ADDR, switchDefault.isChecked() ? "1" : "0");
        params.put(ParamKeys.RECEIVER, name);
        params.put(ParamKeys.PHONE, mobile);
        params.put(ParamKeys.MOBILE, mobile);
        params.put(ParamKeys.PROVINCE, privinId);
        params.put(ParamKeys.CITY, cityId);
        params.put(ParamKeys.STRICT, arenId);
        params.put(ParamKeys.STREET_ADDRESS, address);
        return params;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (getIntent().hasExtra(IntentKeys.ADDRESS_ADD))
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C063);
        else
            OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C064);
    }
}
