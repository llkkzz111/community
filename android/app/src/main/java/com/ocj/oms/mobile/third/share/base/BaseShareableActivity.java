/*
 * Copyright (c) 2015. BiliBili Inc.
 */

package com.ocj.oms.mobile.third.share.base;

import android.os.Looper;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Toast;

import com.bilibili.socialize.share.core.SocializeMedia;
import com.bilibili.socialize.share.core.error.BiliShareStatusCode;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.third.share.helper.ShareHelper;
import com.ocj.oms.utils.system.AndroidUtil;


/**
 * Share Helper Activity
 *
 * @author yrom
 */
public abstract class BaseShareableActivity extends BaseActivity implements ShareHelper.Callback {
    protected ShareHelper mShare;

    public void startShare(@Nullable View anchor) {
        startShare(anchor, false);
    }

    public void startShare(@Nullable View anchor, boolean isWindowFullScreen) {
        if (mShare == null) {
            mShare = ShareHelper.instance(this, this);
        }
        if (anchor == null) {
            mShare.showShareDialog();
        } else {
            if (isWindowFullScreen)
                mShare.showShareFullScreenWindow(anchor);
            else
                mShare.showShareWarpWindow(anchor);
        }
    }

    @Override
    protected void onDestroy() {
        if (mShare != null) {
            mShare.reset(); // reset held instance
            mShare = null;
        }
        super.onDestroy();
    }

    @Override
    public BaseShareParam getShareContent(ShareHelper helper, SocializeMedia target) {
        return createParams(helper,target);
    }

    @Override
    public void onShareStart(ShareHelper helper) {

    }

    public abstract BaseShareParam createParams(ShareHelper helper,SocializeMedia target);

    @Override
    public void onShareComplete(ShareHelper helper, int code) {
        if (code == BiliShareStatusCode.ST_CODE_SUCCESSED) {
            if (!AndroidUtil.isMainThread())
                Looper.prepare();
            Toast.makeText(this, "分享成功", Toast.LENGTH_SHORT).show();
            if (!AndroidUtil.isMainThread())
                Looper.loop();
            onShareSuccess();
        } else if (code == BiliShareStatusCode.ST_CODE_ERROR) {
            if (!AndroidUtil.isMainThread())
                Looper.prepare();
            Toast.makeText(this, "分享失败", Toast.LENGTH_SHORT).show();
            if (!AndroidUtil.isMainThread())
                Looper.loop();
            onShareFailed();
        } else {
            onShareCancel();
        }

    }

    @Override
    public void onDismiss(ShareHelper helper) {
    }

    @Override
    public void onOutSideClick() {

    }

    @Override
    public void copyGenericClick() {

    }

    public void onShareSuccess() {

    }

    ;

    public void onShareFailed() {

    }

    ;

    public void onShareCancel() {

    }

    ;


}
