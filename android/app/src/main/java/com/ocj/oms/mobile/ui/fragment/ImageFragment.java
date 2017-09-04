package com.ocj.oms.mobile.ui.fragment;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.AbroadBuyActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/9.
 */

public class ImageFragment extends BaseFragment {

    @BindView(R.id.iv_top_image) ImageView topImage;
    private PackageListBean packageBean;
    String url;
    String desUrl;

    public static ImageFragment newInstance(PackageListBean packageBean) {
        ImageFragment imageFragment = new ImageFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(IntentKeys.EXTRA, packageBean);
        imageFragment.setArguments(bundle);
        return imageFragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_image_layout;
    }

    @Override
    protected void initEventAndData() {
        packageBean = (PackageListBean) getArguments().getSerializable(IntentKeys.EXTRA);
        if (packageBean.getComponentList() != null) {
            url = packageBean.getComponentList().get(0).getFirstImgUrl();
            desUrl = packageBean.getComponentList().get(0).getDestinationUrl();
        } else {
            url = "";
        }
        loadIntoUseFitWidth(mActivity, url, R.drawable.icon_dougou_def, topImage);
    }

    /**
     * 自适应宽度加载图片。保持图片的长宽比例不变，通过修改imageView的高度来完全显示图片。
     */
    public void loadIntoUseFitWidth(Context context, final String imageUrl, int errorImageId, final ImageView imageView) {
        Glide.with(context).load(imageUrl).diskCacheStrategy(DiskCacheStrategy.RESULT).placeholder(errorImageId).into(new SimpleTarget<GlideDrawable>() {
            @Override
            public void onResourceReady(GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) {
                Drawable drawable = resource.getCurrent();
                GlideBitmapDrawable bd = (GlideBitmapDrawable) drawable.getCurrent();
                if (null != bd.getBitmap()) {
                    imageView.setImageBitmap(bd.getBitmap());
                }
            }
        });

    }

    @Override
    protected void lazyLoadData() {

    }

    @OnClick({R.id.iv_top_image})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_top_image:
                if (!TextUtils.isEmpty(desUrl)) {
                    Map<String, Object> params1 = ((AbroadBuyActivity) mActivity).getParams();
                    OcjStoreDataAnalytics.trackEvent(mActivity, packageBean.getComponentList().get(0).getCodeValue(), packageBean.getComponentList().get(0).getTitle(), params1);
                    RouterModule.globalToWebView(desUrl);
                }
                break;
        }
    }
}
