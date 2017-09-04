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

package com.bilibili.socialize.share.core.handler.qq;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.bilibili.socialize.share.core.BiliShareConfiguration;
import com.bilibili.socialize.share.core.SocializeListeners;
import com.bilibili.socialize.share.core.SocializeMedia;
import com.bilibili.socialize.share.core.error.InvalidParamException;
import com.bilibili.socialize.share.core.error.ShareException;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.bilibili.socialize.share.core.shareparam.ShareImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamAudio;
import com.bilibili.socialize.share.core.shareparam.ShareParamImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamText;
import com.bilibili.socialize.share.core.shareparam.ShareParamVideo;
import com.bilibili.socialize.share.core.shareparam.ShareParamWebPage;
import com.tencent.connect.common.Constants;
import com.tencent.connect.share.QzoneShare;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;

import java.util.ArrayList;

/**
 * 只支持图文模式
 * 官方提示:QZone接口暂不支持发送多张图片的能力，若传入多张图片，则会自动选入第一张图片作为预览图。多图的能力将会在以后支持。
 * <p/>
 *
 * @author Jungly
 * @email jungly.ik@gmail.com
 * @since 2015/10/8
 * <p/>
 */
public class QQZoneShareHandler extends BaseQQShareHandler {
    private static final String TAG = "BShare.qq.zone_handler";

    public QQZoneShareHandler(Activity context, BiliShareConfiguration configuration) {
        super(context, configuration);
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data, SocializeListeners.ShareListener listener) {
        super.onActivityResult(activity, requestCode, resultCode, data, listener);
        if (requestCode == Constants.REQUEST_QZONE_SHARE) {
            Log.d(TAG, "handle on activity result");
            Tencent.onActivityResultData(requestCode, resultCode, data, mUiListener);
        }
    }

    @Override
    protected void shareText(ShareParamText params) throws ShareException {
        Log.d(TAG, "share text");
        shareImageText(params, null);
    }

    @Override
    protected void shareImage(ShareParamImage params) throws ShareException {
        Log.d(TAG, "share image");
        shareImageText(params, params.getImage());
    }

    @Override
    protected void shareWebPage(ShareParamWebPage params) throws ShareException {
        Log.d(TAG, "share web page");
        shareImageText(params, params.getThumb());
    }

    @Override
    protected void shareAudio(ShareParamAudio params) throws ShareException {
        Log.d(TAG, "share audio");
        shareImageText(params, params.getThumb());
    }

    @Override
    protected void shareVideo(ShareParamVideo params) throws ShareException {
        Log.d(TAG, "share video");
        shareImageText(params, params.getThumb());
    }

    private void shareImageText(BaseShareParam params, ShareImage image) throws ShareException {
        if (TextUtils.isEmpty(params.getTitle()) || TextUtils.isEmpty(params.getTargetUrl())) {
            throw new InvalidParamException("Title or target url is empty or illegal");
        }

        Log.d(TAG, "share image text");
        Bundle bundle = new Bundle();
        bundle.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE, QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT);
        bundle.putString(QzoneShare.SHARE_TO_QQ_TITLE, params.getTitle());
        bundle.putString(QzoneShare.SHARE_TO_QQ_SUMMARY, params.getContent());
        bundle.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, params.getTargetUrl());

        ArrayList<String> imageUrls = new ArrayList<>();
        if (image != null) {
            if (image.isNetImage()) {
                imageUrls.add(image.getNetImageUrl());
            } else if (image.isLocalImage()) {
                imageUrls.add(image.getLocalPath());
            }
        }
        bundle.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL, imageUrls);

        doShareToQQ((Activity) getContext(), bundle);
    }

    @Override
    protected void onShare(Activity activity, Tencent tencent, Bundle params, IUiListener iUiListener) {
        tencent.shareToQzone(activity, params, iUiListener);
    }

    @Override
    public SocializeMedia getShareMedia() {
        return SocializeMedia.QZONE;
    }
}
