package com.choudao.equity.utils;

import android.content.Context;
import android.widget.ImageView;

import com.bumptech.glide.DrawableRequestBuilder;
import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestManager;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.choudao.equity.R;
import com.choudao.equity.base.BaseFragment;

/**
 * Created by liuzhao on 16/9/26.
 */

public class GlideUtils {
    static RequestManager requestManager;
    static ImageView img;
    static Context context;
    static boolean isRound;
    static DrawableRequestBuilder bitmapTransform = null;
//    public static void init(BaseActivity mContext, String path, ImageView image) {
//        requestManager = Glide.with(mContext);
//        context = mContext.getBaseContext();
//        img = image;
//    }
//
//    public static void init(Context mContext, String path, ImageView image) {
//        requestManager = Glide.with(mContext);
//        context = mContext;
//        img = image;
//    }
//


    public static void init(BaseFragment mContext, String path, ImageView image, boolean isRoun) {
        init(mContext, path, -1, image, isRoun);

    }

    public static void init(BaseFragment mContext, String path, int holderResId, ImageView image, boolean isRoun) {
        requestManager = Glide.with(mContext);
        context = mContext.getContext();
        isRound = isRoun;
        img = image;
        if (holderResId > 0) {
            loadCropSquare(path, holderResId);
        } else {
            loadCropSquare(path);
        }
    }

    private static void loadLocal(int resId) {
        requestManager.load(resId).into(img);
    }

    private static void loadLocalRound(int resId) {
        requestManager.load(resId).bitmapTransform(new CropSquareTransformation(context)).into(img);
    }

    /**
     * 圆角
     *
     * @param path
     * @param holderResId
     */
    private static void loadCropSquare(String path, int holderResId) {
        if (isRound) {
            bitmapTransform = requestManager.
                    load(path).
                    placeholder(holderResId).
                    fallback(holderResId).
                    bitmapTransform(new CropSquareTransformation(context));
        } else {
            bitmapTransform = requestManager.
                    load(path).
                    placeholder(holderResId).
                    fallback(holderResId);
        }
        bitmapTransform.
                diskCacheStrategy(DiskCacheStrategy.SOURCE).
                into(img);

    }

    /**
     * 圆角
     *
     * @param path
     */
    private static void loadCropSquare(String path) {
        if (isRound) {
            bitmapTransform = requestManager.
                    load(path).
                    placeholder(R.drawable.icon_account_no_pic).
                    fallback(R.drawable.icon_account_no_pic).
                    bitmapTransform(new CropSquareTransformation(context));

        } else {
            bitmapTransform = requestManager.
                    load(path).
                    placeholder(R.drawable.icon_account_no_pic).
                    fallback(R.drawable.icon_account_no_pic);
        }
        bitmapTransform.
                diskCacheStrategy(DiskCacheStrategy.SOURCE).
                into(img);
    }

    public GlideUtils init(BaseFragment mContext, int resId, ImageView image, boolean isRoun) {
        requestManager = Glide.with(mContext);
        context = mContext.getContext();
        img = image;
        if (isRoun) {
            loadLocalRound(resId);
        } else {
            loadLocal(resId);
        }
        return this;
    }

//    /**
//     * 默认
//     *
//     * @param context
//     * @param path
//     * @param imageView
//     * @param resourceId
//     * @param fallResourceId
//     */
//    public static void loadDefault(Context context, String path, ImageView imageView, int resourceId, int fallResourceId) {
//        Glide.with(context).load(path).centerCrop().placeholder(resourceId).fallback(fallResourceId).into(imageView);
//    }
//
//
//    /**
//     * 当已封装的方法不满足需求时，可以使用此方法
//     *
//     * @param context
//     * @param path
//     * @param imageView
//     * @param bmpT
//     * @param resourceId
//     * @param fallResourceId
//     */
//    public static void loadInOther(Context context, String path, ImageView imageView, Transformation bmpT, int resourceId, int fallResourceId) {
//        if (bmpT == null) {
//            loadDefault(context, path, imageView, resourceId, fallResourceId);
//        } else {
//            Glide.with(context).load(path).bitmapTransform(bmpT).diskCacheStrategy(DiskCacheStrategy.RESULT).placeholder(R.mipmap.default_bg).fallback(R.mipmap.default_bg).dontAnimate().into(imageView);
//
//
//        }
//    }

}
