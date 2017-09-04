package com.ocj.oms.mobile.ui.video.player;

import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.net.URL;
import java.net.URLDecoder;

import static com.ocj.oms.mobile.IntentKeys.VIDEO_URL;

/**
 * Created by liu on 2017/8/2.
 */

public class OcjLiveEmptyActivity extends BaseActivity implements VideoCheckPresenter.IRequestCallBack {

    private VideoCheckPresenter mVideoPresenter;
    String url;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_live_empty_layout;
    }

    @Override
    protected void initEventAndData() {
        showLoading();
        url = getIntent().getStringExtra(VIDEO_URL);
        mVideoPresenter = new VideoCheckPresenter(this,this);
        try {
            String decodedURL = URLDecoder.decode(url, "UTF-8");
            URL _url = new URL(decodedURL);
            String path = _url.getPath();
            String live_shopnum = path.substring(path.lastIndexOf("/") + 1);
            mVideoPresenter.setLive_shopnum(live_shopnum);
        } catch (Exception e) {
            e.printStackTrace();
        }
        mVideoPresenter.checkBarrageUseable();
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A048);
    }

    @Override
    public void complete() {
        hideLoading();
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706A048);
    }
}
