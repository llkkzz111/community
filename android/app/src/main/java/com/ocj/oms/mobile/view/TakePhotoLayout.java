package com.ocj.oms.mobile.view;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.lzy.imagepicker.ImagePicker;
import com.lzy.imagepicker.ui.ImageGridActivity;
import com.lzy.imagepicker.view.CropImageView;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.ui.pickimg.GlideImageLoader;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by yy on 2017/5/10.
 * 跟税务说明相关的浮层
 */

public class TakePhotoLayout extends LinearLayout {
    private Activity mContext;

    final int CAPTURE = 1;//拍照
    final int PHOTO = 2;//相册

    public TakePhotoLayout(Activity context) {
        super(context);
        this.mContext = context;
        init(mContext);
    }

    public TakePhotoLayout(Activity context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        this.mContext = context;
    }


    private void init(Context mContext) {
        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.popupwindow_takephoto_layout, null);
        ButterKnife.bind(this, view);
        this.addView(view);
        initImagePicker();
    }


    @OnClick({R.id.tv_take_photo, R.id.tv_from_album})
    void onClickView(View v) {
        switch (v.getId()) {
            case R.id.tv_take_photo:
                openCamera();
                mContext.finish();
                mContext.overridePendingTransition(R.anim.push_bottom_in, R.anim.push_bottom_out);
                break;

            case R.id.tv_from_album:
                openPhoto();
                mContext.finish();
                mContext.overridePendingTransition(R.anim.push_bottom_in, R.anim.push_bottom_out);
                break;
        }
    }

    /**
     * 打开系统相册
     */
    private void openPhoto() {
        checkAlbumPermission();
//        Intent intent = new Intent(mContext, PhotoSelectorActivity.class);
//        intent.putExtra("key_max", 1);
//        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
//        mContext.startActivityForResult(intent, PHOTO);

        ImagePicker.getInstance().setSelectLimit(1);
        Intent intent1 = new Intent(mContext, ImageGridActivity.class);
        intent1.putExtra(IntentKeys.PROFILE_SETTING, "");
        mContext.startActivity(intent1);


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


    /**
     * 打开系统相机
     */
    private void openCamera() {
        Intent intent = new Intent();
        intent.setAction("camera");
        mContext.sendBroadcast(intent);
    }


    public void checkAlbumPermission() {
        if (Build.VERSION.SDK_INT >= 23) {
            //是否拥有权限
            int checkCallPhonePermission = ContextCompat.checkSelfPermission(mContext.getApplicationContext(), Manifest.permission.READ_EXTERNAL_STORAGE);
            if (checkCallPhonePermission != PackageManager.PERMISSION_GRANTED) {
                //弹出对话框接收权
                ActivityCompat.requestPermissions(mContext, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, PHOTO);
                return;
            }
        }
    }


}
