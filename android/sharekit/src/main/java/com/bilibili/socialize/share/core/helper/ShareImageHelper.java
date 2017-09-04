/*
 * Copyright (C) 2015 Bilibili <jungly.ik@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.bilibili.socialize.share.core.helper;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.bilibili.socialize.share.R;
import com.bilibili.socialize.share.download.IImageDownloader;
import com.bilibili.socialize.share.core.BiliShareConfiguration;
import com.bilibili.socialize.share.core.error.ShareException;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.bilibili.socialize.share.core.shareparam.ShareImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamAudio;
import com.bilibili.socialize.share.core.shareparam.ShareParamImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamText;
import com.bilibili.socialize.share.core.shareparam.ShareParamVideo;
import com.bilibili.socialize.share.core.shareparam.ShareParamWebPage;
import com.bilibili.socialize.share.util.BitmapUtil;
import com.bilibili.socialize.share.util.FileUtil;

import java.io.File;
import java.io.IOException;

/**
 * @author Jungly
 * @email jungly.ik@gmail.com
 * @since 2015/10/8
 */
public class ShareImageHelper {
    private static final String TAG = "BShare.image";
    private static final int THUMB_RESOLUTION_SIZE = 150;
    private static final int THUMB_MAX_SIZE = 30 * 1024;
    private static final int BITMAP_SAVE_THRESHOLD = 32 * 1024;

    private Context mContext;
    private BiliShareConfiguration mShareConfiguration;
    private Callback mCallback;

    public ShareImageHelper(Context context, BiliShareConfiguration shareConfiguration, Callback callback) {
        mContext = context.getApplicationContext();
        mShareConfiguration = shareConfiguration;
        mCallback = callback;
    }

    /**
     * 如果Bitmap/Res体积太大，保存到本地
     */
    public ShareImage saveBitmapToExternalIfNeed(BaseShareParam params) {
        return saveBitmapToExternalIfNeed(getShareImage(params));
    }

    public ShareImage saveBitmapToExternalIfNeed(ShareImage image) {
        if (image == null) {
            Log.d(TAG, "save bitmap image: null image");
            return null;
        } else if (image.isBitmapImage()) {
            if (image.getBitmap().getByteCount() > BITMAP_SAVE_THRESHOLD) {
                if (checkImageCachePath()) {
                    Log.d(TAG, "save bitmap image: start");
                    File file = BitmapUtil.saveBitmapToExternal(image.getBitmap(), mShareConfiguration.getImageCachePath(mContext));
                    if (file != null && file.exists()) {
                        Log.d(TAG, "save bitmap image: success");
                        image.setLocalFile(file);
                    } else {
                        Log.w(TAG, "save bitmap image: failed");
                    }
                }
            } else {
                Log.d(TAG, "save bitmap image: image size is valid, skip");
            }
        } else if (image.isResImage()) {
            Bitmap bmp = BitmapFactory.decodeResource(mContext.getResources(), image.getResId());
            if (bmp.getByteCount() > BITMAP_SAVE_THRESHOLD) {
                if (checkImageCachePath()) {
                    Log.d(TAG, "save res image: start");
                    File file = BitmapUtil.saveBitmapToExternal(bmp, mShareConfiguration.getImageCachePath(mContext));
                    if (file != null && file.exists()) {
                        Log.d(TAG, "save res image: success");
                        image.setLocalFile(file);
                        bmp.recycle();
                    } else {
                        Log.w(TAG, "save res image: failed");
                    }
                }
            } else {
                Log.d(TAG, "save res image: image size is valid, skip");
            }
        } else {
            Log.d(TAG, "save image: file image, skip");
        }
        return image;
    }

    public void copyImageToCacheFileDirIfNeed(BaseShareParam params) {
        copyImageToCacheFileDirIfNeed(getShareImage(params));
    }

    public void copyImageToCacheFileDirIfNeed(ShareImage shareImage) {
        if (shareImage == null) {
            Log.d(TAG, "copy image file: null image");
            return;
        }

        File localFile = shareImage.getLocalFile();
        if (localFile == null || !localFile.exists()) {
            Log.d(TAG, "copy image file: local file not exists");
            return;
        }

        if (!checkImageCachePath()) {
            return;
        }

        String localFilePath = localFile.getAbsolutePath();
        if (!localFilePath.startsWith(mContext.getCacheDir().getParentFile().getAbsolutePath())
                && localFilePath.startsWith(mShareConfiguration.getImageCachePath(mContext))) {
            Log.d(TAG, "copy image file: has copied before");
            return;
        }

        Log.d(TAG, "copy image file: start");
        File targetFile = copyFile(localFile, mShareConfiguration.getImageCachePath(mContext));
        if (targetFile != null && targetFile.exists()) {
            Log.d(TAG, "copy image file: success");
            shareImage.setLocalFile(targetFile);
        } else {
            Log.w(TAG, "copy image file: failed");
        }
    }

    private File copyFile(File srcFile, String targetCacheDirPath) {
        if (srcFile == null || !srcFile.exists()) {
            return null;
        }

        File targetFileDir = new File(targetCacheDirPath);
        File targetFile = new File(targetFileDir, srcFile.getName());

        if (!targetFileDir.exists() && !targetFileDir.mkdirs()) {
            return null;
        }

        try {
            FileUtil.copyFile(srcFile, targetFile);
            return targetFile;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 缩略图。32kb限制。
     * 注意：在工作线程调用。
     *
     * @param image
     * @return
     */
    public byte[] buildThumbData(final ShareImage image) {
        return buildThumbData(image, THUMB_MAX_SIZE, THUMB_RESOLUTION_SIZE, THUMB_RESOLUTION_SIZE, false);
    }

    public byte[] buildThumbData(final ShareImage image, int maxSize, int widthMax, int heightMax, boolean isFixSize) {
        if (image == null) {
            Log.d(TAG, "build thumb: null image");
            return new byte[0];
        }

        boolean isRecycleSrcBitmap = true;
        Bitmap bmp = null;

        if (image.isNetImage()) {
            Log.d(TAG, "build thumb: from net: start");
            if (mCallback != null) {
//                mCallback.onProgress(R.string.bili_share_sdk_progress_compress_image);
            }
            bmp = BitmapUtil.decodeUrl(image.getNetImageUrl());
        } else if (image.isLocalImage()) {
            Log.d(TAG, "build thumb: from local: start");
            bmp = BitmapUtil.decodeFile(image.getLocalPath(), THUMB_RESOLUTION_SIZE, THUMB_RESOLUTION_SIZE);
        } else if (image.isResImage()) {
            Log.d(TAG, "build thumb: from res: start");
            bmp = BitmapFactory.decodeResource(mContext.getResources(), image.getResId());
        } else if (image.isBitmapImage()) {
            Log.d(TAG, "build thumb: from bitmap: start");
            if (mCallback != null) {
//                mCallback.onProgress(R.string.bili_share_sdk_progress_compress_image);
            }
            isRecycleSrcBitmap = false;
            bmp = image.getBitmap();
        }

        if (bmp != null && !bmp.isRecycled()) {
            Log.d(TAG, "build thumb: success");
            if (!isFixSize) {
                int bmpWidth = bmp.getWidth();
                int bmpHeight = bmp.getHeight();
                double scale = BitmapUtil.getScale(widthMax, heightMax, bmpWidth, bmpHeight);
                widthMax = (int) (bmpWidth / scale);
                heightMax = (int) (bmpHeight / scale);
            }

            final Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, widthMax, heightMax, true);
            if (isRecycleSrcBitmap && thumbBmp != bmp) {
                bmp.recycle();
            }
            byte[] tempArr = BitmapUtil.bmpToByteArray(thumbBmp, maxSize, true);
            return tempArr == null ? new byte[0] : tempArr;
        } else {
            Log.w(TAG, "build thumb: failed");
        }

        return new byte[0];
    }

    public void downloadImageIfNeed(final BaseShareParam params, final Runnable task) throws ShareException {
        downloadImageIfNeed(getShareImage(params), task);
    }

    /**
     * @param image
     * @param task  图片下载完成后待执行的任务
     * @throws ShareException
     */
    public void downloadImageIfNeed(final ShareImage image, final Runnable task) throws ShareException {
        if (image == null || !image.isNetImage()) {
            Log.d(TAG, "download image: skip, no need");
            task.run();
        } else {
            if (!checkImageCachePath()) {
                if (mCallback != null) {
                    mCallback.onImageDownloadFailed();
                }
                return;
            }

            mShareConfiguration.getImageDownloader().download(mContext, image.getNetImageUrl(), mShareConfiguration.getImageCachePath(mContext),
                    new IImageDownloader.OnImageDownloadListener() {
                        @Override
                        public void onStart() {
                            Log.d(TAG, "download image: start");
                            if (mCallback != null) {
//                                mCallback.onProgress(R.string.bili_share_sdk_progress_compress_image);
                            }
                        }

                        @Override
                        public void onSuccess(String filePath) {
                            Log.d(TAG, String.format("download image: success: (%s)", filePath));
                            image.setLocalFile(new File(filePath));
                            copyImageToCacheFileDirIfNeed(image);
                            task.run();
                        }

                        @Override
                        public void onFailed(String url) {
                            Log.d(TAG, String.format("download image: failed: (%s)", url));
                            image.setResId(R.drawable.default_share_image);
                            copyImageToCacheFileDirIfNeed(image);
                            task.run();
                        }
                    });
        }
    }

    private boolean checkImageCachePath() {
        if (TextUtils.isEmpty(mShareConfiguration.getImageCachePath(mContext))) {
            Log.w(TAG, "存储设备不可用");
            Toast.makeText(mContext.getApplicationContext(), "存储设备不可用", Toast.LENGTH_LONG).show();
            return false;
        }
        return true;
    }

    protected ShareImage getShareImage(BaseShareParam params) {
        ShareImage image = null;
        if (params == null || params instanceof ShareParamText) {
            return null;
        } else if (params instanceof ShareParamImage) {
            image = ((ShareParamImage) params).getImage();
        } else if (params instanceof ShareParamWebPage) {
            image = ((ShareParamWebPage) params).getThumb();
        } else if (params instanceof ShareParamAudio) {
            image = ((ShareParamAudio) params).getThumb();
        } else if (params instanceof ShareParamVideo) {
            image = ((ShareParamVideo) params).getThumb();
        }
        return image;
    }

    public interface Callback {
        void onProgress(int msgId);

        void onImageDownloadFailed();
    }

}
