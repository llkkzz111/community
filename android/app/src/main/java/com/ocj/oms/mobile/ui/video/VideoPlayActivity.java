package com.ocj.oms.mobile.ui.video;

import android.content.res.Configuration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.bilibili.socialize.share.core.SocializeMedia;
import com.bilibili.socialize.share.core.shareparam.BaseShareParam;
import com.bilibili.socialize.share.core.shareparam.ShareImage;
import com.bilibili.socialize.share.core.shareparam.ShareParamText;
import com.bilibili.socialize.share.core.shareparam.ShareParamWebPage;
import com.blankj.utilcode.utils.ToastUtils;
import com.bumptech.glide.Glide;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.AddCartSuccessBean;
import com.ocj.oms.mobile.bean.ItemEventBean;
import com.ocj.oms.mobile.bean.RelationBean;
import com.ocj.oms.mobile.bean.ShareBean;
import com.ocj.oms.mobile.bean.items.CartNumBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.ItemSpec;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.third.share.base.BaseShareableActivity;
import com.ocj.oms.mobile.third.share.helper.ShareHelper;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.video.adapter.VideoDetailAdapter;
import com.ocj.oms.mobile.ui.video.listener.ItemClickListener;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import io.reactivex.annotations.NonNull;

/**
 * Created by yy on 2017/5/22.
 * <p>
 * 视频播放
 * <p>
 * 正在播放| 即将播放 |精彩回放
 */
@Route(path = RouterModule.AROUTER_PATH_VIDEO)
public class VideoPlayActivity extends BaseShareableActivity {

    @BindView(R.id.frv_content) RecyclerView frvContent;
    @BindView(R.id.tv_title) TextView title;
    @BindView(R.id.tv_cart_num) TextView cartNum;
    @BindView(R.id.rl_video_content) RelativeLayout rlVideoContent;
    @BindView(R.id.ptr_view) PtrClassicFrameLayout mPtrFrame;
    @BindView(R.id.rl_title) ViewGroup rlTitle;
    @BindView(R.id.iv_share) ImageView ivShare;

    VideoDetailAdapter adapter;

    private int tag = 1;//2：即将播出 1：正在播放 3：精彩回放
    private String videoId = "";
    private VideoDetailSelectSpecDialog mSepcSelectDialog;
    private GiftSelectSpecDialog mGiftSelectDialog;
    private int page = 2;

    private List<PackageListBean> datas;
    private String componentListId = "";
    private VideoPlayFragment videoFragment;

    private CmsContentBean mApiResult;
    private ShareBean mShareBean;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_video_layout;
    }

    @Override
    protected void initEventAndData() {
        initPtr();
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A047);
        videoId = getIntent().getStringExtra(IntentKeys.VIDEO_ID);//videoId,现在写死121
        if (TextUtils.isEmpty(videoId)) {
            videoId = OCJPreferencesUtils.getVideoId();
        } else {
            OCJPreferencesUtils.setVideoId(videoId);
        }
        frvContent.setLayoutManager(new LinearLayoutManager(mContext));
        frvContent.addItemDecoration(new SpacesItemDecoration(mContext, LinearLayoutManager.HORIZONTAL, DensityUtil.dip2px(mContext, 10)));
        showLoading();
        getVideoDetail();
        getCartNum();
    }

    private void initPtr() {
        mPtrFrame.setMode(PtrFrameLayout.Mode.LOAD_MORE);//只支持加载更多
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                loadMoreVideo();
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, frvContent, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, frvContent, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                page = 2;
            }

        });
    }

    public void setTitleVisible(boolean flag) {
        if (flag) {
            rlTitle.setVisibility(View.VISIBLE);
        } else {
            rlTitle.setVisibility(View.GONE);
        }
    }

    public Map<String, Object> getParams() {
        Map<String, Object> params = new HashMap<>();
        params.put("pID", mApiResult.getCodeValue());
        params.put("vID", mApiResult.getPageVersionName());
        return params;
    }

    private void getVideoDetail() {
        new ItemsMode(mContext).getVideoDetail(videoId, new ApiResultObserver<CmsContentBean>(mContext) {
            @Override
            public void onSuccess(CmsContentBean apiResult) {
                //刷新视频界面
                if (apiResult != null && apiResult.getPackageList() != null && apiResult.getPackageList().size() > 0) {
                    showData(apiResult);
                    mApiResult = apiResult;
                }
                hideLoading();
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showLongToast(e.getMessage());
            }
        });
    }

    private void showData(CmsContentBean apiResult) {
        showVideoView(apiResult);
        datas = new ArrayList<>();
        for (int i = 0; i < apiResult.getPackageList().size(); i++) {
            PackageListBean bean = apiResult.getPackageList().get(i);
            if (bean.getPackageId().equals("13") ||
                    bean.getPackageId().equals("36") ||
                    bean.getPackageId().equals("41")) {
                if (bean.getPackageId().equals("41")) {
                    componentListId = bean.getComponentList().get(0).getId();
                }
                datas.add(bean);
            }
        }
        adapter = new VideoDetailAdapter(mContext, datas);
        adapter.setTab(tag);
        adapter.setItemClickListener(new ItemClickListener() {
            @Override
            public void itemClick(CmsItemsBean bean) {
                getItemSpec(bean);
            }
        });
        frvContent.setAdapter(adapter);
        frvContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                frvContent.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                frvContent.scrollToPosition(0);
            }
        });
    }

    private void showVideoView(CmsContentBean apiResult) {
        for (PackageListBean bean : apiResult.getPackageList()) {
            if (bean.getPackageId().equals("36")) {
                if (bean.getComponentList() != null && bean.getComponentList().size() > 0) {
                    CmsItemsBean item = bean.getComponentList().get(0);
                    if (item != null) {
                        title.setText(item.getTitle());
                        tag = Integer.parseInt(item.getVideoStatus());
                        videoFragment = VideoPlayFragment.newInstance(item.getVideoPlayBackUrl(), false, item.getFirstImgUrl(), item);
                        getSupportFragmentManager().beginTransaction().add(R.id.fl_content, videoFragment, "video").commit();
                    }
                }
            }
        }
    }


    /**
     * 请求加载更多数据
     */
    private void loadMoreVideo() {
        Map<String, Object> params = new HashMap<>();
        params.put("id", componentListId);
        params.put("pageNum", page);//查询的页数
        params.put("pageSize", 10);//分页显示数量
        new ItemsMode(mContext).getRelationList(params, new ApiResultObserver<RelationBean>(mContext) {

            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
                mPtrFrame.refreshComplete();
            }

            @Override
            public void onSuccess(RelationBean apiResult) {
                List<CmsItemsBean> list = apiResult.getList();
                CmsItemsBean data = datas.get(datas.size() - 1).getComponentList().get(0);
                if (datas != null && datas.size() > 2) {
                    if (data != null && data.getComponentList() != null) {
                        datas.get(datas.size() - 1).getComponentList().get(0).getComponentList().addAll(list);
                        adapter.notifyDataSetChanged();
                    }
                }
                mPtrFrame.refreshComplete();
                page++;
            }
        });
    }


    private void getItemSpec(final CmsItemsBean bean) {
        showLoading();
        Map<String, Object> params = new HashMap<>();
        params.put("source_obj", "http://localhost:9091");

        Map<String, Object> params1 = new HashMap<>();
        new ItemsMode(mContext).getItemSpecAndGift(bean.getContentCode(), params, params1, new ApiObserver<ItemSpec>(mContext) {
            @Override
            public void onError(ApiException e) {
                hideLoading();
            }

            @Override
            public void onNext(@NonNull ItemSpec itemSpec) {
                hideLoading();
                showSpecSelectDialog(bean, itemSpec);
            }
        });
    }

    /**
     * 弹出选择规格框
     *
     * @param bean
     * @param itemSpec
     */
    private void showSpecSelectDialog(final CmsItemsBean bean, final ItemSpec itemSpec) {
        mSepcSelectDialog = new VideoDetailSelectSpecDialog(mContext);
        mSepcSelectDialog.setVideoType(tag);
        mSepcSelectDialog.setCmsItemsBean(bean);
        mSepcSelectDialog.setColorsSizeBean(itemSpec.detailBean.getColorsize());
        mSepcSelectDialog.setItemEventBean(itemSpec.eventBean);
        if (itemSpec.eventBean != null && itemSpec.eventBean.zpMap != null && itemSpec.eventBean.zpMap.size() > 0) {
            mSepcSelectDialog.setmGifts(itemSpec.eventBean.zpMap);
        }
        mSepcSelectDialog.setMax_num_limit(itemSpec.detailBean.getMax_num_controll());

        mSepcSelectDialog.setItemSelectListener(new VideoDetailSelectSpecDialog.ItemSelectListener() {

            @Override
            public void selectItem(int num, String item_unit_Code, ItemEventBean.EventMapItem select) {
                addItemToShopCart(bean.getContentCode(), num, item_unit_Code, select);
            }

            @Override
            public void showGiftDialog(ArrayList<ItemEventBean.EventMapItem> mLists, ItemEventBean.EventMapItem select) {
                showGiftSelectDialog(mLists, select);
            }
        });
        mSepcSelectDialog.show();
    }

    /**
     * 显示赠品选择弹框
     *
     * @param mLists
     * @param select
     */
    private void showGiftSelectDialog(ArrayList<ItemEventBean.EventMapItem> mLists, ItemEventBean.EventMapItem select) {
        mGiftSelectDialog = new GiftSelectSpecDialog(this, mLists, select);
        mGiftSelectDialog.setOnEnterClickListener(new GiftSelectSpecDialog.OnEnterClickListener() {
            @Override
            public void onEnterClick(ArrayList<ItemEventBean.EventMapItem> list, ItemEventBean.EventMapItem select) {
                mGiftSelectDialog.dismiss();
                mSepcSelectDialog.setGiftText(select.gift_item_name);
                mSepcSelectDialog.setGiftSelect(select);
            }
        });
        mGiftSelectDialog.show();
    }

    private void getCartNum() {

        Map<String, String> map = new HashMap<String, String>();
        // vistorToken 跟ACCESS_TOKEN 二选一
        map.put(ParamKeys.ACCESS_TOKEN, OCJPreferencesUtils.getAccessToken());
        //获取购物车数量
        new ItemsMode(mContext).getCartsCount(map, new ApiResultObserver<CartNumBean>(mContext) {
            @Override
            public void onSuccess(CartNumBean apiResult) {
                if (apiResult.getCarts_num() != 0) {
                    cartNum.setVisibility(View.VISIBLE);
                    cartNum.setText(apiResult.getCarts_num() + "");
                } else {
                    cartNum.setVisibility(View.GONE);
                }
            }

            @Override
            public void onError(ApiException e) {
//                ToastUtils.showLongToast(e.getMessage());

            }
        });

    }

    /**
     * 加入购物车接口
     */
    private void addItemToShopCart(String item_code, int num, String unit_code, ItemEventBean.EventMapItem select) {
        showLoading();
        Map<String, Object> params = new HashMap<>();
        params.put("item_code", item_code);
        params.put("qty", num + "");
        params.put("unit_code", unit_code);
        if (select != null) {
            params.put("gift_item_code", select.gift_item_code);
            params.put("gift_unit_code", select.unit_code);
        } else {
            params.put("gift_item_code", "");
            params.put("gift_unit_code", "");
        }
        params.put("giftPromo_no", "");
        params.put("giftPromo_seq", "");
        params.put("media_channel", "");
        params.put("msale_source", "");
        params.put("msale_cps", "");
        params.put("source_url", "");
        params.put("source_obj", "");
        params.put("timeStamp", "");
        params.put("ml_msale_gb", "");

        new ItemsMode(mContext).addItemToShopCart(params, new ApiResultObserver<AddCartSuccessBean>(mContext) {
            @Override
            public void onSuccess(AddCartSuccessBean apiResult) {
                hideLoading();
                ToastUtils.showShortToast("加入购物车成功");
                getCartNum();
            }

            @Override
            public void onError(ApiException e) {
                hideLoading();
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }


    @OnClick({R.id.btn_back, R.id.rl_cart, R.id.iv_share})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_back:
                if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                    if (videoFragment != null) {
                        videoFragment.zoomVideo();
                    }
                    return;
                } else {
                    finish();
                }
                break;
            case R.id.rl_cart:
                RouterModule.videoToCart();
                break;
            case R.id.iv_share:
                if (mShareBean != null) {
                    startShare(ivShare, true);
                }else{
                    initShareBean();
                    if(mShareBean!=null){
                        startShare(ivShare, true);
                    }
                }
                break;

        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
        }
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
        }
    }

    @Override
    public void onBackPressed() {
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            if (videoFragment != null) {
                videoFragment.zoomVideo();
            }
            return;
        }
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706A047);
        Glide.get(mContext).clearMemory();
    }

    @Override
    public BaseShareParam createParams(ShareHelper helper, SocializeMedia target) {
        BaseShareParam param;
        if (TextUtils.isEmpty(mShareBean.target_url)) {
            param = new ShareParamText(mShareBean.title, mShareBean.content, mShareBean.target_url);
        } else {
            param = new ShareParamWebPage(mShareBean.title, mShareBean.content, mShareBean.target_url);
            if (!TextUtils.isEmpty(mShareBean.image_url)) {
                ShareParamWebPage paramWebPage = (ShareParamWebPage) param;
                paramWebPage.setThumb(new ShareImage(mShareBean.image_url));
            }
        }
        if (target == SocializeMedia.SINA) {
            param.setContent(String.format(Locale.CHINA, "%s #东方购物# ", mShareBean.content));
        } else if (target == SocializeMedia.GENERIC || target == SocializeMedia.COPY) {
            param.setContent(mShareBean.content + " " + mShareBean.target_url);
        }
        return param;
    }

    private ShareBean initShareBean(){

        mShareBean=null;
        if(mApiResult==null){
            return mShareBean;
        }

        for (PackageListBean bean : mApiResult.getPackageList()) {
            if (bean.getPackageId().equals("36")) {
                if (bean.getComponentList() != null && bean.getComponentList().size() > 0) {
                    CmsItemsBean item = bean.getComponentList().get(0);
                    if (item != null) {
                        mShareBean=new ShareBean();
                        mShareBean.title=item.getTitle();
                        mShareBean.content=item.getSubTitle();
                        mShareBean.image_url=item.getFirstImgUrl();
                        mShareBean.target_url=item.getDestinationUrl();
                    }
                }
            }
        }
        return mShareBean;
    }
}
