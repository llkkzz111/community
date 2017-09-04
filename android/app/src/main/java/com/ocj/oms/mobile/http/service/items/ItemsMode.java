package com.ocj.oms.mobile.http.service.items;

import android.content.Context;

import com.ocj.oms.basekit.model.BaseModel;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.bean.AbroadRecomendBean;
import com.ocj.oms.mobile.bean.AddCartSuccessBean;
import com.ocj.oms.mobile.bean.DataBean;
import com.ocj.oms.mobile.bean.DistrictBrandBean;
import com.ocj.oms.mobile.bean.EventResultsItem;
import com.ocj.oms.mobile.bean.HotCityBean;
import com.ocj.oms.mobile.bean.ItemEventBean;
import com.ocj.oms.mobile.bean.OrderDetailBean;
import com.ocj.oms.mobile.bean.REPictureBeanNew;
import com.ocj.oms.mobile.bean.ReasonListBean;
import com.ocj.oms.mobile.bean.RelationBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.RetExPictureBean;
import com.ocj.oms.mobile.bean.SMGBean;
import com.ocj.oms.mobile.bean.SearchBean;
import com.ocj.oms.mobile.bean.ShareBean;
import com.ocj.oms.mobile.bean.VipNewBean;
import com.ocj.oms.mobile.bean.items.CartNumBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.bean.items.ColorsSizeBean;
import com.ocj.oms.mobile.bean.items.CommodityDetailBean;
import com.ocj.oms.mobile.bean.items.ItemSpec;
import com.ocj.oms.mobile.bean.items.SameRecommendBean;

import java.util.List;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.BiFunction;
import okhttp3.RequestBody;

import static com.ocj.oms.common.net.ServiceGenerator.createService;

/**
 * Created by liuzhao on 2017/6/9.
 */

public class ItemsMode extends BaseModel {
    public ItemsMode(Context context) {
        super(context);
    }

    /**
     * 全球购首页商品列表
     *
     * @param mObservable
     */
    public void getAbroadItems(ApiObserver<ApiResult<CmsContentBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<CmsContentBean>> observable = apiService.getAbroadItems();
        subscribe(observable, mObservable);
    }

    /**
     * 获取全球购底部更多推荐
     *
     * @param mObservable
     */
    public void getMoreAbroadItem(String id, int pageNo, int pageSize, ApiObserver<ApiResult<AbroadRecomendBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<AbroadRecomendBean>> observable = apiService.getMoreAbroadItem(id, pageNo, pageSize);
        subscribe(observable, mObservable);
    }

    /**
     * 视频详情页
     *
     * @param mObservable
     */
    public void getVideoDetail(String contentCode, ApiObserver<ApiResult<CmsContentBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<CmsContentBean>> observable = apiService.getVideoDetail(contentCode);
        subscribe(observable, mObservable);
    }

    /**
     * 创建评价列表
     *
     * @param mObservable
     */
    public void getCommentItems(Map<String, String> params, ApiObserver<ApiResult<DataBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<DataBean>> observable = apiService.getCommentItems(params);
        subscribe(observable, mObservable);
    }


    /**
     * 获取退换货的原因列表
     *
     * @param observer
     */
    public void getItemReturnReasons(ApiResultObserver<ReasonListBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<ReasonListBean>> observable = service.getItemReturnReasons();
        subscribe(observable, observer);
    }

    /**
     * 退换货上传图片
     *
     * @param observer
     */
    public void uploadREPicture(Map<String, RequestBody> params, ApiResultObserver<RetExPictureBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<RetExPictureBean>> observable = service.uploadREPicture(params);
        subscribe(observable, observer);
    }

    /**
     * 提交退换货表单
     *
     * @param observer
     */
    public void submitItemReturn(RequestBody body, ApiResultObserver<Result<String>> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<Result<String>>> observable = service.submitItemReturn(body);
        subscribe(observable, observer);
    }

    /**
     * 退换货界面，获取订单详情
     *
     * @param params
     * @param observer
     */
    public void getOrderDetail(Map<String, String> params, ApiResultObserver<OrderDetailBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<OrderDetailBean>> observable = service.getOrderDetail(params);
        subscribe(observable, observer);
    }

    /**
     * 写入商品评论
     *
     * @param params
     * @param observer
     */
    public void uploadComment(RequestBody params, ApiResultObserver<Result<String>> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<Result<String>>> observable = service.uploadComment(params);
        subscribe(observable, observer);
    }

    /**
     * 获取VIP专区页面内容
     *
     * @param mObservable
     */
    public void getVipItems(ApiObserver<ApiResult<VipNewBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<VipNewBean>> observable = apiService.getVipItems();
        subscribe(observable, mObservable);
    }

    /**
     * 获取VIP专区页面内容
     *
     * @param mObservable
     */
    public void getVipItems1(Map<String, String> map, ApiObserver<String> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<String> observable = apiService.getVipItems1(map);
        subscribe(observable, mObservable);
    }

    /**
     * 获取商品规格接口
     *
     * @param map
     * @param observer
     */
    public void getItemsColorSize(Map<String, String> map, ApiResultObserver<ColorsSizeBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<ColorsSizeBean>> observable = service.getItemsColorSize(map);
        subscribe(observable, observer);
    }

    public void getHotCity(ApiObserver<ApiResult<HotCityBean>> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<ApiResult<HotCityBean>> observable = apiService.getHotCity();
        subscribe(observable, mObservable);
    }

    /**
     * 获取商品列表
     *
     * @param observer
     */
    public void getRelation(Map<String, Object> params, ApiResultObserver<CmsContentBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<CmsContentBean>> observable = service.getRelation(params);
        subscribe(observable, observer);
    }

    public void getRelationList(Map<String, Object> params, ApiResultObserver<RelationBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<RelationBean>> observable = service.getRelationList(params);
        subscribe(observable, observer);
    }

    public void getSameRecommendList(String itemCode, ApiResultObserver<List<SameRecommendBean>> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<List<SameRecommendBean>>> observable = service.getSameRecommend(itemCode);
        subscribe(observable, observer);
    }

    public void getSearchResult(Map<String, String> params, ApiResultObserver<SearchBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<SearchBean>> observable = service.getSearchResult(params);
        subscribe(observable, observer);
    }

    public void getGlobalDistrictBrand(ApiResultObserver<DistrictBrandBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<DistrictBrandBean>> observable = service.getGlobalDistrictBrand();
        subscribe(observable, observer);
    }

    /**
     * 写评论上传图片
     *
     * @param observer
     */
    public void uploadCommentPicture(Map<String, RequestBody> params, ApiResultObserver<REPictureBeanNew> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<REPictureBeanNew>> observable = service.uploadCommentPicture(params);
        subscribe(observable, observer);
    }

    public void getSmgData(Map<String, String> params, ApiResultObserver<SMGBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<SMGBean>> observable = service.getSmgData(params);
        subscribe(observable, observer);
    }


    /**
     * 获取购物总数(购物车图标显示的数字)
     *
     * @param params
     * @param observer
     */
    public void getCartsCount(Map<String, String> params, ApiResultObserver<CartNumBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<CartNumBean>> observable = service.getCartsCount(params);
        subscribe(observable, observer);
    }

    /**
     * 获取扫一扫网址白名单
     *
     * @param mObservable
     */
    public void getScanUrls(ApiObserver<String> mObservable) {
        ItemsService apiService = createService(ItemsService.class);
        Observable<String> observable = apiService.getScanUrls();
        subscribe(observable, mObservable);
    }

    /**
     * 获取商品详情接口
     *
     * @param params
     * @param observer
     */
    public void getItemDetail(String item_code, Map<String, Object> params, ApiResultObserver<CommodityDetailBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<CommodityDetailBean>> observable = service.getItemDetail(item_code, params);
        subscribe(observable, observer);
    }

    /**
     * 获取赠品接口
     *
     * @param params
     * @param observer
     */
    public void getItemEvent(String id, Map<String, Object> params, ApiResultObserver<ItemEventBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<ItemEventBean>> observable = service.getItemEvent(id, params);
        subscribe(observable, observer);
    }


    /**
     * 加入购物车接口
     *
     * @param params
     * @param observer
     */
    public void addItemToShopCart(Map<String, Object> params, ApiResultObserver<AddCartSuccessBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<AddCartSuccessBean>> observable = service.addItemToShopCart(params);
        subscribe(observable, observer);
    }

    /**
     * 合并两个网络请求一并请求
     *
     * @param specParams
     * @param giftParams
     * @param observer
     */
    public void getItemSpecAndGift(String itemcode, Map<String, Object> specParams, Map<String, Object> giftParams, ApiObserver<ItemSpec> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<CommodityDetailBean>> specObservable = service.getItemDetail(itemcode, specParams);
        Observable<ApiResult<ItemEventBean>> giftObservable = service.getItemEvent(itemcode, giftParams);
        Observable<ItemSpec> observable = Observable.zip(specObservable, giftObservable, new BiFunction<ApiResult<CommodityDetailBean>, ApiResult<ItemEventBean>, ItemSpec>() {
            @Override
            public ItemSpec apply(@NonNull ApiResult<CommodityDetailBean> commodityDetailBeanApiResult, @NonNull ApiResult<ItemEventBean> itemEventBeanApiResult) throws Exception {
                ItemSpec itemSpec = new ItemSpec();
                if (commodityDetailBeanApiResult.getCode() == 200 && commodityDetailBeanApiResult.getData() != null) {
                    itemSpec.detailBean = commodityDetailBeanApiResult.getData();
                }
                if (itemEventBeanApiResult.getCode() == 200 && itemEventBeanApiResult.getData() != null) {
                    itemSpec.eventBean = itemEventBeanApiResult.getData();
                }
                return itemSpec;
            }
        });
        subscribe(observable, observer);
    }


    /**
     * 引导页广告
     *
     * @param observer
     */
    public void getGuidePageAdvert(ApiResultObserver<CmsContentBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<CmsContentBean>> observable = service.getGuidePageAdvert();
        subscribe(observable, observer);
    }

    /**
     * 成功页面获取活动数据
     *
     * @param observer
     */
    public void getFullCutEvents(ApiResultObserver<List<EventResultsItem>> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<List<EventResultsItem>>> observable = service.getFullCutEvents();
        subscribe(observable, observer);
    }

    /**
     * 获取视频播放的分享数据
     *
     * @param observer
     */
    public void getVideoShareBean(ApiResultObserver<ShareBean> observer) {
        ItemsService service = createService(ItemsService.class);
        Observable<ApiResult<ShareBean>> observable = service.getVideoShareBean();
        subscribe(observable, observer);
    }


}
