package com.community.equity.utils;

/**
 * Copyright (C) 2015 Wasabeef
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.Transformation;
import com.bumptech.glide.load.engine.Resource;
import com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool;
import com.bumptech.glide.load.resource.bitmap.BitmapResource;

public class CropSquareTransformation implements Transformation<Bitmap> {

    private static float radius;
    private BitmapPool mBitmapPool;
    private int mWidth;
    private int mHeight;

    public CropSquareTransformation(Context context) {
        this(Glide.get(context).getBitmapPool());
    }

    public CropSquareTransformation(BitmapPool pool) {
        this.mBitmapPool = pool;
    }

    private static Bitmap roundCrop(BitmapPool pool, Bitmap source) {


        if (source == null) return null;

        Bitmap result = pool.get(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        if (result == null) {
            result = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(result);
        Paint paint = new Paint();
        paint.setShader(new BitmapShader(source, BitmapShader.TileMode.CLAMP, BitmapShader.TileMode.CLAMP));
        paint.setAntiAlias(true);
        RectF rectF = new RectF(0f, 0f, source.getWidth(), source.getHeight());
        if (source.getHeight() <= 50) {
            radius = Resources.getSystem().getDisplayMetrics().density * 1;
        } else if (source.getHeight() <= 100) {
            radius = Resources.getSystem().getDisplayMetrics().density * 2;
        } else if (source.getHeight() < 200) {
            radius = Resources.getSystem().getDisplayMetrics().density * 4;
        } else {
            radius = Resources.getSystem().getDisplayMetrics().density * 8;
        }
        canvas.drawRoundRect(rectF, radius, radius, paint);
        return result;
    }

    @Override
    public Resource<Bitmap> transform(Resource<Bitmap> resource, int outWidth, int outHeight) {
        Bitmap source = resource.get();
        int size = Math.min(source.getWidth(), source.getHeight());

        mWidth = (source.getWidth() - size) / 2;
        mHeight = (source.getHeight() - size) / 2;

        Bitmap.Config config =
                source.getConfig() != null ? source.getConfig() : Bitmap.Config.ARGB_8888;
        Bitmap bitmap = mBitmapPool.get(mWidth, mHeight, config);
        if (bitmap == null) {
            bitmap = Bitmap.createBitmap(source, mWidth, mHeight, size, size);
        }

        return BitmapResource.obtain(roundCrop(mBitmapPool, bitmap), mBitmapPool);
    }

    @Override
    public String getId() {
        return "CropSquareTransformation(width=" + mWidth + ", height=" + mHeight + ")";
    }
}
