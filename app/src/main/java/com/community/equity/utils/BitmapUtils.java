package com.community.equity.utils;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PointF;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;

import com.community.equity.R;
import com.community.equity.utils.model.BitmapBean;
import com.community.imsdk.utils.Logger;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuzhao on 16/4/14.
 */
public class BitmapUtils {
    /**
     * 判断图片是否损坏(使用宽高进行判断)
     *
     * @param path
     * @return
     */
    public static boolean imageIsDestory(String path) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(path, newOpts);//此时返回bm为空

        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        return w <= 0 || h <= 0;
    }

    public static byte[] getimage(String srcPath) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(srcPath, newOpts);//此时返回bm为空

        newOpts.inJustDecodeBounds = false;
        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        //根据图片宽高进行等比压缩
        float hh = 1280f;
        float ww = h * hh / w;
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        int be = 1;//be=1表示不缩放
        if (w > h && w > ww) {//如果宽度大的话根据宽度固定大小缩放
            be = (int) (newOpts.outWidth / ww);
        } else if (w < h && h > hh) {//如果高度高的话根据宽度固定大小缩放
            be = (int) (newOpts.outHeight / hh);
        }
        if (be <= 0)
            be = 1;
        newOpts.inSampleSize = be;//设置缩放比例
        //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
        bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
        return compressImage(bitmap);//压缩好比例大小后再进行质量压缩
    }

    public static byte[] compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while (baos.toByteArray().length / 1024 > 150) {  //循环判断如果压缩后图片是否大于150kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;//每次都减少10
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return baos.toByteArray();
    }


    public static Bitmap getBigBitmaps(Bitmap bitmap) {
        Bitmap newBitmap = Bitmap.createBitmap(206, 206, Bitmap.Config.ARGB_8888);
        newBitmap.eraseColor(Color.parseColor("#e7e7e7"));
        Canvas cv = new Canvas(newBitmap);
        final Paint paint = new Paint();
        final RectF rectF = new RectF(new Rect(9, 9, 200, 200));
        final Rect rect = new Rect(6, 6, 200, 200);
        cv.drawBitmap(bitmap, rect, rectF, paint);

        return newBitmap;
    }


    /**
     * 获得合在一起的bitmap
     *
     * @param mEntityList
     * @param bitmaps
     * @return
     */
    public static Bitmap getCombineBitmaps(List<BitmapBean> mEntityList,
                                           List<Bitmap> bitmaps) {
        Bitmap newBitmap = Bitmap.createBitmap(200, 200, Bitmap.Config.ARGB_8888);
        for (int i = 0; i < mEntityList.size(); i++) {
            bitmaps.set(i, getSmallBitmap(bitmaps.get(i)));
            newBitmap = mixtureBitmap(newBitmap, bitmaps.get(i), new PointF(
                    mEntityList.get(i).getX(), mEntityList.get(i).getY()));
        }
        return newBitmap;
    }

    /**
     * 画bitmap
     *
     * @param first
     * @param second
     * @param fromPoint
     * @return
     */
    public static Bitmap mixtureBitmap(Bitmap first, Bitmap second,
                                       PointF fromPoint) {
        if (first == null || second == null || fromPoint == null) {
            return null;
        }
        Bitmap newBitmap = Bitmap.createBitmap(first.getWidth(),
                first.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas cv = new Canvas(newBitmap);
        cv.drawBitmap(first, 0, 0, null);
        cv.drawBitmap(second, fromPoint.x, fromPoint.y, null);
        cv.save(Canvas.ALL_SAVE_FLAG);  //保存全部图层
        cv.restore();
        return newBitmap;
    }

    /**
     * 获取small的bitmap
     *
     * @param bitmap
     * @return
     */
    public static Bitmap getSmallBitmap(Bitmap bitmap) {
        try {
            Bitmap output = Bitmap.createBitmap(bitmap.getWidth(),
                    bitmap.getHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(output);
            final Paint paint = new Paint();
            final Rect rect = new Rect(3, 3, bitmap.getWidth() - 3,
                    bitmap.getHeight() - 3);
            final RectF rectF = new RectF(new Rect(3, 3, bitmap.getWidth() - 3,
                    bitmap.getHeight() - 3));
            final float roundPx = 0;
            paint.setAntiAlias(true);
            paint.setFilterBitmap(true);

            canvas.drawARGB(0, 0, 0, 0);
            canvas.drawRoundRect(rectF, roundPx, roundPx, paint);
            paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

            final Rect src = new Rect(3, 3, bitmap.getWidth() - 3,
                    bitmap.getHeight() - 3);

            canvas.drawBitmap(bitmap, src, rect, paint);
            return output;
        } catch (Exception e) {
            return bitmap;
        }
    }


    /**
     * 获取图片数组实体
     * by Hankkin at:2015-11-19 22:00:55
     *
     * @param count
     * @return
     */
    public static List<BitmapBean> getBitmapEntitys(int count) {
        List<BitmapBean> mList = new ArrayList<>();
        String value = PropertiesUtil.readData(String.valueOf(count), R.raw.data);
        String[] arr1 = value.split(";");
        int length = arr1.length;
        for (int i = 0; i < length; i++) {
            String content = arr1[i];
            String[] arr2 = content.split(",");
            BitmapBean entity = null;
            for (int j = 0; j < arr2.length; j++) {
                entity = new BitmapBean();
                entity.setX(Float.valueOf(arr2[0]));
                entity.setY(Float.valueOf(arr2[1]));
                entity.setWidth(Float.valueOf(arr2[2]));
                entity.setHeight(Float.valueOf(arr2[3]));
            }
            mList.add(entity);
        }
        return mList;
    }


    /**
     * 从path从取出图片，判断图片的宽高<br>
     * 1.如果图片宽度小于高度时<br>
     * 当图片高度大于屏幕高度，图片高度设置为400px，宽度等比缩为对应宽度<br>
     * 当图片高度小于屏幕高度，图片高度设置为250px，宽度等比缩为对应宽度<br>
     * 2.如果图片宽度大于高度时<br>
     * 当图片宽度大于屏幕宽度，图片宽度设置为400px，高度等比缩为对应高度<br>
     * 当图片宽度小于屏幕宽度，图片宽度设置为250px，高度等比缩为对应高度
     *
     * @param path
     * @return
     */
    public static Bitmap decodeThumbnailsBitmap(String path) {
        // 第一次解析将inJustDecodeBounds设置为true，来获取图片大小
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(path, options);
        // 调用上面定义的方法计算inSampleSize值
        int width = options.outWidth;
        int height = options.outHeight;
        int reqWidth, reqHeight;
        int screenWidth = ConstantUtils.SCREEN_WIDTH;
        int sreenHeight = ConstantUtils.SCREEN_HEIGHT;
        if (width == 0 || height == 0) {
            return decodeBitmapFromResource(UIManager.getInstance().getBaseContext().getResources(), R.drawable.icon_account_no_pic, 100, 100);
        }
        if (width > height) {
            if (width >= 2560 && screenWidth >= 1440) {
                reqWidth = 560;
            } else if (width >= 1920 && screenWidth >= 1080) {
                reqWidth = 480;
            } else if (width >= 1280 && screenWidth >= 720) {
                reqWidth = 400;
            } else {
                reqWidth = 250;
            }
            reqHeight = reqWidth * height / width;
        } else {
            if (height >= 2560) {
                reqHeight = 560;
            } else if (height >= 1920) {
                reqHeight = 480;
            } else if (height >= 1280) {
                reqHeight = 400;
            } else {
                reqHeight = 250;
            }
            reqWidth = reqHeight * width / height;
        }

        options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

        Logger.e("Test", "outWidth=" + width + ",outHeight=" + height
                + ",screenWidth=" + ConstantUtils.SCREEN_WIDTH
                + ",screenHeight=" + ConstantUtils.SCREEN_HEIGHT
                + ",reqWidth=" + reqWidth + ",reqHeight=" + reqHeight
                + ",inSampleSize=" + options.inSampleSize);

        // 使用获取到的inSampleSize值再次解析图片
        int targetDensity = (int) ConstantUtils.DENSITY;
        double xSScale = ((double) options.outWidth) / ((double) reqWidth);
        double ySScale = ((double) options.outHeight) / ((double) reqHeight);
        double startScale = xSScale > ySScale ? xSScale : ySScale;
        if (width < reqWidth || height < reqHeight) {
            reqWidth = width;
            reqHeight = height;
        } else {
            options.inScaled = true;
            options.inDensity = (int) (targetDensity * startScale / options.inSampleSize);
            options.inTargetDensity = targetDensity;
        }
        options.inJustDecodeBounds = false;
        Bitmap bmp = null;
        try {

            bmp = BitmapFactory.decodeFile(path, options);
        } catch (Exception e) {

        }
//		if(width<reqWidth||height<reqHeight){
//			reqWidth=width;
//			reqHeight=height;
//		}else{
//			bmp=resizeImage(bmp, reqWidth, reqHeight);
//		}
        return bmp;
    }


    public static Bitmap decodeBitmapFromResource(Resources res, int resId,
                                                  int reqWidth, int reqHeight) {
        // 第一次解析将inJustDecodeBounds设置为true，来获取图片大小
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeResource(res, resId, options);
        // 调用上面定义的方法计算inSampleSize值
        options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
        // 使用获取到的inSampleSize值再次解析图片
        options.inJustDecodeBounds = false;
        return BitmapFactory.decodeResource(res, resId, options);
    }

    public static int calculateInSampleSize(BitmapFactory.Options options,
                                            int reqWidth, int reqHeight) {
        // 源图片的高度和宽度
//		final int height = options.outHeight;
//		final int width = options.outWidth;
//		int inSampleSize = 1;
//		if (height > reqHeight || width > reqWidth) {
//			// 计算出实际宽高和目标宽高的比率
//			final int heightRatio = Math.round((float) height / (float) reqHeight);
//			final int widthRatio = Math.round((float) width / (float) reqWidth);
//			// 选择宽和高中最小的比率作为inSampleSize的值，这样可以保证最终图片的宽和高
//			// 一定都会大于等于目标的宽和高。
//			inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
//		}
//		return inSampleSize;
        // Raw height and width of image
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {

            final int halfHeight = height / 2;
            final int halfWidth = width / 2;

            // Calculate the largest inSampleSize value that is a power of 2 and
            // keeps both
            // height and width larger than the requested height and width.
            while ((halfHeight / inSampleSize) > reqHeight
                    && (halfWidth / inSampleSize) > reqWidth) {
                inSampleSize *= 2;
            }
        }

        return inSampleSize;
    }

}
