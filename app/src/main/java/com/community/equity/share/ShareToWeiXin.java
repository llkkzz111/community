package com.community.equity.share;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.GlideBitmapDrawable;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.community.equity.R;
import com.community.equity.entity.ShareWechatInfo;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.UIManager;
import com.community.equity.utils.Utils;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import java.io.ByteArrayOutputStream;

/**
 * // 微信分享 msg.thumbData 不能大于32K 是 byte[] 而不是bitmap对象
 */
public class ShareToWeiXin {
    private IWXAPI iWXapi;


    public void RegisterApp() {
        // 注册微信
        iWXapi = WXAPIFactory.createWXAPI(UIManager.getInstance().getBaseContext(), ConstantUtils.WEIXIN_APPID, false);
        iWXapi.registerApp(ConstantUtils.WEIXIN_APPID);
    }


    public void sendMessage(final int WXScene, ShareWechatInfo wechatInfo) {
        if (iWXapi.isWXAppInstalled()) {
            try {

                WXWebpageObject webpage = new WXWebpageObject();
                webpage.webpageUrl = wechatInfo.getLink();
                final WXMediaMessage msg = new WXMediaMessage(webpage);
                if (WXScene == SendMessageToWX.Req.WXSceneSession) {
                    //微信
                    msg.title = wechatInfo.getTitle();
                    msg.description = wechatInfo.getDesc();

                } else if (WXScene == SendMessageToWX.Req.WXSceneTimeline) {
                    //朋友圈
                    msg.title = wechatInfo.getTitle() + "  " + Utils.formatStr(wechatInfo.getDesc());
                    msg.description = wechatInfo.getDesc();
                }


                final SendMessageToWX.Req req = new SendMessageToWX.Req();
                req.transaction = buildTransaction("webpage");
                req.message = msg;
                req.scene = WXScene;
                // 图片
                String imageUrl = null;
                if (wechatInfo != null && !TextUtils.isEmpty(wechatInfo.getImage())) {

                    imageUrl = wechatInfo.getImage();
                    Glide.with(UIManager.getInstance().getBaseContext()).load(imageUrl).into(new SimpleTarget<GlideDrawable>() {
                        @Override
                        public void onResourceReady(GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) {
                            Drawable drawable = resource.getCurrent();
                            GlideBitmapDrawable bd = (GlideBitmapDrawable) drawable.getCurrent();
                            if (null != bd.getBitmap()) {
                                msg.thumbData = compressImage(bd.getBitmap());
                            }
                            iWXapi.sendReq(req);
//
                        }
                    });

                } else {
                    Bitmap rawBitmap = BitmapFactory.decodeResource(UIManager.getInstance().getBaseContext().getResources(), R.drawable.icon_logo);
                    msg.thumbData = compressImage(rawBitmap);
                    iWXapi.sendReq(req);
                }

            } catch (Exception e) {
                Toast.makeText(UIManager.getInstance().getBaseContext(), "-------出现bug了", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(UIManager.getInstance().getBaseContext(), UIManager.getInstance().getBaseContext().getResources().getString(R.string.share_weixin_toast), Toast.LENGTH_SHORT).show();
        }
    }

    // 压缩图片 微信
    private byte[] compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while (baos.toByteArray().length / 1024 > 30) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();// 重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);// 这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;// 每次都减少10
        }

        return baos.toByteArray();
    }

    private String buildTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }


    public void unRegisterApp() {
        iWXapi.unregisterApp();
    }

}
