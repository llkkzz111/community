package com.ocj.oms.mobile.third.share;

import android.text.TextUtils;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.bilibili.socialize.share.core.SocializeMedia;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.bilibili.socialize.share.core.shareparam.ShareImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamText;
import com.bilibili.socialize.share.core.shareparam.ShareParamWebPage;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.third.share.base.BaseShareableActivity;
import com.ocj.oms.mobile.third.share.helper.ShareHelper;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.Locale;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liu on 2017/6/5.
 */
@Route(path = RouterModule.AROUTER_PATH_SHARE)
public class ShareActivity extends BaseShareableActivity {

    private String TITLE;
    private String CONTENT;
    private String TARGET_URL;
    private String IMAGE_URL;

    @BindView(R.id.btn_share)
    Button btnShare;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_share_layout;
    }

    @Override
    protected void initEventAndData() {
        if (getIntent() == null) {
            finish();
        }
        TITLE = getIntent().getStringExtra("title");
        CONTENT = getIntent().getStringExtra("content");
        IMAGE_URL = getIntent().getStringExtra("image_url");
        TARGET_URL = getIntent().getStringExtra("target_url");

        btnShare.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                btnShare.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                btnShare.performClick();
            }
        });

    }

    @Override
    public BaseShareParam createParams(ShareHelper helper, SocializeMedia target) {
        BaseShareParam param;
        if (TextUtils.isEmpty(TARGET_URL)) {
            param = new ShareParamText(TITLE, CONTENT, TARGET_URL);
        } else {
            param = new ShareParamWebPage(TITLE, CONTENT, TARGET_URL);
            if (!TextUtils.isEmpty(IMAGE_URL)) {
                ShareParamWebPage paramWebPage = (ShareParamWebPage) param;
                paramWebPage.setThumb(generateImage());
            }
        }
        if (target == SocializeMedia.SINA) {
            param.setContent(String.format(Locale.CHINA, "%s #东方购物# ", CONTENT));
        } else if (target == SocializeMedia.GENERIC || target == SocializeMedia.COPY) {
            param.setContent(CONTENT + " " + TARGET_URL);
        }
        return param;
    }


    @OnClick(R.id.btn_share)
    void shareClick(View view) {
        startShare(view, true);
    }

    private ShareImage generateImage() {
        ShareImage image = new ShareImage(IMAGE_URL);
        return image;
    }

    @Override
    public void onDismiss(ShareHelper helper) {

    }

    //分享成功
    @Override
    public void onShareSuccess() {
        if (!"WebView".equals(getIntent().getStringExtra("from"))) {
            RouterModule.invokeShareResult("1");
        }
        finishPage();
    }

    //分享失败
    @Override
    public void onShareFailed() {
        if (!"WebView".equals(getIntent().getStringExtra("from"))) {
            RouterModule.invokeShareResult("0");
        }
        finishPage();
    }

    //分享取消
    @Override
    public void onShareCancel() {
        if (!"WebView".equals(getIntent().getStringExtra("from"))) {
            RouterModule.invokeShareResult("2");
        }
        finishPage();
    }

    @Override
    public void onOutSideClick() {
        onShareCancel();
    }

    @Override
    public void copyGenericClick() {
        onShareSuccess();
    }

    private void finishPage() {
        finish();
        overridePendingTransition(0, 0);
    }

    @Override
    public void onBackPressed() {
        onShareCancel();
    }

}
