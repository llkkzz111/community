package com.ocj.oms.common.loader;

import android.content.Context;
import android.widget.ImageView;

import com.bumptech.glide.DrawableTypeRequest;
import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestManager;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.ocj.oms.common.R;

import java.io.File;

/**
 * @Description: 使用Glide框架加载图片
 * @author: jeasinlee
 * @date: 2016-12-19 15:16
 */
public class GlideLoader implements ILoader {
    @Override
    public void init(Context context) {

    }

    @Override
    public void loadNet(ImageView target, String url, int drawableId) {
        load(getRequestManager(target.getContext()).load(url), target, null, drawableId);
    }

    @Override
    public void loadNet(ImageView target, String url, Options options) {
        load(getRequestManager(target.getContext()).load(url), target, options);
    }

    @Override
    public void loadNet(ImageView target, String url) {
        load(getRequestManager(target.getContext()).load(url), target, null, R.drawable.icon_dougou_def);
    }

    @Override
    public void loadNet(ImageView target, String url, Options options, int drawableId) {
        load(getRequestManager(target.getContext()).load(url), target, options, drawableId);
    }

    @Override
    public void loadResource(ImageView target, int resId, Options options) {
        load(getRequestManager(target.getContext()).load(resId), target, options);
    }

    @Override
    public void loadAssets(ImageView target, String assetName, Options options) {
        load(getRequestManager(target.getContext()).load("file:///android_asset/" + assetName), target, options);
    }

    @Override
    public void loadFile(ImageView target, File file, Options options) {
        load(getRequestManager(target.getContext()).load(file), target, options);
    }

    @Override
    public void clearMemoryCache(Context context) {
        Glide.get(context).clearMemory();
    }

    @Override
    public void clearDiskCache(Context context) {
        Glide.get(context).clearDiskCache();
    }

    private RequestManager getRequestManager(Context context) {
        return Glide.with(context);
    }

    private void load(DrawableTypeRequest request, ImageView target, Options options) {
        load(request, target, options, -1);
    }

    private void load(DrawableTypeRequest request, ImageView target, Options options, int drawable) {
        if (options == null) options = Options.defaultOptions();

        if (options.loadingResId != Options.RES_NONE) {
            request.placeholder(options.loadingResId);
        }
        if (options.loadErrorResId != Options.RES_NONE) {
            request.error(options.loadErrorResId);
        }
        if (drawable != -1) {
            request.crossFade().diskCacheStrategy(DiskCacheStrategy.SOURCE).error(drawable).into(target);
        } else {
            request.crossFade().diskCacheStrategy(DiskCacheStrategy.SOURCE).into(target);
        }

    }
}
