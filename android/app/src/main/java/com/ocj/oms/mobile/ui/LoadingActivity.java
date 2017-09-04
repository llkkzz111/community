package com.ocj.oms.mobile.ui;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.annotation.RequiresApi;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.blankj.utilcode.utils.LogUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.BuildConfig;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.App;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.CheckToken;
import com.ocj.oms.mobile.bean.HotCityBean;
import com.ocj.oms.mobile.bean.ResultBean;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.rn.RNActivity;
import com.ocj.oms.mobile.utils.GetLoactionUtils;
import com.ocj.oms.rn.ReactNativePreLoader;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

import static android.Manifest.permission.ACCESS_FINE_LOCATION;
import static android.Manifest.permission.READ_PHONE_STATE;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;


public class LoadingActivity extends BaseActivity {
    private static final int MY_PERMISSIONS_REQUEST_CALL_PHONE = 1;
    private static final int ENTER_DELAY_TIME = 2;
    private String[] permissions = {READ_PHONE_STATE, WRITE_EXTERNAL_STORAGE, ACCESS_FINE_LOCATION};
    private AlertDialog dialog;
    public static int OVERLAY_PERMISSION_REQ_CODE = 1234;
    private AMapLocationClient locationClient;
    private AMapLocationClientOption locationOption;
    private ResultBean localBean;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_loading_activity;
    }

    @Override
    protected void initEventAndData() {
        // 版本判断。当手机系统大于 23 时，才有必要去判断权限是否获取
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            //打开悬浮窗
            askOverlayPermission();
        } else {
            initToken();
        }

    }

    private void initToken() {
        setRnPreLoad();
        if (TextUtils.isEmpty(OCJPreferencesUtils.getAccessToken())) {
            initLocation();
        } else {
            checkToken();
        }
    }

    public void setRnPreLoad() {
        //预加载RNRootView
        ReactNativePreLoader.preLoad(App.getInstance(), "HotRN");
    }

    // 开始提交请求权限
    private void startRequestPermission() {
        ActivityCompat.requestPermissions(this, permissions, MY_PERMISSIONS_REQUEST_CALL_PHONE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == MY_PERMISSIONS_REQUEST_CALL_PHONE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (grantResults.length == 0) {
                    showDialog();
                    return;
                }

                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    // 判断用户是否 点击了不再提醒。(检测该权限是否还可以申请)
                    boolean b = shouldShowRequestPermissionRationale(permissions[0]);
                    if (grantResults.length > 1)
                        b = b ? b : shouldShowRequestPermissionRationale(permissions[1]);
                    if (b) {
                        // 用户还是想用我的 APP 的
                        // 提示用户去应用设置界面手动开启权限
                        startRequestPermission();
                    } else {
                        showDialog();
                    }
                } else {
                    initToken();
                }
            }
        }

    }

    // 跳转到当前应用的设置界面
    private void goToAppSetting() {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", getPackageName(), null);
        intent.setData(uri);
        startActivityForResult(intent, MY_PERMISSIONS_REQUEST_CALL_PHONE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == MY_PERMISSIONS_REQUEST_CALL_PHONE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // 检查该权限是否已经获取权限是否已经 授权 GRANTED---授权  DINIED---拒绝
                showDialog();
            }
        }
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.canDrawOverlays(this)) {
                    ToastUtils.showShortToast("权限授予失败，无法开启悬浮窗");
                    finish();
                } else {
                    // 检查该权限是否已经获取如果没有授予该权限，就去提示用户请求
                    startRequestPermission();
                }
            }
        }
        if (requestCode == 200 && resultCode == Activity.RESULT_OK) {
            localBean = (ResultBean) data.getSerializableExtra("location");
            OCJPreferencesUtils.setRegion(localBean.getRegion_cd());
            OCJPreferencesUtils.setSelRegion(localBean.getSel_region_cd());
            OCJPreferencesUtils.setSubstation(localBean.getCode_mgroup());
            getVisitToken(localBean);
        }

    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public void askOverlayPermission() {
//        if (!Settings.canDrawOverlays(LoadingActivity.this)) {
//            ToastUtils.showShortToast("请开启悬浮窗权限!");
//            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + getPackageName()));
//            startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE);
//        } else {
        // 检查该权限是否已经获取
        // 权限是否已经 授权 GRANTED---授权  DINIED---拒绝
        // 如果没有授予该权限，就去提示用户请求
        startRequestPermission();
//        }
    }

    private void showDialog() {
        if (ContextCompat.checkSelfPermission(this, permissions[0]) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, permissions[1]) == PackageManager.PERMISSION_GRANTED) {
            if (dialog != null && dialog.isShowing()) {
                dialog.dismiss();
            }
            initToken();
        } else if (ContextCompat.checkSelfPermission(this, permissions[0]) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, permissions[1]) != PackageManager.PERMISSION_GRANTED) {
            showDialogTipUserGoToAppSettting("权限不可用", "请在-应用设置-权限-中，允许东方购物使用");
        } else if (ContextCompat.checkSelfPermission(this, permissions[0]) != PackageManager.PERMISSION_GRANTED) {
            // 提示用户应该去应用设置界面手动开启权限
            showDialogTipUserGoToAppSettting("手机状态不可用", "请在-应用设置-权限-中，允许东方购物使用");
        } else if (ContextCompat.checkSelfPermission(this, permissions[1]) != PackageManager.PERMISSION_GRANTED) {
            showDialogTipUserGoToAppSettting("存储权限不可用", "请在-应用设置-权限-中，允许东方购物使用");
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


    private void initLocation() {
        //初始化client
        locationClient = new AMapLocationClient(this.getApplicationContext());
        locationOption = GetLoactionUtils.getDefaultOption();
        locationOption.setOnceLocation(true);
        // 设置定位监听
        locationClient.setLocationListener(locationListener);
        //根据控件的选择，重新设置定位参数
        locationClient.setLocationOption(locationOption);
        // 启动定位
        locationClient.startLocation();
    }

    /**
     * 定位监听
     */
    AMapLocationListener locationListener = new AMapLocationListener() {
        @Override
        public void onLocationChanged(AMapLocation location) {
            if (null != location) {
                //errCode等于0代表定位成功，其他的为定位失败，具体的可以参照官网定位错误码说明
                if (location.getErrorCode() == 0) {

                    //埋点地区
                    Map<String, Object> parameters = new HashMap<>();
                    parameters.put("province", location.getProvince());
                    parameters.put("city", location.getCity());
                    parameters.put("area", location.getDistrict());
                    parameters.put("street", location.getStreet());
                    parameters.put("longitude", location.getLongitude() + "");
                    parameters.put("dimension", location.getLatitude() + "");
                    OcjStoreDataAnalytics.trackEvent(mContext, "AP1706C099D003001C009999", null, parameters);
                    //定位完成的时间
                    if (location.getProvince().equals("")) {
                        getVisitToken(localBean);
                    } else {
                        afterLocation(location.getProvince());
                        locationClient.stopLocation();
                    }

                } else {
                    //定位失败
                    startLocaleActivity();
                }
            } else {
                getVisitToken(localBean);
            }
        }
    };

    private void startLocaleActivity() {
        Intent intent = new Intent(mContext, LocaleActivity.class);
        intent.putExtra(IntentKeys.FROM, "RNActivity");
        startActivityForResult(intent, 200);
    }


    private void afterLocation(final String loaction) {
        //热门地区
        new ItemsMode(mContext).getHotCity(new ApiResultObserver<HotCityBean>(mContext) {
            @Override
            public void onSuccess(HotCityBean apiResult) {
                LogUtils.d("onSuccess:" + apiResult.toString());
                for (int i = 0; i < apiResult.getResult().size(); i++) {
                    ResultBean resultbean = apiResult.getResult().get(i);
                    if (loaction.startsWith(resultbean.getCode_name())) {
                        localBean = resultbean;
                        OCJPreferencesUtils.setRegion(resultbean.getRegion_cd());
                        OCJPreferencesUtils.setSelRegion(resultbean.getSel_region_cd());
                        OCJPreferencesUtils.setSubstation(resultbean.getCode_mgroup());
                        break;
                    }
                }
                getVisitToken(localBean);
            }

            @Override
            public void onError(ApiException e) {
                getVisitToken(localBean);
            }
        });


    }


    private void checkToken() {
        new AccountMode(mContext).checkToken(OCJPreferencesUtils.getAccessToken(),
                new ApiResultObserver<CheckToken>(mContext) {
                    @Override
                    public void onError(ApiException e) {
                        getVisitToken(localBean);
                    }

                    @Override
                    public void onSuccess(CheckToken apiResult) {
                        if (!apiResult.isIsVisitor() && !TextUtils.isEmpty(apiResult.getCust_no())) {
                            getAccessTokens();
                        } else {
                            getVisitToken(localBean);
                        }
                    }
                });
    }


    private void getVisitToken(ResultBean resultBean) {

        if (resultBean == null) {
            String local = "{\n " +
                    "code_mgroup: \"100\"," +
                    "code_name: \"上海\",\n" +
                    "region_cd: \"2000\",\n" +
                    "sel_region_cd: \"2000\",\n" +
                    "remark1_v: \"10\",\n" +
                    "remark2_v: \"001\",\n" +
                    "remark3_v: \"S\"\n" +
                    "}";
            resultBean = new Gson().fromJson(local, ResultBean.class);
            OCJPreferencesUtils.setRegion(resultBean.getRegion_cd());
            OCJPreferencesUtils.setSelRegion(resultBean.getSel_region_cd());
            OCJPreferencesUtils.setSubstation(resultBean.getCode_mgroup());
        }

        Map<String, String> param = new HashMap<String, String>();
        param.put(ParamKeys.REGION_CD, resultBean.getRegion_cd());
        param.put(ParamKeys.SEL_REGIONID, resultBean.getSel_region_cd());
        param.put(ParamKeys.SUBSTATION_CODE, resultBean.getCode_mgroup());
        param.put(ParamKeys.DISTRICT_CODE, resultBean.getRemark());
        param.put(ParamKeys.AREA_LGROUP, resultBean.getRemark1_v());
        param.put(ParamKeys.AREA_MGROUP, resultBean.getRemark2_v());
        param.put(ParamKeys.AREA_LGROUP_NAME, resultBean.getCode_name());
        new AccountMode(mContext).visitLogin(param, new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onSuccess(UserInfo apiResult) {
                OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                OCJPreferencesUtils.setVisitor(true);
                startMain();
            }

            @Override
            public void onError(ApiException e) {
                OCJPreferencesUtils.setVisitor(true);
                startMain();
            }
        });
    }

    public void getAccessTokens() {
        new AccountMode(mContext).accessToken(OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<UserInfo>(mContext) {
            @Override
            public void onSuccess(UserInfo apiResult) {
                OCJPreferencesUtils.setAccessToken(apiResult.getAccessToken());
                OCJPreferencesUtils.setVisitor(false);
                startMain();
            }

            @Override
            public void onError(ApiException e) {
                //正式token获取失败，就去获取游客token
                getVisitToken(localBean);
            }
        });
    }

    private void startMain() {
        startActivity(new Intent(mContext, RNActivity.class));
        finish();
//        Observable.interval(0, 1, TimeUnit.SECONDS)
//                .take(ENTER_DELAY_TIME)
//                .subscribe(new Observer<Long>() {
//                    @Override
//                    public void onSubscribe(Disposable d) {
//
//                    }
//
//                    @Override
//                    public void onNext(Long aLong) {
//
//                    }
//
//                    @Override
//                    public void onError(Throwable e) {
//
//                    }
//
//                    @Override
//                    public void onComplete() {
//                        if (OCJPreferencesUtils.isFirst()) {
//                            OCJPreferencesUtils.setIsFirst(false);
//                            OCJPreferencesUtils.setOpenTimes(5);
//                            startActivity(new Intent(mContext, GuideActivity.class));
//                            OCJPreferencesUtils.setVersion(BuildConfig.VERSION_NAME);
//                            finish();
//                        } else {
//                            if (!TextUtils.equals(OCJPreferencesUtils.getVersion(), BuildConfig.VERSION_NAME)) {
//                                startActivity(new Intent(mContext, GuideActivity.class));
//                                OCJPreferencesUtils.setVersion(BuildConfig.VERSION_NAME);
//                            } else {
//                                startActivity(new Intent(mContext, RNActivity.class));
//                            }
//                            finish();
//                        }

//                    }
//                });
    }


}
