package com.ocj.oms.mobile.ui.redpacket;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.SMGBean;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.login.LoginActivity;
import com.ocj.oms.mobile.ui.login.media.MobileReloginActivity;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.utils.RegExpValidatorUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

import static com.tendcloud.tenddata.ab.mContext;

/**
 * Created by liutao on 2017/6/11.
 */

public class LotteryFragment extends BaseFragment {

    @BindView(R.id.iv_top_image) ImageView ivTopImage;
    @BindView(R.id.et_number) EditText etNumber;
    @BindView(R.id.btn_lottery) Button btnLottery;

    private boolean isStart = false;
    private PackageListBean packageListBean;
    private CmsItemsBean cmsItemsBean;

    public static LotteryFragment newInstance(PackageListBean packageListBean) {
        LotteryFragment fragment = new LotteryFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable("bean", packageListBean);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_lottery_layout;
    }

    @Override
    protected void initEventAndData() {

        packageListBean = (PackageListBean) getArguments().getSerializable("bean");
        cmsItemsBean = packageListBean.getComponentList().get(0);
        if (!TextUtils.isEmpty(cmsItemsBean.getFirstImgUrl())) {
            Glide.with(mActivity).load(cmsItemsBean.getFirstImgUrl()).asBitmap().diskCacheStrategy(DiskCacheStrategy.ALL).listener(new RequestListener<String, Bitmap>() {
                @Override
                public boolean onException(Exception e, String model, Target<Bitmap> target, boolean isFirstResource) {
                    return false;
                }

                @Override
                public boolean onResourceReady(Bitmap resource, String model, Target<Bitmap> target, boolean isFromMemoryCache, boolean isFirstResource) {
                    if (resource != null && ivTopImage != null && ivTopImage.getLayoutParams() != null) {
                        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) ivTopImage.getLayoutParams();
                        layoutParams.width = DensityUtil.dip2px(mActivity, 245);
                        layoutParams.height = DensityUtil.dip2px(mActivity, 245 * resource.getHeight() / resource.getWidth());
                        ivTopImage.setLayoutParams(layoutParams);
                        ivTopImage.setImageBitmap(resource);
                        return true;
                    }
                    return false;
                }
            }).into(ivTopImage);
        }

        Calendar c = Calendar.getInstance();
        if (!TextUtils.isEmpty(cmsItemsBean.getCurruntDateLong())) {
            Date date = new Date(Long.parseLong(cmsItemsBean.getCurruntDateLong()));
            c.setTime(date);
            int hour = c.get(Calendar.HOUR_OF_DAY);
            int minutes = c.get(Calendar.MINUTE);
            boolean isFirstSunday = (c.getFirstDayOfWeek() == Calendar.SUNDAY);
            int weekDay = c.get(Calendar.DAY_OF_WEEK);
            if (isFirstSunday) {
                weekDay = weekDay - 1;
                if (weekDay == 0) {
                    weekDay = 7;
                }
            }
            if (!TextUtils.isEmpty(cmsItemsBean.getTitle()) && !TextUtils.isEmpty(cmsItemsBean.getSubtitle())) {
                int dayIndex = 0;
                for (String str : cmsItemsBean.getTitle().split(",")) {
                    if (TextUtils.equals(weekDay + "", str)) {
                        if (cmsItemsBean.getSubtitle().split(",").length == 1) {
                            for (String time : cmsItemsBean.getSubtitle().split(",")) {
                                try {
                                    if (cmsItemsBean.getSubtitle() != null && Integer.valueOf(time.split("-")[0].split(":")[0]) * 60 + Integer.valueOf(time.split("-")[0].split(":")[1]) <= hour * 60 + minutes &&
                                            hour * 60 + minutes <= Integer.valueOf(time.split("-")[1].split(":")[0]) * 60 + Integer.valueOf(time.split("-")[1].split(":")[1])) {
                                        isStart = true;
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        } else if (cmsItemsBean.getSubtitle().split(",").length > 1) {
                            int timeIndex = 0;
                            for (String time : cmsItemsBean.getSubtitle().split(",")) {
                                try {
                                    if (dayIndex == timeIndex && cmsItemsBean.getSubtitle() != null && Integer.valueOf(time.split("-")[0].split(":")[0]) * 60 + Integer.valueOf(time.split("-")[0].split(":")[1]) <= hour * 60 + minutes &&
                                            hour * 60 + minutes <= Integer.valueOf(time.split("-")[1].split(":")[0]) * 60 + Integer.valueOf(time.split("-")[1].split(":")[1])) {
                                        isStart = true;
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                timeIndex++;
                            }
                        }
                    }
                    dayIndex++;
                }
            }
        }

        if (!TextUtils.isEmpty(cmsItemsBean.getDestinationUrl()) && RegExpValidatorUtils.isNumber(cmsItemsBean.getDestinationUrl())) {
            etNumber.setVisibility(View.VISIBLE);
        } else {
            etNumber.setVisibility(View.GONE);
        }

        if (isStart) {
            etNumber.setBackgroundResource(R.drawable.bg_edit_lottery_normal);
            btnLottery.setBackgroundResource(R.drawable.ic_btn_red_);
            btnLottery.setText("立即抽奖");
        } else {
            etNumber.setFocusable(false);
            etNumber.setBackgroundResource(R.drawable.bg_edit_lottery_grey);
            btnLottery.setBackgroundResource(R.drawable.bg_btn_lottery_grey);
        }
    }

    @Override
    protected void lazyLoadData() {

    }


    @OnClick(R.id.btn_lottery)
    public void onClick() {
        if (isStart) {
            if (TextUtils.isEmpty(etNumber.getText().toString().trim())) {
                ToastUtils.showShortToast("请填写幸运码");
                return;
            }
            getSMGData();
        } else {

        }

    }

    private void getSMGData() {
        Map<String, String> params = new HashMap<>();
        if (!TextUtils.isEmpty(etNumber.getText().toString().trim())) {
            params.put("pwd", etNumber.getText().toString().trim());
        }
        params.put("event_no", cmsItemsBean.getDestinationUrl());
//        params.put("rd", new Random().nextDouble() + "");
        ((BaseActivity) getActivity()).showLoading();
        new ItemsMode(getActivity()).getSmgData(params, new ApiResultObserver<SMGBean>(getActivity()) {

            @Override
            public void onError(ApiException e) {
                ((BaseActivity) getActivity()).hideLoading();
                if (TextUtils.equals(e.getCode() + "", "1081701506")) {
                    RedPacketTipDialog dialog = new RedPacketTipDialog(mActivity);
                    dialog.setCanceledOnTouchOutside(true);
                    dialog.show();
                } else {
                    if (e.getCode() == 4010) {
                        Intent intent = new Intent();
                        if (TextUtils.isEmpty(OCJPreferencesUtils.getLoginId())) {
                            intent.setClass(mContext, LoginActivity.class);
                        } else {
                            intent.setClass(mContext, MobileReloginActivity.class);
                        }
                        startActivity(intent);
                    } else
                        ToastUtils.showLongToast(e.getMessage());
                }
            }

            @Override
            public void onSuccess(SMGBean apiResult) {
                ((BaseActivity) getActivity()).hideLoading();
                String prize = "";
                if (!TextUtils.isEmpty(apiResult.getPrizeName())) {
                    prize = apiResult.getPrizeName();
                } else if (apiResult.getPrizeinfos() != null && apiResult.getPrizeinfos().size() > 0) {
                    prize = apiResult.getPrizeinfos().get(0).getPrize_name();
                }
                //smg埋点
                Map<String, Object> params1 = ((LotteryActivity)(mActivity)).getParams();
                OcjStoreDataAnalytics.trackEvent(mActivity, cmsItemsBean.getCodeValue(), cmsItemsBean.getTitle(), params1);

                Intent intent = new Intent(mActivity, RedPacketActivity.class);
                intent.putExtra(IntentKeys.PRIZE_NAME, prize);
                intent.putExtra(IntentKeys.START_DATE,apiResult.getStart_date());
                intent.putExtra(IntentKeys.END_DATE,apiResult.getEnd_date());
                mActivity.startActivity(intent);
                getActivity().finish();

            }
        });
    }
}
