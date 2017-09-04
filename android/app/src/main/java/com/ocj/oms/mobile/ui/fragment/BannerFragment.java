package com.ocj.oms.mobile.ui.fragment;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;

import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.ui.convenientbanner.ConvenientBanner;
import com.ocj.oms.mobile.ui.convenientbanner.holder.CBViewHolderCreator;
import com.ocj.oms.mobile.ui.convenientbanner.holder.Holder;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by liutao on 2017/6/8.
 */

public class BannerFragment extends BaseFragment {

    private static final String extra = "extra";

    private PackageListBean packageBean;
    private List<CmsItemsBean> componentList;
    private List<CmsItemsBean> cmsItemsBeen;

    public static BannerFragment newInstance(PackageListBean packageBean) {
        BannerFragment fragment = new BannerFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(extra, packageBean);
        fragment.setArguments(bundle);
        return fragment;
    }

    @BindView(R.id.cb_banner)
    ConvenientBanner<String> banner;

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_banner_layout;
    }

    @Override
    protected void initEventAndData() {

        packageBean = (PackageListBean) getArguments().getSerializable(extra);
        componentList = packageBean.getComponentList();
        if (componentList == null) {
            ToastUtils.showLongToast("banner 数据为空");
            return;
        }
        cmsItemsBeen = new ArrayList<>();
        List<String> localImages = new ArrayList<>();

        for (CmsItemsBean componentListBean : componentList) {
            if (componentListBean != null && !TextUtils.isEmpty(componentListBean.getFirstImgUrl()) && !TextUtils.isEmpty(componentListBean.getDestinationUrl())) {
                cmsItemsBeen.add(componentListBean);
            }
        }

        for (CmsItemsBean componentListBean : cmsItemsBeen) {
            localImages.add(componentListBean.getFirstImgUrl());
        }

        banner.setPages(
                new CBViewHolderCreator<LocalImageHolderView>() {
                    @Override
                    public LocalImageHolderView createHolder() {
                        return new LocalImageHolderView();
                    }
                }, localImages)
                //设置两个点图片作为翻页指示器，不设置则没有指示器，可以根据自己需求自行配合自己的指示器,不需要圆点指示器可用不设
                .setPageIndicator(new int[]{R.drawable.icon_banner_unselect, R.drawable.icon_banner_select})
                //设置指示器的方向
                .setPageIndicatorAlign(ConvenientBanner.PageIndicatorAlign.CENTER_HORIZONTAL)
                .setCanLoop(true);

        banner.setManualPageable(true);//设置不能手动影响
    }

    @Override
    protected void lazyLoadData() {

    }

    class LocalImageHolderView implements Holder<String> {
        private ImageView imageView;
        private View view;

        @Override
        public View createView(Context context) {
            if (view == null) {
                view = LayoutInflater.from(context).inflate(R.layout.fragment_banner_item_layout, null);
                imageView = (ImageView) view.findViewById(R.id.iv_banner);
            }
            return view;
        }

        @Override
        public void UpdateUI(Context context, final int position, String url) {
            loadIntoUseFitWidth(context, url, R.drawable.icon_dougou_def, imageView);
            imageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    RouterModule.globalToWebView(cmsItemsBeen.get(position).getDestinationUrl());
                }
            });

        }
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
    public void onResume() {
        super.onResume();
        banner.stopTurning();
    }

    @Override
    public void onPause() {
        super.onPause();
        banner.stopTurning();
    }
}
