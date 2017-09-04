package com.ocj.oms.mobile.third.share.helper;

import com.bilibili.socialize.share.download.AbsImageDownloader;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.FutureTarget;
import com.bumptech.glide.request.target.Target;
import com.ocj.oms.mobile.base.App;

import java.io.File;
import java.util.concurrent.ExecutionException;

/**
 * Created by liu on 2017/6/5.
 */

public class ShareGlideImageDownloader extends AbsImageDownloader {
    @Override
    protected void downloadDirectly(final String imageUrl, String filePath, final OnImageDownloadListener listener) {
        if (listener != null)
            listener.onStart();

        new Thread(new Runnable() {
            @Override
            public void run() {
                FutureTarget<File> future = Glide
                        .with(App.getInstance())
                        .load(imageUrl)
                        .downloadOnly(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL);
                String path = null;

                try {
                    File cacheFile = future.get();
                    path = cacheFile.getAbsolutePath();
                    if (listener != null)
                        listener.onSuccess(path);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    if (listener != null)
                        listener.onFailed(path);
                } catch (ExecutionException e) {
                    e.printStackTrace();
                    if (listener != null)
                        listener.onFailed(path);
                }
            }
        }).start();

    }
}
