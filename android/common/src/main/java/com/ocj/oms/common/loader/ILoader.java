package com.ocj.oms.common.loader;

import android.content.Context;
import android.widget.ImageView;

import com.ocj.oms.common.JConfig;
import com.ocj.oms.common.R;

import java.io.File;


/**
 * @Description: 图片加载接口
 * @author: <a href="http://xiaoyaoyou1212.360doc.com">DAWI</a>
 * @date: 2016-12-19 15:04
 */
public interface ILoader {
    void init(Context context);

    void loadNet(ImageView target, String url);

    void loadNet(ImageView target, String url,int drawableId);

    void loadNet(ImageView target, String url, Options options);

    void loadNet(ImageView target, String url, Options options,int drawableId);

    void loadResource(ImageView target, int resId, Options options);

    void loadAssets(ImageView target, String assetName, Options options);

    void loadFile(ImageView target, File file, Options options);

    void clearMemoryCache(Context context);

    void clearDiskCache(Context context);

    class Options {

        public static final int RES_NONE = -1;
        public int loadingResId = R.drawable.icon_dougou_def;//加载中的资源id
        public int loadErrorResId = R.drawable.icon_dougou_def;//加载失败的资源id

        public static Options defaultOptions() {
            return new Options(JConfig.IL_LOADING_RES, JConfig.IL_ERROR_RES);
        }

        public Options(int loadingResId, int loadErrorResId) {
            this.loadingResId = loadingResId;
            this.loadErrorResId = loadErrorResId;
        }
    }
}
