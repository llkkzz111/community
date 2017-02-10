package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.BannerView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuzhao on 16/3/17.
 */
public class GuidedActivity extends BaseActivity {
    private ViewPager vpGuide;
    private int[] guideBg = {R.drawable.img_guide_bg_1, R.drawable.img_guide_bg_2, R.drawable.img_guide_bg_3, R.drawable.img_guide_bg_4};
    private int[] resIds = {R.drawable.img_guide_1, R.drawable.img_guide_2, R.drawable.img_guide_3, R.drawable.img_guide_4};
    private Intent intent = null;
    /**
     * 应用上下文
     */
    private ViewGroup llyt_viewgroup;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        intent = getIntent();
        setContentView(R.layout.activity_guide_layout);
        vpGuide = (ViewPager) findViewById(R.id.vp_viewpager);

        llyt_viewgroup = (ViewGroup) findViewById(R.id.llyt_viewgroup);
        BannerView bannerView = new BannerView(this, llyt_viewgroup, vpGuide);
        setBannerView(bannerView);

    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        this.intent = intent;
    }

    private void startNewActivity(String url) {
        CookieSyncManager.createInstance(getApplicationContext());
        CookieManager.getInstance().removeAllCookie();
        if (this.intent == null)
            intent = getIntent();
        intent.setClass(mContext, LoginActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        intent.putExtra(IntentKeys.KEY_FROM_LOADING, true);
        startActivity(intent);

    }

    /**
     * 设置轮播图视图的一些属性
     *
     * @param bannerView 轮播图对象
     */
    private void setBannerView(final BannerView bannerView) {
        // 设置是否自动轮播
        // bannerView.setAutoPlay(true);
        // bannerView.setAutoPlayIntervalTime(1000);
        // 是否需要循环
        // bannerView.setLoop(true);
        // 是否需要小圆点
        bannerView.setDot(true);
        /** 设置轮播页的图片列表集 */
        bannerView.setOnAddPageView(new BannerView.IBViewSetPageView() {

            @Override
            public List<Object> setPageView() {


                List<Object> views = new ArrayList<Object>();
                for (int i = 0; i < resIds.length; i++) {
                    View v = getLayoutInflater().inflate(R.layout.guide_item_layout, null);
                    RelativeLayout rlGuide = (RelativeLayout) v.findViewById(R.id.rl_guide);
                    rlGuide.setBackgroundResource(guideBg[i]);
                    ImageView img = (ImageView) v.findViewById(R.id.iv_guide);
                    img.setScaleType(ImageView.ScaleType.FIT_CENTER);
                    img.setImageResource(resIds[i]);
                    if (i == resIds.length - 1) {
                        TextView btn = (TextView) v.findViewById(R.id.btn_guide);
                        btn.setVisibility(View.VISIBLE);
                        btn.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                PreferencesUtils.setFirstVisitState(true);

                                if (ConstantUtils.isLogin && ConstantUtils.USER_ID > 0) {
                                    if (intent == null)
                                        intent = getIntent();
                                    intent.setClass(getBaseContext(), MainActivity.class);
                                    startActivity(intent);
                                } else {
                                    startNewActivity(ConstantUtils.URL_ME);
                                }
                                finish();
                            }
                        });
                    }
                    views.add(v);
                }
                return views;
            }
        });
        /**
         * 设置轮播页的轮播点(小圆点图片)列表集接口 <br>
         * */
        bannerView.setOnAddDotView(new BannerView.IBViewSetDotView() {

            @Override
            public void setDotView(ImageView imageView, int positon,
                                   int selected) {
                LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT);
                lparams.setMargins(20, 0, 0, 20);
                imageView.setLayoutParams(lparams);
                // 获取轮播图页数
                // selected < resIds.length 判断确保数组不越界
                if ((positon == selected) && (selected < resIds.length)) {
                    imageView.setBackgroundResource(R.drawable.icon_dot_select);
                } else {
                    imageView
                            .setBackgroundResource(R.drawable.icon_dot_default);
                }
            }
        });
        // 根据前面的设置，初始ViewPager
        try {
            bannerView.displayViewPager();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}