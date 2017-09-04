package com.ocj.oms.mobile.ui.video.player;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.blankj.utilcode.utils.ToastUtils;
import com.jz.jizhalivesdk.Bean.JZLiveRecord;
import com.jz.jizhalivesdk.Bean.JZLiveUser;
import com.jz.jizhalivesdk.GetJson.JZGeneralApi;
import com.jz.jizhalivesdk.GetJson.JsonCallback;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.video.player.bean.BarrageUseableBean;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.reactivex.annotations.NonNull;

import static android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP;

/**
 * Created by liu on 2017/7/12.
 */

public class VideoCheckPresenter {

    private Activity mContext;
    private String live_shopnum;
    private LiveBasicInfoBean liveBasicInfo;//当前直播的商品基本信息
    private JZLiveRecord liveRecord;//当前直播的商品
    private IRequestCallBack iRequestCallBack;

    public String getLive_shopnum() {
        return live_shopnum;
    }

    public void setLive_shopnum(String live_shopnum) {
        this.live_shopnum = live_shopnum;
    }

    public VideoCheckPresenter(Activity mContext, IRequestCallBack iRequestCallBack) {
        this.mContext = mContext;
        this.iRequestCallBack = iRequestCallBack;
    }

    //检查是否可以参加红包雨活动
    public void checkBarrageUseable() {
        Map<String, Object> params = new HashMap<>();
        new VideoMode(mContext).checkBarrageUseable(params, new ApiObserver<BarrageUseableBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                iRequestCallBack.complete();
            }

            @Override
            public void onNext(@NonNull BarrageUseableBean barrageUseableBean) {
                if (barrageUseableBean == null) {
                    iRequestCallBack.complete();
                    return;
                }
                String msg_code = barrageUseableBean.msg_code;
                String msg = barrageUseableBean.msg;
                if ("10000".equals(msg_code)) {
                    loginLiveApp(barrageUseableBean.cust_no, barrageUseableBean.cust_name);
                    return;
                } else if ("10001".equals(msg_code)) {
                    // todo 手机未验证
//                    onPageIemClicked(OcjUrls.CHANGEUSERINFOURL,false);
                    Toast.makeText(mContext, TextUtils.isEmpty(msg) ? "请先验证手机号码" : msg, Toast.LENGTH_SHORT).show();
                    iRequestCallBack.complete();
                    return;
                } else if ("10009".equals(msg_code)) {
                    //网络繁忙，请稍后重试
                    Toast.makeText(mContext, TextUtils.isEmpty(msg) ? "网络繁忙，请稍后重试" : msg, Toast.LENGTH_SHORT).show();
                    iRequestCallBack.complete();
                    return;
                } else if ("20001".equals(msg_code)) {
//                    toLogin("");
                    Intent intent = new Intent(mContext, LoginActivity.class);
                    mContext.startActivity(intent);
                    Toast.makeText(mContext, TextUtils.isEmpty(msg) ? "请先登录账号" : msg, Toast.LENGTH_SHORT).show();
                    iRequestCallBack.complete();
                    return;
                } else {
                    iRequestCallBack.complete();
                }
            }
        });
    }

    private String createName(String s) {
        if (s.length() < 2 || TextUtils.equals(s, "OCJ会员")) {
            return s;
        }
        StringBuilder builder = new StringBuilder();
        String firstName = s.substring(0, 1);
        builder.append(firstName);
        for (int i = 0; i < s.length() - 1; i++) {
            builder.append("*");
        }
        return builder.toString();
    }

    /**
     * 登录到第三方视频直播app
     *
     * @param custNo
     * @param custName
     */
    public void loginLiveApp(String custNo, String custName) {
        JZGeneralApi.thirdPrtyLoginWithBlock(custNo, "dongfanggouwu", createName(custName), "上海", "", "", "000000", new JsonCallback() {
            @Override
            public void getJsonData(JSONObject jsonObject) {
                try {
                    if (jsonObject.getBoolean("result")) {
                        Log.v("LoginApp", "登录成功");
                        if (jsonObject.has("user")) {
                            JSONObject obj = jsonObject.getJSONObject("user");
                            LiveUtil.setLiveUser(obj);
                        }
                        getLiveBasicInfo(live_shopnum);
                        return;
                        /*APP.setLoginState(true);*/
                    } else {
                        Log.v("LoginApp", "登录失败");
                    }
                    Log.v("LoginAppMsg", jsonObject.getString("msg"));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                iRequestCallBack.complete();
            }
        });
    }

    /**
     * 获取直播在线列表
     *
     * @param shop_no
     */
    public void getLiveBasicInfo(String shop_no) {
        liveBasicInfo = null;
        Map<String, Object> params = new HashMap<>();
        params.put("shop_no", shop_no);
        new VideoMode(mContext).getLiveBasicInfo(params, new ApiObserver<LiveBasicInfoBean>(mContext) {
            @Override
            public void onError(ApiException e) {
                iRequestCallBack.complete();
            }

            @Override
            public void onNext(@NonNull LiveBasicInfoBean liveBasicInfoBean) {
                if (liveBasicInfoBean != null) {
                    liveBasicInfo = liveBasicInfoBean;
                    getUserLiveRecord();
                    return;
                }
                iRequestCallBack.complete();
            }
        });
    }

    //获取直播播放列表
    public void getUserLiveRecord() {
        liveRecord = null;
        JZGeneralApi.getKindsRecordsWithBlock(JZLiveUser.getUser().getIsTester(), 15, "user", 0, 50, new JsonCallback() {
            @Override
            public void getJsonData(JSONObject jsonObject) {
                try {
                    if (jsonObject != null) {
                        if (jsonObject.getBoolean("result")) {
                            Log.v("KindsRecordsWithBlock", "获取用户视频列表成功");
                            JSONArray array = jsonObject.getJSONArray("records");
                            if (array != null && array.length() > 0) {
                                JSONObject obj = array.getJSONObject(0);
                                liveRecord = LiveUtil.getJzLiveUser(obj);
                            }
                            startLive(live_shopnum, liveBasicInfo, liveRecord);
                            return;
                        } else {
                            Log.v("KindsRecordsWithBlock", "获取用户视频列表失败");
                        }
                        Log.v("KindsRecordsWithBlock", jsonObject.getString("msg"));
                    } else {
                        Log.v("KindsRecordsWithBlock", "获取用户视频列表失败");
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                iRequestCallBack.complete();
            }
        });
    }

    public void startLive(String live_shopnum, LiveBasicInfoBean liveBasicInfo, JZLiveRecord liveRecord) {
        if (liveBasicInfo != null && mContext != null) {
            liveBasicInfo.setShop_no(live_shopnum);
            Intent intent = new Intent(mContext, OcjLiveActivity.class);
            intent.putExtra(OcjLiveActivity.LIVE_RECORD_INFO, liveRecord);
            intent.putExtra(OcjLiveActivity.LIVE_BASIC_INFO, liveBasicInfo);
            intent.setFlags(FLAG_ACTIVITY_SINGLE_TOP);
            mContext.startActivity(intent);
        }
        iRequestCallBack.complete();
    }

    public interface IRequestCallBack {
        void complete();
    }
}
