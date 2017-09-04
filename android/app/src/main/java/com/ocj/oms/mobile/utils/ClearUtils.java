package com.ocj.oms.mobile.utils;

import com.facebook.cache.disk.DiskStorageCache;
import com.facebook.cache.disk.FileCache;
import com.facebook.imagepipeline.core.ImagePipelineFactory;
import com.facebook.react.modules.network.OkHttpClientProvider;
import com.ocj.oms.utils.FileUtils;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import okhttp3.Cache;

/**
 * Created by xiao on 2017/8/15.
 */

public class ClearUtils {

    public static void clearAllCache() {
        clearHttpCache();
        clearImageCache();
    }

    public static long getTotalCache() {
        return getHttpCacheSize() + getImageCacheSize() + getGlideCache();
    }

    public static String getTotalCacheString() {
        return FileUtils.byteCountToDisplaySize(getTotalCache());
    }

    /**
     * 获取Http的缓存
     *
     * @return
     */
    public static long getHttpCacheSize() {
        try {
            Cache cache = OkHttpClientProvider.getOkHttpClient().cache();
            if (cache != null) {
                return cache.size();
            }
            return 0;
        } catch (IOException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 获取图片缓存的大小
     *
     * @return
     */
    public static long getImageCacheSize() {
        FileCache cache1 = ImagePipelineFactory.getInstance().getMainFileCache();
        long size1 = cache1.getSize();
        if (size1 < 0) {
            try {
                updateCacheSize((DiskStorageCache) cache1);
            } catch (Exception e) {
            }
            size1 = cache1.getSize();
        }
        FileCache cache2 = ImagePipelineFactory.getInstance().getSmallImageFileCache();
        long size2 = cache2.getSize();
        if (size2 < 0) {
            try {
                updateCacheSize((DiskStorageCache) cache2);
            } catch (Exception e) {
            }
            size2 = cache2.getSize();
        }
        return size1 + size2;
    }

    public static void clearHttpCache() {
        try {
            Cache cache = OkHttpClientProvider.getOkHttpClient().cache();
            if (cache != null) {
                cache.delete();
            }
        } catch (IOException e) {
        }
    }

    public static void clearImageCache() {
        FileCache cache1 = ImagePipelineFactory.getInstance().getMainFileCache();
        cache1.clearAll();
        FileCache cache2 = ImagePipelineFactory.getInstance().getSmallImageFileCache();
        cache2.clearAll();
    }

    static Method update;

    private static void updateCacheSize(DiskStorageCache cache) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        if (update == null) {
            update = DiskStorageCache.class.getDeclaredMethod("maybeUpdateFileCacheSize");
            update.setAccessible(true);
        }
        update.invoke(cache);
    }

    public static long getGlideCache() {
        long cacheSize = 0;
        File file = new File(FileUtils.GLIDE_CACHE_PATH);
        if (file.exists()) {
            cacheSize = FileUtils.sizeOf(file);
        }
        return cacheSize;
    }

}
