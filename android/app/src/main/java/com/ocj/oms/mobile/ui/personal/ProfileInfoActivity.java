package com.ocj.oms.mobile.ui.personal;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.bigkoo.pickerview.TimePickerView;
import com.bigkoo.pickerview.listener.CustomListener;
import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.lzy.imagepicker.ImagePicker;
import com.lzy.imagepicker.ui.ImageGridActivity;
import com.lzy.imagepicker.view.CropImageView;
import com.ocj.oms.common.CropCircleTransformation;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.MemberBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.ui.personal.setting.EditEmailActivity;
import com.ocj.oms.mobile.ui.personal.setting.EditMobileActivity;
import com.ocj.oms.mobile.ui.personal.setting.EditNickNameActivity;
import com.ocj.oms.mobile.ui.personal.setting.SetDefaultAdressActivity;
import com.ocj.oms.mobile.ui.pickimg.GlideImageLoader;
import com.ocj.oms.mobile.ui.pickimg.SelectDialog;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.UIManager;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/17.
 * <p>
 * 个人信息
 */
@Route(path = RouterModule.AROUTER_PATH_PERSONINFO)
public class ProfileInfoActivity extends BaseActivity {

    TimePickerView customTime;
    Calendar selectedDate;
    final int OPEN_CAMERA = 1;

    @BindView(R.id.tv_birthday) TextView tvBirthdat;
    @BindView(R.id.iv_head) ImageView ivHead;


    @BindView(R.id.btn_close) ImageView btnClose;
    @BindView(R.id.tv_person_icon) RelativeLayout tvPersonIcon;
    @BindView(R.id.tv_nickname) TextView tvNickname;
    @BindView(R.id.rl_nickname) RelativeLayout rlNickname;
    @BindView(R.id.tv_username) TextView tvUsername;

    @BindView(R.id.tv_email) TextView tvEmail;
    @BindView(R.id.person_mail) RelativeLayout personMail;
    @BindView(R.id.tv_mobile) TextView tvMobile;
    @BindView(R.id.person_mobile) RelativeLayout personMobile;
    @BindView(R.id.person_birthday) RelativeLayout personBirthday;

    @BindView(R.id.iv_isvisible) ImageView arow;

    //默认地址
    @BindView(R.id.tv_defalt_address) TextView defalutArea;
    @BindView(R.id.tv_adress_detail) TextView areaDetail;

    final int DEFAULT_ADDRESS = 100;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_personinfo_layout;
    }

    @Override
    protected void initEventAndData() {
        initMemberInfo();
        initReceiver();
        initDatePicker();

    }

    private void initMemberInfo() {
        new AccountMode(mContext).checkMemberInfo(OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<MemberBean>(mContext) {
            @Override
            public void onSuccess(MemberBean apiResult) {
                tvNickname.setText(apiResult.getCustomerCommon().getCust_name());
                tvUsername.setText(apiResult.getCustomerCommon().getInternet_Id());
                tvMobile.setText(apiResult.getCustomerCommon().getHptel());
                tvEmail.setText(apiResult.getCustomerCommon().getEmail_Addr());
                Glide.with(mContext).load(apiResult.getCustPhoto()).
                        skipMemoryCache(true).diskCacheStrategy(DiskCacheStrategy.NONE).
                        error(R.drawable.icon_user).
                        placeholder(R.drawable.icon_user).
                        bitmapTransform(new CropCircleTransformation(mContext)).
                        into(ivHead);
                checkArow(apiResult.getCustomerCommon());
                refreshAdress(apiResult);
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

        });
    }

    String privinceId = "", cityId = "", areaId = "", addressType = "10";

    private void refreshAdress(MemberBean apiResult) {
        MemberBean.AddressInfoBean bean = apiResult.getAddrInfo();
        if (bean != null) {
            defalutArea.setText(bean.getProvince_name() + " " + bean.getCity_name() + " " + bean.getArea_name());
            areaDetail.setText(bean.getAddr());
            privinceId = bean.getProvince();
            cityId = bean.getCity();
            areaId = bean.getArea();
            addressType = bean.getPlace_gb();
        }
    }

    private void checkArow(MemberBean.CustomerCommonBean customerCommon) {
        if (TextUtils.isEmpty(customerCommon.getBirth_yyyy()) || TextUtils.isEmpty(customerCommon.getBirth_mm()) || TextUtils.isEmpty(customerCommon.getBirth_dd())) {
            arow.setVisibility(View.VISIBLE);
            personBirthday.setEnabled(true);
        } else {
            arow.setVisibility(View.GONE);
            personBirthday.setEnabled(false);
            tvBirthdat.setText(customerCommon.getBirth_yyyy() + "." + customerCommon.getBirth_mm() + "." + customerCommon.getBirth_dd());
        }


    }

    private void initReceiver() {
        IntentFilter recIntent = new IntentFilter();
        recIntent.addAction(IntentKeys.SELECT_IMG);
        recIntent.addAction("camera");
        recIntent.addAction(IntentKeys.FRESH_PROFILE);
        registerReceiver(imGReceiver, recIntent);
    }

    private void initDatePicker() {
        selectedDate = Calendar.getInstance();//系统当前时间
        Calendar startDate = Calendar.getInstance();
        startDate.set(1960, 1, 1);
        Calendar endDate = Calendar.getInstance();
        //endDate.set(2027, 2, 28);
        customTime = new TimePickerView.Builder(this, new TimePickerView.OnTimeSelectListener() {
            @Override
            public void onTimeSelect(Date date, View v) {//选中事件回调
                setBirthday(date);
            }
        })
                /*.setType(TimePickerView.Type.ALL)//default is all
                .setCancelText("Cancel")
                .setSubmitText("Sure")
                .setContentSize(18)
                .setTitleSize(20)
                .setTitleText("Title")
                .setTitleColor(Color.BLACK)
               .setDividerColor(Color.WHITE)//设置分割线的颜色
                .setTextColorCenter(Color.LTGRAY)//设置选中项的颜色
                .setLineSpacingMultiplier(1.6f)//设置两横线之间的间隔倍数
                .setTitleBgColor(Color.DKGRAY)//标题背景颜色 Night mode
                .setBgColor(Color.BLACK)//滚轮背景颜色 Night mode
                .setSubmitColor(Color.WHITE)
                .setCancelColor(Color.WHITE)
               .gravity(Gravity.RIGHT)// default is center*/
                .setDate(selectedDate)
                .setRangDate(startDate, endDate)
                .setLayoutRes(R.layout.pickerview_custom_time, new CustomListener() {

                    @Override
                    public void customLayout(View v) {
                        final TextView tvSubmit = (TextView) v.findViewById(R.id.tv_finish);
                        ImageView ivCancel = (ImageView) v.findViewById(R.id.iv_cancel);
                        tvSubmit.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                customTime.returnData();
                                customTime.dismiss();
                            }
                        });
                        ivCancel.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                customTime.dismiss();
                            }
                        });
                    }
                })
                .setType(new boolean[]{true, true, true, false, false, false})
                .isCenterLabel(false) //是否只显示中间选中项的label文字，false则每项item全部都带有label。
                .setDividerColor(Color.RED)
                .build();
    }

    /**
     * 设置生日
     *
     * @param date
     */
    private void setBirthday(Date date) {
        String selectBithday = getTime(date, "yyyy.MM.dd");
        if (!TextUtils.isEmpty(selectBithday)) {
            tvBirthdat.setText(selectBithday);
        }
        Map<String, String> params = new HashMap<String, String>();
        params.put(ParamKeys.ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
        params.put(ParamKeys.BIRTHDAY, getTime(date, "yyyyMMdd"));
        new AccountMode(mContext).changeBirthday(params, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(Result<String> apiResult) {
                ToastUtils.showShortToast("生日设置成功");
            }
        });
    }

    /**
     * 格式化时间
     *
     * @param date
     * @param formatStr
     * @return
     */
    private String getTime(Date date, String formatStr) {//可根据需要自行截取数据显示
        SimpleDateFormat format = new SimpleDateFormat(formatStr);
        return format.format(date);
    }


    @OnClick(R.id.btn_close)
    public void onClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056D003001C003001);
        finish();
    }

    @OnClick({R.id.tv_person_icon, R.id.rl_nickname, R.id.person_mail, R.id.person_mobile, R.id.person_birthday, R.id.rl_default})
    public void onChildClick(View view) {

        switch (view.getId()) {
            case R.id.tv_person_icon:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056F010001A001001);
                showSelectDialog();
//                Intent intent = new Intent(mContext, PopupWindowActivity.class);
//                intent.putExtra(IntentKeys.POP_TYPE, PopupType.PHOTO);
//                startActivity(intent);
                break;

            case R.id.rl_nickname:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056F010002A001001);
                startActivity(new Intent(mContext, EditNickNameActivity.class));

                break;

            case R.id.person_mail:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056F010003A001001);
                startActivity(new Intent(mContext, EditEmailActivity.class));
                break;

            case R.id.person_mobile:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056F010004A001001);
                startActivity(new Intent(mContext, EditMobileActivity.class));
                break;

            case R.id.person_birthday:
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C056F010005A001001);
                showBithdayDialog();
                break;


            case R.id.rl_default://设置默认地址
                Intent mItent = new Intent(mContext, SetDefaultAdressActivity.class);
                mItent.putExtra(IntentKeys.ADDRESS, defalutArea.getText().toString());
                mItent.putExtra(IntentKeys.ADDRESS_DETAIL, areaDetail.getText().toString());
                mItent.putExtra(ParamKeys.PROVINCE, privinceId);
                mItent.putExtra(ParamKeys.CITY, cityId);
                mItent.putExtra(ParamKeys.AREA, areaId);
                mItent.putExtra(ParamKeys.PLACE_GB, addressType);
                startActivity(mItent);
//                startActivityForResult(mItent, DEFAULT_ADDRESS);
                break;
        }


    }

    //显示相册/拍照popwindow
    private void showSelectDialog() {
        List<String> names = new ArrayList<>();
        names.add("拍照");
        names.add("相册");
        SelectDialog dialog = new SelectDialog(this, R.style
                .transparentFrameWindowStyle,
                new SelectDialog.SelectDialogListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                        switch (position) {
                            case 0: // 直接调起相机
                                checkCapturePermission();
                                break;
                            case 1:
                                //打开选择,本次允许选择的数量
                                initImagePicker();
                                ImagePicker.getInstance().setSelectLimit(1);
                                Intent intent1 = new Intent(mContext, ImageGridActivity.class);
                                intent1.putExtra(IntentKeys.PROFILE_SETTING, "");
                                mContext.startActivity(intent1);
                                break;
                            default:
                                break;
                        }
                    }
                }, names);

        dialog.setRemoveCancel(true);
        if (!this.isFinishing()) {
            dialog.show();
        }


    }


    private void showBithdayDialog() {
        customTime.show();
    }


    @Override
    protected void onDestroy() {

        super.onDestroy();
        unregisterReceiver(imGReceiver);
    }


    BroadcastReceiver imGReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(IntentKeys.SELECT_IMG)) {
                String imgPath = intent.getStringExtra(IntentKeys.SELECT_IMG);
                if (!TextUtils.isEmpty(imgPath)) {
                    upLoadImg(imgPath);
                }
                return;
            }

            if (intent.getAction().equals(IntentKeys.FRESH_PROFILE)) {
                initMemberInfo();
            }
        }
    };


    /**
     * 检查权限并打开相机
     */
    private void openCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        mContext.startActivityForResult(intent, OPEN_CAMERA);
    }

    /**
     * 向服务器请求上传图片,成功后显示头像
     *
     * @param imgPath
     */
    private void upLoadImg(String imgPath) {
        showLoading(null, false);
        Glide.with(mContext).load("file://" + imgPath).bitmapTransform(new CropCircleTransformation(mContext)).
                diskCacheStrategy(DiskCacheStrategy.NONE).
                into(ivHead);
        Glide.with(UIManager.getInstance().getBaseContext()).load("file://" + imgPath).
                into(new SimpleTarget<GlideDrawable>() {
                    @Override
                    public void onResourceReady(GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) {
                        Drawable drawable = resource.getCurrent();
                        GlideBitmapDrawable bd = (GlideBitmapDrawable) drawable.getCurrent();
                        if (null != bd.getBitmap()) {
                            changePortrait(bd.getBitmap());
                        }
//
                    }
                });

    }

    /**
     * 权限申请
     */
    public void checkCapturePermission() {
        if (Build.VERSION.SDK_INT >= 23) {
            int checkCallPhonePermission = ContextCompat.checkSelfPermission(mContext.getApplicationContext(), Manifest.permission.CAMERA);
            if (checkCallPhonePermission != PackageManager.PERMISSION_GRANTED) {
                //弹出对话框接收权限
                ActivityCompat.requestPermissions(mContext, new String[]{Manifest.permission.CAMERA}, OPEN_CAMERA);
                return;
            } else {
                openCamera();
            }
        } else {
            openCamera();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case OPEN_CAMERA:
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    openCamera();
                } else {
                    showDialogTipUserGoToAppSettting("权限不可用", "请在-应用设置-权限-中，打开相机权限");
                }
                break;
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }


    // 提示用户去应用设置界面手动开启权限
    private void showDialogTipUserGoToAppSettting(String title, String message) {
        new AlertDialog.Builder(this)
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
                        dialog.dismiss();
                    }
                }).setCancelable(false).show();

    }

    // 跳转到当前应用的设置界面
    private void goToAppSetting() {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", getPackageName(), null);
        intent.setData(uri);
        startActivityForResult(intent, 1);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent result) {
        if (requestCode == OPEN_CAMERA && resultCode == RESULT_OK) {
            if (result != null) {
                Bundle extras = result.getExtras();
                Bitmap bm = (Bitmap) extras.get("data");
                changePortrait(bm);
                ivHead.setImageBitmap(bm);
            } else {
                ////由于指定了目标uri，存储在目标uri，intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
                // 通过目标uri，找到图片
                // 对图片的缩放处理
//                Uri uri = Uri.fromFile(photoFile);
//                photo.setImageURI(uri);
            }
        } else if (requestCode == DEFAULT_ADDRESS && resultCode == RESULT_OK) {
            initMemberInfo();
        }


    }

    /**
     * 修改头像
     *
     * @param bm
     */
    private void changePortrait(Bitmap bm) {
        new AccountMode(mContext).changePortrait(bm, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onSuccess(Result<String> apiResult) {
                hideLoading();
                RouterModule.sendAdviceEvent("refreshMePage", true);
                ToastUtils.showShortToast("修改成功");
                Intent intent = new Intent();
                intent.setAction(IntentKeys.FRESH_SETTING);
                mContext.sendBroadcast(intent);
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast("修改失败");


            }
        });
    }

    private void initImagePicker() {
        ImagePicker imagePicker = ImagePicker.getInstance();
        imagePicker.setImageLoader(new GlideImageLoader());   //设置图片加载器
        imagePicker.setShowCamera(true);                      //显示拍照按钮
        imagePicker.setCrop(false);                           //允许裁剪（单选才有效）
        imagePicker.setSaveRectangle(true);                   //是否按矩形区域保存
        imagePicker.setStyle(CropImageView.Style.RECTANGLE);  //裁剪框的形状
        imagePicker.setFocusWidth(800);                       //裁剪框的宽度。单位像素（圆形自动取宽高最小值）
        imagePicker.setFocusHeight(800);                      //裁剪框的高度。单位像素（圆形自动取宽高最小值）
        imagePicker.setOutPutX(1000);                         //保存文件的宽度。单位像素
        imagePicker.setOutPutY(1000);                         //保存文件的高度。单位像素
    }


}
