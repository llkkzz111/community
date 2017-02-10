package com.choudao.equity.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.choudao.equity.R;
import com.choudao.equity.utils.model.BitmapBean;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.UserInfo;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by liuzhao on 16/10/31.
 */

public class NineImageUtils {
    private ImageView ivHead;
    private Context mContext;
    private String filePath = "";
    private long groupId = 0;
    private List<UserInfo> userInfos;

    public NineImageUtils(Activity mContext, long groupId, ImageView ivHead) {
        this.mContext = mContext;
        this.groupId = groupId;
        this.userInfos = DBHelper.getInstance().query9GroupMemberInfo(groupId);
        this.filePath = getFilePath();
        this.ivHead = ivHead;
    }

    public NineImageUtils(Activity mContext, long groupId, ImageView ivHead, String filePath) {
        this.mContext = mContext;
        this.groupId = groupId;
        this.filePath = filePath;
        this.ivHead = ivHead;
    }

    public NineImageUtils(Context mContext, long groupId) {
        this.mContext = mContext;
        this.groupId = groupId;
        this.userInfos = DBHelper.getInstance().query9GroupMemberInfo(groupId);
        this.filePath = getFilePath();
    }

    public void saveGroupHead() {
        if (FileUtils.isExists(filePath) && Utils.isOnMainThread() && ivHead != null) {
            showView(ivHead);
            return;
        } else {
            userInfos = DBHelper.getInstance().query9GroupMemberInfo(groupId);
            filePath = getFilePath();
        }
        if (CollectionUtil.isEmpty(userInfos)) return;
        final List<BitmapBean> beans = BitmapUtils.getBitmapEntitys(userInfos.size());
        if (ivHead != null && Utils.isOnMainThread()) {
            showLoadingHead();
            ivHead.setTag(ivHead.getId(), filePath);
            Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    syncSaveBitmap(beans, ivHead, filePath);
                }
            }, filePath);
            thread.start();
        } else {
            syncSaveBitmap(beans, new ImageView(mContext), filePath);
        }

    }


    private void syncSaveBitmap(final List<BitmapBean> bitmapBeen, ImageView ivHead, String filePath) {
        final List<Bitmap> bitmaps = new ArrayList<>();
        for (int i = 0; i < bitmapBeen.size(); i++) {
            try {
                Bitmap bitmap = Glide.with(mContext).load(userInfos.get(i).getHeadImgUrl()).asBitmap().diskCacheStrategy(DiskCacheStrategy.SOURCE).centerCrop().into(200, 200).get();
                getBitmap(bitmapBeen, bitmaps, bitmap);
            } catch (InterruptedException | ExecutionException e) {
                Bitmap bitmap = null;
                getBitmap(bitmapBeen, bitmaps, bitmap);
            } finally {
                if (bitmaps.size() == bitmapBeen.size()) {
                    Bitmap combineBitmap = BitmapUtils.getCombineBitmaps(bitmapBeen, bitmaps);
                    saveNineBitmap(BitmapUtils.getBigBitmaps(combineBitmap), ivHead, filePath);
                }
            }
        }
    }

    private void getBitmap(List<BitmapBean> bitmapBeen, List<Bitmap> bitmaps, Bitmap bitmap) {
        if (bitmap == null) {
            Resources res = mContext.getResources();
            bitmap = BitmapFactory.decodeResource(res, R.drawable.icon_account_no_pic);
        }
        if (null != bitmap) {
            bitmaps.add(ThumbnailUtils.extractThumbnail(bitmap, (int) bitmapBeen
                    .get(0).getWidth(), (int) bitmapBeen.get(0).getWidth()));
        }
    }

    private void saveNineBitmap(final Bitmap mBitmap, final ImageView ivHead, final String filePath) {
        File tempFile = new File(filePath);
        if (tempFile.exists()) tempFile.delete();
        tempFile.getParentFile().mkdirs();
        try {
            FileOutputStream fOut = new FileOutputStream(tempFile);
            mBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
            fOut.flush();
            fOut.close();
            GroupInfo groupInfo = DBHelper.getInstance().queryUniqueGroupInfo(groupId);
            groupInfo.setHeadImgUrl(filePath);
            DBHelper.getInstance().saveGroupInfo(groupInfo);
            if (ivHead != null && Utils.isOnMainThread()) {
                showView(ivHead);
            } else if (ivHead != null) {
                ((Activity) mContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        showView(ivHead, filePath);
                        mBitmap.recycle();
                    }
                });

            }
        } catch (Exception e) {
            saveNineBitmap(mBitmap, ivHead, filePath);
            e.printStackTrace();
        }
    }

    public boolean isExists() {
        File tempFile = new File(filePath);
        return tempFile.exists();
    }

    private String getFilePath() {
        StringBuffer name = new StringBuffer(groupId + ",");
        for (int i = 0; i < userInfos.size(); i++) {
            name.append(userInfos.get(i).getUserId());
            if (i + 1 != userInfos.size()) {
                name.append(",");
            }
        }
        return FileUtils.CAMERA_CACHE_PATH + MD5Util.getMD5Str(name.toString()) + ".cache";
    }


    private void showView(ImageView ivHead) {
        Glide.with(mContext)
                .load(filePath)
                .centerCrop()
                .dontAnimate()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .bitmapTransform(new CropSquareTransformation(mContext))
                .into(ivHead);
    }

    private void showView(ImageView ivHead, String filePath) {
        if (filePath.equals(ivHead.getTag(ivHead.getId())))
            Glide.with(mContext)
                    .load(filePath)
                    .centerCrop()
                    .dontAnimate()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .bitmapTransform(new CropSquareTransformation(mContext))
                    .into(ivHead);
    }

    private void showLoadingHead() {
        Glide.with(mContext)
                .load(R.drawable.icon_account_no_pic)
                .centerCrop()
                .dontAnimate()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .bitmapTransform(new CropSquareTransformation(mContext))
                .into(ivHead);
    }
}
