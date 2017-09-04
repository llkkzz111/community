package com.ocj.oms.mobile.ui.scan;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.widget.Button;
import android.widget.ImageView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.zxing.activity.CaptureActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/11.
 */
@Route(path = RouterModule.AROUTER_PATH_SWEEP)
public class ScannerActivity extends BaseActivity {


    private static final int CAMERA_SETTING = 20;
    @BindView(R.id.btn_share) Button btnShare;
    @BindView(R.id.iv_back) ImageView ivBack;
    private AlertDialog dialog;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_scanner_layout;
    }

    @Override
    protected void initEventAndData() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (this.checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.CAMERA}, 1);
            } else {
                Intent intent = new Intent();
                intent.setClass(ScannerActivity.this, CaptureActivity.class);
                startActivity(intent);
                finish();
            }
        } else {
            Intent intent = new Intent();
            intent.setClass(ScannerActivity.this, CaptureActivity.class);
            startActivity(intent);
            finish();
        }
    }


    @OnClick(R.id.iv_back)
    public void setIvBack() {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C069D003001C003001);
        finish();
    }

    @OnClick(R.id.btn_share)
    public void onViewClicked() {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C069F008001O008001);
        Intent intent = new Intent(this, ShareCodeActivity.class);
        startActivity(intent);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {

            for (int i = 0; i < permissions.length; i++) {
                if (permissions[i].equals(Manifest.permission.CAMERA)) {
                    if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                        Intent intent = new Intent(this, CaptureActivity.class);
                        startActivity(intent);
                        finish();
                    } else {
                        showDialogTipUserGoToAppSettting("权限不可用", "请在-应用设置-权限-中，允许东方购物使用");
                    }
                }
            }
        }
    }

    // 提示用户去应用设置界面手动开启权限
    private void showDialogTipUserGoToAppSettting(String title, String message) {
        dialog = new AlertDialog.Builder(this)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton("立即开启", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        // 跳转到应用设置界面
                        goToAppSetting();
                        dialog.dismiss();
                    }
                })
                .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        finish();
                    }
                }).setCancelable(false).show();

    }

    // 跳转到当前应用的设置界面
    private void goToAppSetting() {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", getPackageName(), null);
        intent.setData(uri);
        startActivityForResult(intent, CAMERA_SETTING);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CAMERA_SETTING) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // 检查该权限是否已经获取权限是否已经 授权 GRANTED---授权  DINIED---拒绝
                showDialogTipUserGoToAppSettting("权限不可用", "请在-应用设置-权限-中，允许东方购物使用");
            }
        }
    }
}
