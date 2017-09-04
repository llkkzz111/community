package com.ocj.oms.mobile.ui.rn;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.android.arouter.launcher.ARouter;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.ocj.oms.common.net.HeaderUtils;
import com.ocj.oms.mobile.ui.webview.WebViewActivity;
import com.ocj.oms.rn.NumUtils;
import com.ocj.oms.rn.SplashScreen;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.system.TelephoneUtil;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


/**
 * @author Xiang
 *         <p>
 *         安卓路由模块
 */

public class RouterModule extends ReactContextBaseJavaModule {
    private static ReactContext reactContext;
    public static ArrayList<String> dataCacheArray = new ArrayList<>();
    //限制RN只调用1次
    private static boolean isFirstCall = true;
    //回调函数
    public static Promise callback;
    //fromPage
    public static String fromPage;
    //页面传递对象
    public static JSONObject jsonObject;
    //登录
    public static final String AROUTER_PATH_LOGIN = "/ui/login/LoginActivity";
    public static final String AROUTER_PATH_RELOGIN = "/ui/login/media/MobileReloginActivity";
    //支付
    public static final String AROUTER_PATH_PAY = "/ui/personal/order/OrderPayActivity";
    //积分
    public static final String AROUTER_PATH_SCORE = "/ui/personal/wallet/integral/IntegralDetailsActivity";
    //抵用券
    public static final String AROUTER_PATH_COUPON = "/ui/personal/wallet/vouchers/VocherDetailActivity";
    //礼包
    public static final String AROUTER_PATH_REWARD = "/ui/personal/packs/GiftcardsDetailActivity";
    //预付款
    public static final String AROUTER_PATH_PRE_BARGAIN = "/ui/personal/wallet/imprest/ImprestDetailActivity";
    //鸥点
    public static final String AROUTER_PATH_EUROPE = "/ui/personal/wallet/opoint/OcouponsDetailActivity";
    //设置
    public static final String AROUTER_PATH_SETTING = "/ui/personal/setting/SettingActivity";
    //选择地址
    public static final String AROUTER_PATH_SELECT_ADDRESS = "/ui/personal/adress/ReceiverAddressManagerActivity";
    //选择地区
    public static final String AROUTER_PATH_SELECT_AREA = "/ui/personal/adress/ReceiverAddressSelectActivity";
    //分享
    public static final String AROUTER_PATH_SHARE = "/third/share/ShareActivity";
    //退换货
    public static final String AROUTER_PATH_RETEXGOODS = "/ui/personal/order/RetExGoodsActivity";
    //全球购
    public static final String AROUTER_PATH_ABROAD_BUY = "/ui/AbroadBuyActivity";
    //全球购商品列表
    public static final String AROUTER_PATH_GLOBAL_LIST = "/ui/global/GlobalListActivity";
    //Vip专区
    public static final String AROUTER_PATH_VIP = "/ui/VipInfoActivity";
    //抢红包
    public static final String AROUTER_PATH_LOTTERY = "/ui/redpacket/LotteryActivity";
    //二维码扫描
    public static final String AROUTER_PATH_SWEEP = "/ui/scan/ScannerActivity";
    //视频播放
    public static final String AROUTER_PATH_VIDEO = "/ui/video/VideoPlayActivity";
    //商品详情视频播放
    public static final String AROUTER_PATH_VIDEO_DETAIL = "/ui/video/VideoDetailActivity";
    //签到
    public static final String AROUTER_PATH_SIGN = "/ui/sign/SignActivity";
    //预约订单
    public static final String AROUTER_PATH_RESERVE = "/ui/ReserveOrderActivity";
    //评价
    public static final String AROUTER_PATH_COMMENT = "/ui/createcomment/CreateComentActivity";
    //礼券兑换
    public static final String AROUTER_PATH_CHANGEGIFT = "/ui/personal/wallet/integral/IntegralExchangeActivity";
    //礼包充值
    public static final String AROUTER_PATH_GIFTRECHARGE = "/ui/personal/wallet/packs/PacksRechargeActivity";
    //安卓webview
    public static final String AROUTER_PATH_WEBVIEW = "/ui/webview/WebViewActivity";
    //个人资料
    public static final String AROUTER_PATH_PERSONINFO = "/ui/personal/ProfileInfoActivity";

    public RouterModule(ReactApplicationContext reactContext) {
        super(reactContext);
        RouterModule.reactContext = reactContext;
        jsonObject = new JSONObject();
    }

    @Override
    public String getName() {
        return "AndroidRouterModule";
    }


    //视频详情回调购物车
    public static void videoToCart() {
        try {
            jsonObject.putOpt("beforepage", RouteConfigs.Video);
            jsonObject.putOpt("targetRNPage", RouteConfigs.CartPage);
            invokeCallback(jsonObject);

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //刷新购物车
    public static void orderToCart() {
        try {
            jsonObject.putOpt("beforepage", RouteConfigs.Video);
            jsonObject.putOpt("targetRNPage", RouteConfigs.CartPage);
            invokeCallback(jsonObject);

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //字母拼音排序回调
    @ReactMethod
    public static void getSortedList(ReadableArray readableArray, Callback getTokenCallback) {
        ArrayList<String> arrayList = new ArrayList<>();
        for (int i = 0; i < readableArray.size(); i++) {
            arrayList.add(readableArray.getString(i));
        }
        getTokenCallback.invoke(NumUtils.getSortedList(arrayList));
    }

    //支付回调
    public static void invokePayResult(String targetRNPage) {
        try {
            jsonObject.putOpt("beforepage", RouteConfigs.Pay);
            jsonObject.putOpt("targetRNPage", targetRNPage);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //支付成功去推荐商品
    public static void mainToDetail(String itemCode) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.putOpt("itemcode", itemCode);
            jsonObject.putOpt("beforepage", RouteConfigs.Pay);
            jsonObject.putOpt("targetRNPage", RouteConfigs.ResetToDetail);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //全球购回调详情
    public static void globalToDetail(String itemCode) {
        try {
            jsonObject.putOpt("itemcode", itemCode);
            jsonObject.putOpt("targetRNPage", RouteConfigs.GoodsDetailMain);
            jsonObject.putOpt("beforepage", RouteConfigs.Global);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //全球购商品列表到详情
    public static void globalListToDetail(String itemCode, String searchItem, String contentType, String lgroup) {
        try {
            jsonObject.putOpt("itemcode", itemCode);
            jsonObject.putOpt("beforepage", RouteConfigs.GlobalList);
            jsonObject.putOpt("targetNativePage", RouteConfigs.GlobalList);
            jsonObject.putOpt("targetRNPage", RouteConfigs.GoodsDetailMain);
            jsonObject.putOpt("search_item", searchItem);
            jsonObject.putOpt("global_content_type", contentType);
            jsonObject.putOpt("global_lg_roup", lgroup);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //h5页面回商品详情
    public static void h5ToDetail(String itemCode, String isBone, String url, boolean isScan) {
        try {
            if (!TextUtils.isEmpty(isBone))
                jsonObject.putOpt("isBone", isBone);
            if (!TextUtils.isEmpty(url))
                jsonObject.putOpt("url", url);
            if (!isScan) {
                jsonObject.putOpt("beforepage", RouteConfigs.Androidocj_WebView);
            }
            jsonObject.putOpt("itemcode", itemCode);
            jsonObject.putOpt("targetRNPage", RouteConfigs.GoodsDetailMain);
            if (RouterModule.jsonObject.optString("page").equals(RouteConfigs.Global)) {
                RouterModule.cacheRouteActivity(RouterModule.jsonObject.toString());
            }
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //全球购回调webview
    public static void globalToWebView(String url) {
        ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                .withString("url", url)
                .navigation();
    }

    //全球购回调消息列表
    public static void globalToMessageList() {
        try {
            jsonObject.putOpt("beforepage", RouteConfigs.Global);
            jsonObject.putOpt("targetRNPage", RouteConfigs.MessageListPage);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //视频详情回调商品详情
    public static void videoToDetail(String itemCode) {
        try {
            jsonObject.putOpt("beforepage", RouteConfigs.Video);
            if (itemCode != null) {
                jsonObject.putOpt("itemcode", itemCode);
            }
            if (!TextUtils.isEmpty(fromPage)) {
                jsonObject.putOpt("fromPage", fromPage);
                fromPage = null;
            }
            jsonObject.putOpt("targetRNPage", RouteConfigs.GoodsDetailMain);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //Vip回调
    public static void vipToDetail(String itemCode) {
        try {
            jsonObject.putOpt("itemcode", itemCode);
            jsonObject.putOpt("beforepage", RouteConfigs.VIP);
            jsonObject.putOpt("targetRNPage", RouteConfigs.GoodsDetailMain);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //分享结果回传，字符串1代表分享成功，0失败
    public static void invokeShareResult(String result) {
        try {
            jsonObject.putOpt("shareResult", result);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //地址回传
    //receiver_seq:      ///<收货编号
    //cust_no;           ///<顾客编号
    //receiverName;      ///<收货人
    //mobile1;           ///<手机号第一段
    //mobile2;           ///<手机号第二段
    //mobile3;           ///<手机号第三段
    //isDefault;         ///<是否是默认地址， 1是默认，0不是
    //addrProCity;       ///<收货地址省市信息
    //addrDetail;        ///<收货地址详细信息
    //addressID;         ///<地址id
    //provinceCode;      ///<省对应code
    //cityCode;          ///<市对应code
    //districtCode;      ///<区对应code
    public static void invokeAddressCallback(
            String receiver_seq,
            String cust_no,
            String receiverName,
            String mobile1,
            String mobile2,
            String mobile3,
            String isDefault,
            String addrProCity,
            String addrDetail,
            String addressID,
            String provinceCode,
            String cityCode,
            String districtCode
    ) {
        try {
            jsonObject.putOpt("receiver_seq", receiver_seq);
            jsonObject.putOpt("cust_no", cust_no);
            jsonObject.putOpt("receiverName", receiverName);
            jsonObject.putOpt("mobile1", mobile1);
            if (mobile2.length() >= 11) {
                mobile2 = mobile2.substring(0, 3) + "****" + mobile2.substring(mobile2.length() - 4, mobile2.length());
            }
            jsonObject.putOpt("mobile2", mobile2);
            jsonObject.putOpt("mobile3", mobile3);
            jsonObject.putOpt("isDefault", isDefault);
            jsonObject.putOpt("addrProCity", addrProCity);
            jsonObject.putOpt("addrDetail", addrDetail);
            jsonObject.putOpt("addressID", addressID);
            jsonObject.putOpt("provinceCode", provinceCode);
            jsonObject.putOpt("cityCode", cityCode);
            jsonObject.putOpt("districtCode", districtCode);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //token回传
    public static void invokeTokenCallback(Activity activity, String accessToken, String tokenType, boolean reload) {
        try {
            jsonObject.putOpt("token", accessToken);
            jsonObject.putOpt("tokenType", tokenType);
            invokeCallback(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    //回退到RN界面
    public static void returnRN() {
        ActivityStack.getInstance().finishToActivity(RNActivity.class);
    }


    /**
     * 获取初始token
     * X_msale_way: '',
     * X_version_info: '',
     * X_msale_code: '',
     * X_device_id: '',
     * X_jiguang_id: '',
     * X_net_type: '',
     * X_region_cd: '',
     * X_sel_region_cd: '',
     * X_substation_code: ''
     * token:''
     * tokenType:''
     */
    @ReactMethod
    public void getToken(Callback getTokenCallback) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.putOpt("X_msale_way", HeaderUtils.getMsaleWay());
            jsonObject.putOpt("X_version_info", HeaderUtils.getVersionInfo());
            jsonObject.putOpt("X_msale_code", HeaderUtils.getMsaleCode());
            jsonObject.putOpt("X_device_id", HeaderUtils.getDeviceId());
            jsonObject.putOpt("X_jiguang_id", HeaderUtils.getJpushCode());
            jsonObject.putOpt("X_net_type", HeaderUtils.getNetWorkTypeName());
            jsonObject.putOpt("X_region_cd", HeaderUtils.getRegionCd());
            jsonObject.putOpt("X_sel_region_cd", HeaderUtils.getSelReginCd());
            jsonObject.putOpt("X_substation_code", HeaderUtils.getSubstationCode());
            jsonObject.putOpt("token", OCJPreferencesUtils.getAccessToken());
            jsonObject.putOpt("UserName", OCJPreferencesUtils.getCustName());
            /**需要获取用户id*/
            jsonObject.putOpt("UserId", OCJPreferencesUtils.getCustNo());

            if (OCJPreferencesUtils.isVisitor()) {
                jsonObject.putOpt("tokenType", "guest");
            } else {
                jsonObject.putOpt("tokenType", "self");
            }
            getTokenCallback.invoke(jsonObject.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    @ReactMethod
    public void setBaseUrlToNative(boolean debugMode, String baseUrl, String h5BaseUrl) {
        Log.i("baseUrl", "debugMode------->" + debugMode + "\nbaseUrl------>" + baseUrl + "\nh5BaseUrl----->" + h5BaseUrl);

        OCJPreferencesUtils.setRNDebug(debugMode ? "1" : "0");
        OCJPreferencesUtils.setRNApiHost(baseUrl);
        OCJPreferencesUtils.setRNH5ApiHost(h5BaseUrl);
    }

    @ReactMethod
    public void startSystemBrowser(String targetUrl) {
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Uri content_url = Uri.parse(targetUrl);
        intent.setData(content_url);
        reactContext.startActivity(intent);
    }

    /**
     * 获取初始极光ID
     */
    @ReactMethod
    public void getJiguangId(Callback getJiguangId) {
        getJiguangId.invoke(OCJPreferencesUtils.getJpushCode());
    }

    @ReactMethod
    public void getDeviceId(Callback getDeviceIdCallback) {
        getDeviceIdCallback.invoke(TelephoneUtil.getIMEI(), "guest");
    }

    /**
     * 打开启动屏
     */
    @ReactMethod
    public void show() {
        SplashScreen.show(getCurrentActivity());
    }

    /**
     * 关闭启动屏
     */
    @ReactMethod
    public void hide() {
        SplashScreen.hide(getCurrentActivity());
    }

    /**
     * 原生向js发送事件
     */
    public static void sendEvent(String eventName, String tokenType, String token, String type) {
        WritableMap params = Arguments.createMap();
        params.putString("tokenType", tokenType);
        params.putString("token", token);
        params.putString("type", type);

        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
        ActivityStack.getInstance().finishToActivity(RNActivity.class);
    }


    /**
     * @param type
     */
    public static void sendAdviceEvent(String type, boolean form) {
        WritableMap params = Arguments.createMap();
        params.putString("type", type);

        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("refreshApp", params);
        if (!form) {
            ActivityStack.getInstance().finishToActivity(RNActivity.class);
        }
    }


    public static void sendRefreshCartEvent(String code, String msg) {
        WritableMap params = Arguments.createMap();
        params.putString("code", code);
        params.putString("message", msg);
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("refreshCartData", params);
        ActivityStack.getInstance().finishToActivity(RNActivity.class);
    }


    /**
     * 通知栏往RN发送消息
     *
     * @param params
     */
    public static void sendNotificationToRN(WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("goToNativeView", params);
    }

    /**
     * 原生悬浮按钮显示
     *
     * @param isHome 首页——true   非首页——false
     */
    @ReactMethod
    public void showSuspension(boolean isHome) {
        if (isHome) {
            EventBus.getDefault().post("home_true");
        } else {
            EventBus.getDefault().post("home_false");
        }
    }

    /**
     * 保存RN的apihost
     *
     * @param baseUrl
     */
    @ReactMethod
    public void setH5BaseUrlToNative(String baseUrl) {
        OCJPreferencesUtils.setRNH5ApiHost(baseUrl);
    }

    /**
     * 回退
     */
    public static void onRouteBack() {
        if (dataCacheArray.size() > 0) {
            routeActivity(dataCacheArray.get(dataCacheArray.size() - 1));
            dataCacheArray.remove(dataCacheArray.size() - 1);
        }
    }

    /**
     * 缓存路径上的页面
     */
    public static void cacheRouteActivity(String data) {
        dataCacheArray.add(data);
    }

    /**
     * 路由页面调用
     *
     * @param data
     * @param callback
     */
    @ReactMethod
    public void startAndroidActivity(String data, Promise callback) {
        isFirstCall = true;
        RouterModule.callback = callback;
        routeActivity(data);
    }

    /**
     * 回传回调方法
     */
    public static void invokeCallback(JSONObject params) {
        returnRN();
        if (isFirstCall) {
            try {
                callback.resolve(params.toString());
            } catch (Exception e) {
                callback.reject(e.getMessage(), e);
            }
            isFirstCall = false;
        }
    }

    /**
     * 路由跳转
     *
     * @param data
     */
    public static void routeActivity(String data) {
        try {
            jsonObject = new JSONObject(data);
        } catch (JSONException e) {
            callback.reject(e.getMessage(), e);
        }
        //起始页面
        if (data.contains("fromRNPage")) {
            fromPage = jsonObject.optString("fromRNPage");
        } else if (data.contains("fromPage")) {
            fromPage = jsonObject.optString("fromPage");
        }
        //目标页面
        String targetActivity = jsonObject.optString("page");
        //参数
        JSONObject param = jsonObject.optJSONObject("param");
        switch (targetActivity) {
            //个人中心 -> 登录
            case RouteConfigs.Login:
                String fromActivity = "";
                if (!TextUtils.isEmpty(OCJPreferencesUtils.getLoginId()) || !TextUtils.isEmpty(OCJPreferencesUtils.getInternetId())) {
                    fromActivity = AROUTER_PATH_RELOGIN;
                } else {
                    fromActivity = AROUTER_PATH_LOGIN;
                }

                ARouter.getInstance().build(fromActivity)
                        .withString("from", "RNActivity")
                        .withString("fromPage", jsonObject.optString("fromPage"))
                        .navigation();

                break;
            //个人中心 -> 付款
            case RouteConfigs.Pay:
                //{"orders":["20170606120342","20170606120344","20170606120346"]}
                ARouter.getInstance().build(AROUTER_PATH_PAY).withString("from", "RNActivity")
                        .withString("orders", param.optString("orders"))
                        .navigation();
                break;
            //个人中心 -> 积分
            case RouteConfigs.Score:
                ARouter.getInstance().build(AROUTER_PATH_SCORE).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 抵用券
            case RouteConfigs.Coupon:
                ARouter.getInstance().build(AROUTER_PATH_COUPON).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 礼包
            case RouteConfigs.Reward:
                ARouter.getInstance().build(AROUTER_PATH_REWARD).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 预付款
            case RouteConfigs.Prebargain:
                ARouter.getInstance().build(AROUTER_PATH_PRE_BARGAIN).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 鸥点
            case RouteConfigs.Europe:
                ARouter.getInstance().build(AROUTER_PATH_EUROPE).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 设置
            case RouteConfigs.Setting:
                ARouter.getInstance().build(AROUTER_PATH_SETTING).withString("from", "RNActivity").navigation();
                break;
            //个人中心 -> 收货地址管理
            case RouteConfigs.SelectAddress:
                ARouter.getInstance().build(AROUTER_PATH_SELECT_ADDRESS).withString("from", "RNActivity").navigation();
                break;

            //商品详细 -> 选择地区
            case RouteConfigs.SelectArea:
                ARouter.getInstance().build(AROUTER_PATH_SELECT_AREA).withString("from", "RNActivity").navigation();
                break;
            //商品详情 -> 分享
            case RouteConfigs.Share:
                ARouter.getInstance().build(AROUTER_PATH_SHARE).withString("from", "RNActivity")
                        .withString("title", param.optString("title"))
                        .withString("content", param.optString("content"))
                        .withString("image_url", param.optString("image_url"))
                        .withString("target_url", param.optString("target_url"))
                        .navigation();
                break;
            //退换货
            case RouteConfigs.Exchange:
            case RouteConfigs.Return:
                ARouter.getInstance().build(AROUTER_PATH_RETEXGOODS).withString("from", "RNActivity")
                        .withString("data", param.toString())
                        .navigation();
                break;
            //热销
            case RouteConfigs.HomeHotSale:
                break;
            //全球购
            case RouteConfigs.Global:
                ARouter.getInstance().build(AROUTER_PATH_ABROAD_BUY)
                        .withString("from", "RNActivity")
                        .navigation();
                break;
            //vip专区
            case RouteConfigs.VIP:
                ARouter.getInstance().build(AROUTER_PATH_VIP).withString("from", "RNActivity").navigation();
                break;
            //抢红包
            case RouteConfigs.Red:
                ARouter.getInstance().build(AROUTER_PATH_LOTTERY).withString("from", "RNActivity").navigation();
                break;
            //扫一扫
            case RouteConfigs.Sweep:
                ARouter.getInstance().build(AROUTER_PATH_SWEEP).withString("from", "RNActivity").navigation();
                break;
            //签到
            case RouteConfigs.Sign:
                ARouter.getInstance().build(AROUTER_PATH_SIGN).withString("from", "RNActivity").navigation();
                break;
            //商品详情视频播放
            case RouteConfigs.PlayVideo:
                ARouter.getInstance().build(AROUTER_PATH_VIDEO_DETAIL)
                        .withString("from", "RNActivity")
                        .withString("item_video_url", param.optString("item_video_url"))
                        .navigation();
                Log.i("item_video_url", param.optString("item_video_url"));
                break;
            //视频播放
            case RouteConfigs.Video:
                if (param != null) {
                    if (data.contains("fromPage")) {
                        fromPage = param.optString("fromPage");
                    }
                    ARouter.getInstance().build(AROUTER_PATH_VIDEO)
                            .withString("from", "RNActivity")
                            .withString("id", param.optString("id"))
                            .navigation();
                }
                break;
            //去评价
            case RouteConfigs.Valuate:
                ARouter.getInstance().build(AROUTER_PATH_COMMENT)
                        .withString("from", "RNActivity")
                        .withString("goodsinfo", param.toString())
                        .navigation();
                break;
            //预约订单
            case RouteConfigs.Reserve:
                ARouter.getInstance().build(AROUTER_PATH_RESERVE)
                        .withString("from", "RNActivity")
                        .withString("reserveData", param.toString())
                        .navigation();
                break;
            //礼券兑换
            case RouteConfigs.ChangeGift:
                ARouter.getInstance().build(AROUTER_PATH_CHANGEGIFT)
                        .withString("from", "RNActivity")
                        .navigation();
                break;
            //安卓webview
            case RouteConfigs.Androidocj_WebView:
                if (!(ActivityStack.getInstance().getLastActivity() instanceof WebViewActivity)) {
                    String url = "";
                    if (param != null && param.has("url")) {
                        url = param.optString("url");
                    } else if (data.contains("url")) {
                        url = jsonObject.optString("url");
                    }
                    ARouter.getInstance().build(AROUTER_PATH_WEBVIEW)
                            .withString("from", "RNActivity")
                            .withString("url", url)
                            .navigation();
                }
                break;
            //全球购商品列表
            case RouteConfigs.GlobalList:
                ARouter.getInstance().build(AROUTER_PATH_GLOBAL_LIST)
                        .withString("from", "RNActivity")
                        .withString("search_item", jsonObject.optString("search_item"))
                        .withString("global_content_type", jsonObject.optString("global_content_type"))
                        .withString("global_lg_roup", jsonObject.optString("global_lg_roup"))
                        .navigation();
                break;
            //礼包充值
            case RouteConfigs.GiftRecharge:
                ARouter.getInstance().build(AROUTER_PATH_GIFTRECHARGE)
                        .withString("from", "RNActivity")
                        .navigation();
                break;
            //个人资料
            case RouteConfigs.PersonalInformation:
                ARouter.getInstance().build(AROUTER_PATH_PERSONINFO)
                        .withString("from", "RNActivity")
                        .navigation();
                break;
        }
    }
}
