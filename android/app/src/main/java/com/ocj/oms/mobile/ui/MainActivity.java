package com.ocj.oms.mobile.ui;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.support.v4.hardware.fingerprint.FingerprintManagerCompat;
import android.support.v4.os.CancellationSignal;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.CheckUpdateBean;
import com.ocj.oms.mobile.bean.EventResultsItem;
import com.ocj.oms.mobile.bean.RetExJson;
import com.ocj.oms.mobile.dialog.CommonDialogFragment;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.dialog.PaySafeVerifyActivity;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.third.share.ShareActivity;
import com.ocj.oms.mobile.ui.createcomment.CreateComentActivity;
import com.ocj.oms.mobile.ui.global.GlobalListActivity;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.personal.order.OrderPayActivity;
import com.ocj.oms.mobile.ui.personal.order.OrderPaySuccedActivity;
import com.ocj.oms.mobile.ui.personal.order.RetExGoodsActivity;
import com.ocj.oms.mobile.ui.personal.order.dialog.CutEventDialog;
import com.ocj.oms.mobile.ui.personal.order.dialog.CutEventDialogFragment;
import com.ocj.oms.mobile.ui.personal.setting.SettingActivity;
import com.ocj.oms.mobile.ui.personal.wallet.imprest.ImprestDetailsActivity;
import com.ocj.oms.mobile.ui.personal.wallet.integral.IntegralDetailsActivity;
import com.ocj.oms.mobile.ui.personal.wallet.opoint.OcouponsDetailActivity;
import com.ocj.oms.mobile.ui.personal.wallet.packs.GiftcardsDetailActivity;
import com.ocj.oms.mobile.ui.personal.wallet.vouchers.VocherDetailActivity;
import com.ocj.oms.mobile.ui.redpacket.LotteryActivity;
import com.ocj.oms.mobile.ui.scan.ScannerActivity;
import com.ocj.oms.mobile.ui.sign.SignActivity;
import com.ocj.oms.mobile.ui.video.VideoDetailActivity;
import com.ocj.oms.mobile.ui.video.VideoPlayActivity;
import com.ocj.oms.mobile.ui.video.player.OcjLiveEmptyActivity;
import com.ocj.oms.mobile.ui.video.player.VideoCheckPresenter;
import com.ocj.oms.mobile.ui.webview.WebViewActivity;
import com.ocj.oms.mobile.utils.NotificationUtils;
import com.ocj.oms.view.BottomNavigationViewEx;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.data.JPushLocalNotification;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_CONTENT_CODE;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_SEARCH_ITEM;
import static com.ocj.oms.mobile.IntentKeys.VIDEO_URL;

public class MainActivity extends BaseActivity {

    @BindView(R.id.tab)
    BottomNavigationViewEx tab;
    private FingerprintManagerCompat manager;
    private CommonDialogFragment dialogFragment;
    private CancellationSignal cancellationSignal;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_main_layout;
    }

    @Override
    protected void initEventAndData() {
        tab.enableAnimation(false);
        tab.enableShiftingMode(false);
        tab.enableItemShiftingMode(false);
        manager = FingerprintManagerCompat.from(this);
        dialogFragment = CommonDialogFragment.newInstance();
        cancellationSignal = new CancellationSignal();
    }

    public class MyCallBack extends FingerprintManagerCompat.AuthenticationCallback {
        private static final String TAG = "MyCallBack";
        private int count = 0;

        // 当出现错误的时候回调此函数，比如多次尝试都失败了的时候，errString是错误信息
        @Override
        public void onAuthenticationError(int errMsgId, CharSequence errString) {

        }

        // 当指纹验证失败的时候会回调此函数，失败之后允许多次尝试，失败次数过多会停止响应一段时间然后再停止sensor的工作
        @Override
        public void onAuthenticationFailed() {
            count++;
            if (count < 3) {
                dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                    @Override
                    public void initData() {
                        dialogFragment.setTopImage(R.drawable.icon_finger)
                                .setTitle("再试一次")
                                .setContent("通过home键验证已有指纹")
                                .setNegative("取消")
                                .setNegativeListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        dialogFragment.dismiss();
                                        cancellationSignal.cancel();
                                    }
                                });
                    }
                });
            } else {
                cancellationSignal.cancel();
                dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                    @Override
                    public void initData() {
                        dialogFragment.setTopImage(R.drawable.icon_finger)
                                .setTitle("指纹验证失败")
                                .setContent("请通过密码或验证码进行校验")
                                .setNegative("取消")
                                .setNegativeListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        dialogFragment.dismiss();
                                        cancellationSignal.cancel();
                                    }
                                });
                    }
                });
            }

        }

        @Override
        public void onAuthenticationHelp(int helpMsgId, CharSequence helpString) {
        }

        // 当验证的指纹成功时会回调此函数，然后不再监听指纹sensor
        @Override
        public void onAuthenticationSucceeded(FingerprintManagerCompat.AuthenticationResult
                                                      result) {
            dialogFragment.dismiss();
            ToastUtils.showShortToast("验证成功");
        }
    }


    @OnClick({R.id.btn2,
            R.id.btn3, R.id.btn6, R.id.btn7, R.id.btn8,
            R.id.btn10, R.id.btn11, R.id.btn12,
            R.id.btn15, R.id.btn101, R.id.btnylc1, R.id.btn_location, R.id.btn_vip,
            R.id.btn_scan, R.id.btn_red_packet, R.id.btn16, R.id.btn_paysucced, R.id.btn_vidio_playing,
            R.id.btn_news, R.id.btn_reserve_order, R.id.btn_update, R.id.btn_finger, R.id.btn_pay_verify, R.id.btn_video_detail})
    public void onButtonClick(View view) {
        Intent intent = new Intent();
        switch (view.getId()) {
            case R.id.btn2:
                intent.setClass(MainActivity.this, LoginActivity.class);
                break;
            case R.id.btn3:
                intent.setClass(MainActivity.this, OrderPayActivity.class);
                break;
            case R.id.btn6:
                intent.setClass(MainActivity.this, IntegralDetailsActivity.class);
                break;
            case R.id.btn7:
                intent.setClass(MainActivity.this, ImprestDetailsActivity.class);
                break;

            case R.id.btn8:
                intent.setClass(MainActivity.this, GiftcardsDetailActivity.class);
                break;

            case R.id.btn10:
                intent.setClass(MainActivity.this, OcouponsDetailActivity.class);
                break;
            case R.id.btn11:
                intent.setClass(MainActivity.this, VocherDetailActivity.class);
                break;

            case R.id.btn12:
                intent.setClass(MainActivity.this, SettingActivity.class);
                break;


            case R.id.btn101:
                intent.setClass(MainActivity.this, AbroadBuyActivity.class);
                break;
            case R.id.btnylc1:
                intent.setClass(MainActivity.this, CreateComentActivity.class);
                break;


            case R.id.btn15:
                intent = new Intent(MainActivity.this, GlobalListActivity.class);
                intent.putExtra(GLOBAL_SEARCH_ITEM, "厨房用具");
                intent.putExtra(GLOBAL_CONTENT_CODE, "");
                break;
            case R.id.btn_location:
                intent.setClass(MainActivity.this, LocaleActivity.class);
                break;
            case R.id.btn_vip:
                intent.setClass(MainActivity.this, VipInfoActivity.class);
                break;
            case R.id.btn_scan:
                intent.setClass(MainActivity.this, ScannerActivity.class);
                break;
            case R.id.btn_red_packet:
                intent.setClass(MainActivity.this, LotteryActivity.class);
                break;
            case R.id.btn16:
                intent.setClass(MainActivity.this, SignActivity.class);
                break;

            case R.id.btn_paysucced:
                intent.setClass(MainActivity.this, OrderPaySuccedActivity.class);
                break;


            case R.id.btn_pay_verify:
                intent.setClass(MainActivity.this, PaySafeVerifyActivity.class);
                break;

            case R.id.btn_vidio_playing:
                intent.setClass(MainActivity.this, VideoPlayActivity.class);
                intent.putExtra(IntentKeys.PLAY_TAG, 1);
                break;
            case R.id.btn_reserve_order:
                intent.setClass(MainActivity.this, ReserveOrderActivity.class);
                break;

            case R.id.btn_update:
                new AccountMode(mContext).checkUpdate("IOS", "1.0.0", new ApiResultObserver<CheckUpdateBean>(mContext) {
                    @Override
                    public void onSuccess(CheckUpdateBean apiResult) {
                        final CheckUpdateBean bean = apiResult;
                        final CommonDialogFragment updateDialog = CommonDialogFragment.newInstance(R.layout.dialog_update_layout);
                        updateDialog.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                            @Override
                            public void initData() {
                                View update = updateDialog.getViewByRootViewId(R.id.tv_update);
                                TextView updateContent = (TextView) updateDialog.getViewByRootViewId(R.id.tv_update_content);
                                updateContent.setText(bean.getApp_ver_tip());
                                update.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        if (TextUtils.equals(bean.getApp_ver_target(), "MARKET")) {
                                            try {
                                                Intent viewIntent = new Intent(Intent.ACTION_VIEW,
                                                        Uri.parse("market://details?id=com.ocj.oms.mobile"));
                                                viewIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                                startActivity(viewIntent);
                                            } catch (Exception e) {
                                                Toast.makeText(mContext, "您的手机没有安装Android应用市场", Toast.LENGTH_SHORT).show();
                                                e.printStackTrace();
                                            }
                                        } else {
                                            Intent intent = new Intent();
                                            intent.setAction("android.intent.action.VIEW");
                                            Uri content_url = Uri.parse(bean.getApp_ver_url());
                                            intent.setData(content_url);
                                            startActivity(intent);
                                        }
                                    }
                                });
                                updateDialog.getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
                                    @Override
                                    public boolean onKey(DialogInterface dialogInterface, int keyCode, KeyEvent keyEvent) {
                                        return keyCode == KeyEvent.KEYCODE_BACK;
                                    }
                                });
                            }
                        });
                        updateDialog.show(getFragmentManager(), "1");

                    }

                    @Override
                    public void onError(ApiException e) {
                        ToastUtils.showShortToast(e.getMessage());
                    }
                });

                return;
            case R.id.btn_finger:
                if (manager.isHardwareDetected() && manager.hasEnrolledFingerprints()) {
                    if (cancellationSignal.isCanceled()) {
                        cancellationSignal = new CancellationSignal();
                    }
                    manager.authenticate(null, 0, cancellationSignal, new MyCallBack(), null);
                    dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                        @Override
                        public void initData() {
                            dialogFragment.setTopImage(R.drawable.icon_finger)
                                    .setTitle("指纹安全校验")
                                    .setTitleSize(17)
                                    .setTitleClolor(R.color.black)
                                    .setContent("通过home键验证已有指纹")
                                    .setContentClolor(R.color.text_grey_666666)
                                    .setContentSize(14)
                                    .setNegative("取消")
                                    .setNegativeClolor(R.color.text_grey_666666)
                                    .setNegativeSize(17)
                                    .setNegativeListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View view) {
                                            dialogFragment.dismiss();
                                            cancellationSignal.cancel();
                                        }
                                    });
                        }
                    });
                    dialogFragment.show(getFragmentManager(), "2");
                } else {
                    ToastUtils.showShortToast("没有指纹");
                }
                return;
            case R.id.btn_notification:
                NotificationUtils notificationUtils = new NotificationUtils(mContext);
                notificationUtils.setApkUrl("http://image1.ocj.com.cn/image_site/app_wap/p/dd/app-android-v4.1.1-401.apk");
                notificationUtils.sendNotification();
                return;
            case R.id.btn_video_detail:
                intent.setClass(MainActivity.this, VideoDetailActivity.class);
                break;
        }
        startActivity(intent);
    }

    private int id = 1111111111;

    @OnClick(R.id.btn_return_goods)
    public void returnClick(View view) {

        DialogFactory.showNoIconDialog(getString(R.string.sign_string), null, "确认", new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        }).show(getFragmentManager(), "edit");

        JPushLocalNotification ln = new JPushLocalNotification();
        ln.setBuilderId(0);
        ln.setContent("消息推送测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容");
        ln.setTitle("消息推送测试标题");
        ln.setNotificationId(++id);
        ln.setBroadcastTime(System.currentTimeMillis() + 1000 * 3);


        //"ewogICAgInRvUGFnZSI6ICJpT1NvY2pfV2ViVmlldyIsCiAgICAicGFyYW1zIjogewogICAgICAgICJ1cmwiOiAid3d3LmJhaWR1LmNvbSIKICAgIH0KfQ=="

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("extraskey", "ewogICAgInRvUGFnZSI6ICJXZWJWaWV3IiwKICAgICJwYXJhbXMiOiB7CiAgICAgICAgInVybCI6ICJodHRwOi8vd3d3Lm9jai5jb20uY24vY2F0YWxvZy8xNjQiCiAgICB9Cn0=");
        JSONObject json = new JSONObject(map);
        ln.setExtras(json.toString());
        JPushInterface.addLocalNotification(getApplicationContext(), ln);

//        Intent intent = new Intent();
//
//        RetExJson jsonData = new RetExJson();
//        RetExJson.RetExJsonItem item = new RetExJson.RetExJsonItem();
//
//        item.contentLink = "https://www.baidu.com/img/bd_logo1.png";
//        item.item_name = "标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
//        item.dt_info = "红色,38寸";
//        item.rsale_amt = "3000";
//        item.saveamt = "2";
//        item.orderType = "Y";
//        item.order_g_seq = "001";//订单商品序号
//        item.order_d_seq = "001";//赠品序号
//        item.order_w_seq = "001";//操作序号
//        item.receiver_seq = "0000001531";//退换货地址编码
//        item.item_code = "2831282013";//回收商品编号
//        item.unit_code = "001";//回收商品单件号
//        item.item_qty = "1";//退货/交换数量
//
//        ArrayList<RetExJson.RetExJsonItem> theList = new ArrayList<>();
//        theList.add(item);
//
//        jsonData.retExchYn = "1";
//        jsonData.orderNo = "20170606120360";
//        jsonData.items = theList;
//
//        String json = new Gson().toJson(jsonData);
//        intent.putExtra("data", json);
//
//        intent.setClass(MainActivity.this, RetExGoodsActivity.class);
//        startActivity(intent);
    }

    @OnClick(R.id.btn_exchange_goods)
    public void exchangeClick(View view) {
        Intent intent = new Intent();

        RetExJson jsonData = new RetExJson();
        RetExJson.RetExJsonItem item = new RetExJson.RetExJsonItem();

        item.contentLink = "https://www.baidu.com/img/bd_logo1.png";
        item.item_name = "标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
        item.dt_info = "红色,38寸";
        item.rsale_amt = "3000";
        item.saveamt = "2";
        item.orderType = "Y";
        item.order_g_seq = "001";//订单商品序号
        item.order_d_seq = "001";//赠品序号
        item.order_w_seq = "001";//操作序号
        item.receiver_seq = "0000001531";//退换货地址编码
        item.item_code = "2831282013";//回收商品编号
        item.unit_code = "001";//回收商品单件号
        item.item_qty = "1";//退货/交换数量

        ArrayList<RetExJson.RetExJsonItem> theList = new ArrayList<>();
        theList.add(item);

        jsonData.retExchYn = "2";
        jsonData.orderNo = "20170606120360";
        jsonData.items = theList;

        String json = new Gson().toJson(jsonData);
        intent.putExtra("data", json);

        intent.setClass(MainActivity.this, RetExGoodsActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.btn_ui_test)
    void onUITestClick(View view) {
//        startActivity(new Intent(mContext, UiTestActivity.class));
        new ItemsMode(mContext).getFullCutEvents(new ApiResultObserver<List<EventResultsItem>>(mContext) {
            @Override
            public void onSuccess(List<EventResultsItem> apiResult) {
                showEventDialog(apiResult);
            }

            @Override
            public void onError(ApiException e) {

            }
        });
    }

    private CutEventDialog dialog;

    private void showEventDialog(List<EventResultsItem> list) {
        if (list == null || list.size() == 0) {
            return;
        }

        FragmentTransaction mFragTransaction = getFragmentManager().beginTransaction();
        Fragment fragment = getFragmentManager().findFragmentByTag("dialogFragment");
        if (fragment != null) {
            mFragTransaction.remove(fragment);
        }

        final CutEventDialogFragment dialogFragment = CutEventDialogFragment.newInstance(list);
        dialogFragment.setListener(new CutEventDialogFragment.OnEventClickListener() {
            @Override
            public void itemClick(int position, String url) {
                Intent intent = new Intent();
                intent.setClass(mContext, WebViewActivity.class);
                intent.putExtra(IntentKeys.URL, url);
                startActivity(intent);
                dialogFragment.dismiss();
            }
        });
        dialogFragment.show(mFragTransaction, "dialogFragment");
//        dialog = new CutEventDialog(mContext, list, new CutEventDialog.OnEventClickListener() {
//            @Override
//            public void itemClick(int position, String url) {
//                Intent intent = new Intent();
//                intent.setClass(mContext, WebViewActivity.class);
//                intent.putExtra(IntentKeys.URL, url);
//                startActivity(intent);
//                dialog.dismiss();
//            }
//        });
//        dialog.show();
    }

    @OnClick(R.id.btn_share)
    public void onShareClick(View view) {
        Intent intent = new Intent();
        intent.putExtra("title", "标题标题");
        intent.putExtra("content", "我是分享内容我是内容我是内容我是内容我是内容我是内容我是内容我是");
        intent.putExtra("image_url", "http://www.66zhibo.net/uploadfile/2014/0124/20140124040447660.jpg");
        intent.putExtra("target_url", "http://www.ocj.com.cn/");
        intent.setClass(mContext, ShareActivity.class);
        startActivity(intent);
    }

    private VideoCheckPresenter mVideoPresenter;
    private String live_shopnum;

    @OnClick(R.id.btn_jzvideo)
    public void btnJzvideo(View view) {
        String url = "http://rm.ocj.com.cn/eventbarragevideo/10576";
        String urlLow = url.toLowerCase();
        if (urlLow.contains("eventbarragevideo")) {
            Intent intent = new Intent();
            intent.putExtra(VIDEO_URL, urlLow);
            intent.setClass(mContext, OcjLiveEmptyActivity.class);
            startActivity(intent);
        }
    }


}