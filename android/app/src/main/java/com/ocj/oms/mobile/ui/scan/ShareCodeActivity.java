package com.ocj.oms.mobile.ui.scan;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.widget.Button;
import android.widget.ImageView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/11.
 */

public class ShareCodeActivity extends BaseActivity {

    @BindView(R.id.iv_code) ImageView ivCode;
    @BindView(R.id.btn_scan) Button btnScan;
    @BindView(R.id.iv_back) ImageView ivBack;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_share_code;
    }

    @Override
    protected void initEventAndData() {


    }

    @OnClick(R.id.iv_back)
    public void setIvBack() {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C070D003001C003001);
        finish();
    }

    @OnClick(R.id.btn_scan)
    public void onViewClicked() {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C070F008001O008001);
        finish();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {

            for (int i = 0; i < permissions.length; i++) {
                if (permissions[i].equals(Manifest.permission.CAMERA)) {
                    if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                        Intent intent = new Intent(this, ScannerActivity.class);
                        startActivity(intent);
                    } else {
                        ToastUtils.showShortToast("请打开相机权限");
                    }
                }
            }
        }
    }


}
