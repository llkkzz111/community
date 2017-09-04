package com.ocj.oms.mobile.ui.video.player;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.bilibili.socialize.share.core.SocializeMedia;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.bilibili.socialize.share.core.shareparam.ShareImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamText;
import com.bilibili.socialize.share.core.shareparam.ShareParamWebPage;
import com.jz.jizhalivesdk.Bean.JZLiveRecord;
import com.jz.jizhalivesdk.Bean.JZLiveUser;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.third.share.helper.ShareHelper;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Administrator on 2017/6/19.
 */

public class OcjLiveActivity extends RxVideoActivity {
    public static final String LIVE_RECORD_INFO = "RECORDINFO";
    public static final String LIVE_BASIC_INFO = "BASICINFO";
    private LiveBasicInfoBean basicInfo;

    public RelativeLayout rl_webinclude, rl_shopweb;
    public ImageView uservideo_img_redpacket, uservideo_img_shop, uservideo_img_activityrules, iv_webincludeback, iv_webshopback;
    private WebView web_shop, web_redpacket, web_activityrules, web_shopfull;
    public String shopurl, redpacturl, activityrulesurl;

    private Timer timer;
    private long leftSeconds;
    private Handler handler = new Handler() {

        public void handleMessage(Message msg) {
            if (msg.what == 0) {
                uservideo_rl.setVisibility(View.VISIBLE);
                rl_input.setVisibility(View.VISIBLE);
                rl_webinclude.setVisibility(View.GONE);
                web_redpacket.clearHistory();
                web_activityrules.clearHistory();
                web_shopfull.clearHistory();
                web_redpacket.setVisibility(View.GONE);
                web_redpacket.loadUrl("about:blank");
                web_activityrules.setVisibility(View.GONE);
                web_shopfull.setVisibility(View.GONE);
            } else if (msg.what == 1) {
                countDown(1);
            } else if (msg.what == 2) {
                countDown(2);
            }
        }
    };

    private String TITLE;
    private String CONTENT;
    private String TARGET_URL;
    private String IMAGE_URL;

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        uservideo_img_redpacket.setImageResource(R.drawable.barrage_control_bg);
        uservideo_img_shop.setImageResource(R.drawable.barrage_shop);
        uservideo_img_share.setImageResource(R.drawable.barrage_share);
        uservideo_img_activityrules.setImageResource(R.drawable.barrage_rule);
        tv_redpacket.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
        tv_redpacket.setTextColor(Color.WHITE);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
    }

    @Override
    protected void initData() {
        this.liveRecord = (JZLiveRecord) getIntent().getSerializableExtra(LIVE_RECORD_INFO);
        basicInfo = (LiveBasicInfoBean) getIntent().getSerializableExtra(LIVE_BASIC_INFO);
        this.liveUser = JZLiveUser.getUser();
        shopurl = OcjUrls.BARRAGEPRODUCTSURL + basicInfo.getShop_no();
        redpacturl = String.format(OcjUrls.BARRAGEURL, basicInfo.getShop_no(), basicInfo.getEvent_no());
        activityrulesurl = OcjUrls.BARRAGERULEURL + basicInfo.getEvent_no();

        TITLE = basicInfo.getShare_title();
        CONTENT = basicInfo.getShare_content();
        TARGET_URL = basicInfo.getShare_url();
        IMAGE_URL = basicInfo.getShare_pic();

    }

    @Override
    public BaseShareParam getShareContent(ShareHelper helper, SocializeMedia target) {
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

    private ShareImage generateImage() {
        ShareImage image = new ShareImage(IMAGE_URL);
        return image;
    }

    @Override
    protected void initView() {
        rl_webinclude = (RelativeLayout) findViewById(com.jz.jizhalivesdk.R.id.rl_webinclude);
        rl_shopweb = (RelativeLayout) findViewById(com.jz.jizhalivesdk.R.id.rl_shopweb);
        uservideo_img_redpacket = (ImageView) findViewById(com.jz.jizhalivesdk.R.id.uservideo_img_redpacket);
        uservideo_img_shop = (ImageView) findViewById(com.jz.jizhalivesdk.R.id.uservideo_img_shop);
        uservideo_img_activityrules = (ImageView) findViewById(com.jz.jizhalivesdk.R.id.uservideo_img_activityrules);
        iv_webincludeback = (ImageView) findViewById(com.jz.jizhalivesdk.R.id.iv_webincludeback);
        iv_webshopback = (ImageView) findViewById(com.jz.jizhalivesdk.R.id.iv_webshopback);
        web_shop = (WebView) findViewById(com.jz.jizhalivesdk.R.id.web_shop);
        web_redpacket = (WebView) findViewById(com.jz.jizhalivesdk.R.id.web_redpacket);
        web_activityrules = (WebView) findViewById(com.jz.jizhalivesdk.R.id.web_activityrules);
        web_shopfull = (WebView) findViewById(com.jz.jizhalivesdk.R.id.web_shopfull);
        web_shop.setBackgroundColor(0);
        web_shop.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        web_shop.setWebChromeClient(new WebChromeClient());
        web_shop.setWebViewClient(webViewClient);
        web_shop.getSettings().setSupportZoom(true);          //支持缩放
        web_shop.getSettings().setBuiltInZoomControls(true);  //启用内置缩放装置
        web_shop.getSettings().setJavaScriptEnabled(true);    //启用JS脚本
        web_shop.getSettings().setUserAgentString(Tools.getUserAgent(this));
        web_redpacket.setBackgroundColor(0);
//        web_redpacket.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        web_redpacket.setWebChromeClient(new WebChromeClient());
        web_redpacket.setWebViewClient(webViewClient);
        web_redpacket.getSettings().setSupportZoom(true);          //支持缩放
        web_redpacket.getSettings().setBuiltInZoomControls(true);  //启用内置缩放装置
        web_redpacket.getSettings().setJavaScriptEnabled(true);    //启用JS脚本
        web_redpacket.getSettings().setUserAgentString(Tools.getUserAgent(this));
        web_redpacket.addJavascriptInterface(new BarragescriptInterface(this), "Ocj");
        web_activityrules.setBackgroundColor(0);
        web_activityrules.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        web_activityrules.setWebChromeClient(new WebChromeClient());
        web_activityrules.getSettings().setSupportZoom(true);          //支持缩放
        web_activityrules.getSettings().setBuiltInZoomControls(true);  //启用内置缩放装置
        web_activityrules.getSettings().setJavaScriptEnabled(true);    //启用JS脚本
        web_activityrules.getSettings().setUserAgentString(Tools.getUserAgent(this));
        web_activityrules.setWebViewClient(webViewClient);
        web_shopfull.setBackgroundColor(0);
        web_shopfull.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        web_shopfull.setWebChromeClient(new WebChromeClient());
        web_shopfull.getSettings().setSupportZoom(true);          //支持缩放
        web_shopfull.getSettings().setBuiltInZoomControls(true);  //启用内置缩放装置
        web_shopfull.getSettings().setJavaScriptEnabled(true);    //启用JS脚本
        web_shopfull.getSettings().setUserAgentString(Tools.getUserAgent(this));
        web_shopfull.setWebViewClient(webViewClient);
        uservideo_img_redpacket.setOnClickListener(this);
        uservideo_img_shop.setOnClickListener(this);
        uservideo_img_activityrules.setOnClickListener(this);
        iv_webincludeback.setOnClickListener(this);
        iv_webshopback.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        checkTimeLeft();
    }

    @Override
    protected void LiveShare() {
        showShareDialog();
    }

    @Override
    protected void LiveFinish() {
        stopTimer();
    }

    @Override
    protected void onClickItem(int i) {
        if (i == com.jz.jizhalivesdk.R.id.uservideo_img_redpacket) {
            /*if (redpacturl != null) {
                if (web_redpacket != null) {
                    web_redpacket.loadUrl(redpacturl);
                }
                uservideo_rl.setVisibility(View.GONE);
                rl_input.setVisibility(View.GONE);
                rl_webinclude.setVisibility(View.VISIBLE);
                web_redpacket.setVisibility(View.VISIBLE);
            } else {
                Toast.makeText(this, "暂无信息", Toast.LENGTH_SHORT).show();
            }*/
        } else if (i == com.jz.jizhalivesdk.R.id.uservideo_img_shop) {
            if (shopurl != null) {
                if (web_shop != null) {
                    web_shop.loadUrl(shopurl);
                }
                uservideo_rl.setVisibility(View.GONE);
                rl_input.setVisibility(View.GONE);
                rl_shopweb.setVisibility(View.VISIBLE);
                web_shop.setVisibility(View.VISIBLE);
            } else {
                Toast.makeText(this, "暂无信息", Toast.LENGTH_SHORT).show();
            }
        } else if (i == com.jz.jizhalivesdk.R.id.uservideo_img_activityrules) {
            if (activityrulesurl != null) {
                if (web_activityrules != null) {
                    web_activityrules.loadUrl(activityrulesurl);
                }
                uservideo_rl.setVisibility(View.GONE);
                rl_input.setVisibility(View.GONE);
                rl_webinclude.setVisibility(View.VISIBLE);
                web_activityrules.setVisibility(View.VISIBLE);
            } else {
                Toast.makeText(this, "暂无信息", Toast.LENGTH_SHORT).show();
            }
        } else if (i == com.jz.jizhalivesdk.R.id.iv_webincludeback) {
            if (web_redpacket.canGoBack() && web_redpacket != null) {
                web_redpacket.goBack();
            } else if (web_activityrules.canGoBack() && web_activityrules != null) {
                web_activityrules.goBack();
            } else if (web_shopfull.canGoBack() && web_shopfull != null) {
                web_shopfull.goBack();
            } else {
                uservideo_rl.setVisibility(View.VISIBLE);
                rl_input.setVisibility(View.VISIBLE);
                rl_webinclude.setVisibility(View.GONE);
                web_redpacket.clearHistory();
                web_activityrules.clearHistory();
                web_shopfull.clearHistory();
                web_redpacket.setVisibility(View.GONE);
                web_activityrules.setVisibility(View.GONE);
                web_shopfull.setVisibility(View.GONE);
            }
        } else if (i == com.jz.jizhalivesdk.R.id.iv_webshopback) {
            if (web_shop.canGoBack()) {
                if (web_shop != null) {
                    web_shop.goBack();
                    web_shop.clearHistory();
                }
            } else {
                uservideo_rl.setVisibility(View.VISIBLE);
                rl_input.setVisibility(View.VISIBLE);
                rl_shopweb.setVisibility(View.GONE);
                web_shop.setVisibility(View.GONE);
                web_shop.clearHistory();
            }
        }
    }

    //检查红包倒计时
    private void checkTimeLeft() {
        Map<String, Object> params = new HashMap<>();
        params.put("event_no", basicInfo.getEvent_no());
        new VideoMode(this).checkBarrageTime(params, new ApiResultObserver<BarrageTimeBean>(this) {
            @Override
            public void onSuccess(BarrageTimeBean apiResult) {
                try {
                    checkStatus(apiResult);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(ApiException e) {

            }
        });

    }

    private void checkStatus(BarrageTimeBean bean) throws Exception {
        String code = bean.getCode();
        String end_batch_flag = bean.getEnd_batch_flag();
        String batch_no = bean.getBatch_no();
        String second = bean.getSecond();

        //红包未开始，但要判断是直播前还是直播已经开始（因为红包是在直播开始以后过几分钟才开抢）
        /*if("0".equals(code)){
            if(basicInfo.getLive_begin_left_time().startsWith("-")){
                //已经在直播了，且是第一场红包之前
                long barrageTimeLeft=Long.parseLong(basicInfo.getLive_begin_left_time())+Long.parseLong(basicInfo.getFirst_event_time())*60*1000;
                long minute=barrageTimeLeft/1000/60;
                long seconds=(barrageTimeLeft/1000)%60;
                leftSeconds=barrageTimeLeft/1000;
//                tv_redpacket.setText(basicInfo.getFirst_evt_word()+":"+leftSeconds+"秒");
                tv_redpacket.setText(getTimeLeft());
                start();

            }else{
                //直播前(设置直播开始时间)
                Calendar c = Calendar.getInstance();
                long beginTime=Long.parseLong(basicInfo.getLive_begin_time());
                c.setTimeInMillis(beginTime);
                c.get(Calendar.HOUR_OF_DAY);
                c.get(Calendar.MINUTE);
//                tv_redpacket.setText(c.get(Calendar.HOUR_OF_DAY)+":"+c.get(Calendar.MINUTE)+"开播");
                tv_redpacket.setText("未开始");
            }
        }*/

        if ("0".equals(code)) {
            long timeGap = Long.parseLong(second) - Long.parseLong(basicInfo.getFirst_event_time()) * 60;

            if (timeGap > 0) {
                //直播前(需要启动倒计时，计算直播前时间)
                tv_redpacket.setText("未开始");
                leftSeconds = timeGap;
                start(2);

            } else {
                //已经在直播了，且是第一场红包之前
                leftSeconds = Long.parseLong(second);
                tv_redpacket.setText(getTimeLeft());
                start(1);
            }
        }

        //本场红包已经抽过了，同时要判断是否是最后一场
        else if ("1".equals(code)) {
            leftSeconds = Long.parseLong(second);
//            tv_redpacket.setText(basicInfo.getNext_evt_word()+":"+leftSeconds+"秒");
            tv_redpacket.setText(leftSeconds + "");
            start(1);
        }

        //本场红包正在进行，直接弹出红包页面
        else if ("2".equals(code)) {
            tv_redpacket.setText(basicInfo.getDo_evt_word());
            showBarrage();
        }

        //全部红包活动已经结束
        else if ("3".equals(code)) {
//            tv_redpacket.setText(basicInfo.getOver_evt_word());
            tv_redpacket.setText("已结束");
        }
    }


    public void start(final int type) {
        stopTimer();
        if (timer == null) {
            timer = new Timer();
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    handler.sendEmptyMessage(type);
                }
            }, 0, 1000);
        }
    }

    private void stopTimer() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    private void countDown(int type) {
        leftSeconds--;
        if (type == 1) {
            if (leftSeconds <= 3) {
                stopTimer();
                tv_redpacket.setText(basicInfo.getDo_evt_word());
                showBarrage();
            } else {
            /*String prefix= (String) tv_redpacket.getText();
            prefix=prefix.substring(0,prefix.indexOf(":"));
            tv_redpacket.setText(prefix+":"+leftSeconds+"秒");*/
                tv_redpacket.setText(getTimeLeft());
            }
        } else if (type == 2) {
            if (leftSeconds <= -2) {
                checkTimeLeft();
                stopTimer();
            }
        }
    }

    //显示红包活动
    private void showBarrage() {
        if (redpacturl != null) {
            if (web_redpacket != null) {
                web_redpacket.loadUrl(redpacturl);
            }
            uservideo_rl.setVisibility(View.GONE);
            rl_input.setVisibility(View.GONE);
            rl_webinclude.setVisibility(View.VISIBLE);
            web_redpacket.setVisibility(View.VISIBLE);
            web_activityrules.setVisibility(View.GONE);
            web_shop.setVisibility(View.GONE);
            rl_shopweb.setVisibility(View.GONE);
        } else {
            Toast.makeText(this, "暂无信息", Toast.LENGTH_SHORT).show();
        }
    }

    WebViewClient webViewClient = new WebViewClient() {
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView webView, String url) {
            if (url.contains("mobileappdetail/")) {
                String orgurl = webView.getOriginalUrl();
                webView.stopLoading();
                //todo 进入商品详情页面
                String itemCode = url.substring(url.indexOf("mobileappdetail/") + "mobileappdetail/".length());
                RouterModule.globalToDetail(itemCode);
                finishPlay();
                finish();
                return true;
            }
            return false;
        }
    };

    private void finishPlay() {
        MediaPlayerDestroy();
        stopTimer();
    }


    public class BarragescriptInterface {

        private Context context;

        public BarragescriptInterface(Context context) {
            this.context = context;
        }

        @android.webkit.JavascriptInterface
        public void nextEventTime() {
            checkTimeLeft();
        }

        @android.webkit.JavascriptInterface
        public void closeGameWebview() {
            handler.sendEmptyMessage(0);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        stopTimer();
    }

    private void showShareDialog() {
        startShare(null);
    }

    private String getTimeLeft() {
        long minute = leftSeconds / 60;
        long second = leftSeconds % 60;
        return unitFormat(minute) + ":" + unitFormat(second);
    }

    private String unitFormat(long i) {
        String retStr = null;
        if (i >= 0 && i < 10)
            retStr = "0" + Long.toString(i);
        else
            retStr = "" + i;
        return retStr;
    }

}
