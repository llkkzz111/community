package com.ocj.oms.mobile.http.service.items;

import com.ocj.oms.common.net.mode.ApiResult;
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
import com.ocj.oms.mobile.bean.items.SameRecommendBean;

import java.util.List;
import java.util.Map;

import io.reactivex.Observable;
import okhttp3.RequestBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.PartMap;
import retrofit2.http.Path;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * Created by liuzhao on 2017/6/9.
 */

public interface ItemsService {

    /**
     * 全球购首页商品列表
     */
    @GET("/cms/pages/relation/pageV1?id=AP1706A004")
    Observable<ApiResult<CmsContentBean>> getAbroadItems();

    /**
     * 获取更多推荐接口
     */
    @GET("/cms/pages/relation/nextPageV1")
    Observable<ApiResult<AbroadRecomendBean>> getMoreAbroadItem(
            @Query(value = "id") String id,
            @Query(value = "pageNum") int pageNum,
            @Query(value = "pageSize") int pageSize);

    /**
     * 视频详情页面
     */
    @GET("/cms/pages/relation/pageV1?id=AP1706A048")
    Observable<ApiResult<CmsContentBean>> getVideoDetail(@Query(value = "contentCode") String contentCode);

    /**
     * 创建评价列表
     */
    @GET("/api/orders/orders/orderdetailnew")
    Observable<ApiResult<DataBean>> getCommentItems(@QueryMap Map<String, String> params);

    /**
     * 获取退换货原因列表
     *
     * @return
     */
    @GET("/api/customerservice/itemreturn/reason")
    Observable<ApiResult<ReasonListBean>> getItemReturnReasons();

    /**
     * 退换货上传图片
     *
     * @return
     */
    @Multipart
    @POST("/api/customerservice/itemreturn/uploadpicture")
    Observable<ApiResult<RetExPictureBean>> uploadREPicture(@PartMap Map<String, RequestBody> params);

    /**
     * 提交退换货表单
     *
     * @return
     */
    @Headers({"Content-Type: application/json"})
    @POST("/api/customerservice/itemreturn/application")
    Observable<ApiResult<Result<String>>> submitItemReturn(@Body RequestBody body);

    /**
     * 获取订单详情数据
     *
     * @param params
     * @return
     */
    @GET("/api/orders/orders/orderdetail")
    Observable<ApiResult<OrderDetailBean>> getOrderDetail(@QueryMap Map<String, String> params);

    /**
     * 写入商品评价内容
     *
     * @param
     * @return
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/interactions/comments/add")
    Observable<ApiResult<Result<String>>> uploadComment(@Body RequestBody route);


    /**
     * 获取vip页面数据
     */
    @GET("/api/items/item/viphomepage")
    Observable<ApiResult<VipNewBean>> getVipItems();

    /**
     * 获取地理位置信息
     */
    @GET("http://restapi.amap.com/v3/geocode/regeo")
    Observable<String> getVipItems1(@QueryMap Map<String, String> params);

    /**
     * 获取商品详情接口
     */
    @GET("/api/items/items/appdetail/{item_Code}")
    Observable<ApiResult<CommodityDetailBean>> getItemDetail(@Path("item_Code") String item_code, @QueryMap Map<String, Object> map);

    /**
     * 根据商品获取相关的活动促销
     *
     * @param map
     * @return
     */
    @GET("/api/events/activitys/get_item_events/{item_id}")
    Observable<ApiResult<ItemEventBean>> getItemEvent(@Path("item_id") String item_id, @QueryMap Map<String, Object> map);


    /**
     * 加入购物车接口
     *
     * @param
     * @return
     */
    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/orders/carts/detailItemToCart")
    Observable<ApiResult<AddCartSuccessBean>> addItemToShopCart(@Body Map<String, Object> params);


    /**
     * 商品颜色规格
     */
    @GET("/api/items/initcolorsize")
    Observable<ApiResult<ColorsSizeBean>> getItemsColorSize(@QueryMap Map<String, String> map);


    /**
     * @return
     */
    @GET("/api/members/sites/substations")
    Observable<ApiResult<HotCityBean>> getHotCity();

    /**
     * 全球购商品列表
     *
     * @return
     */
    @GET("/cms/pages/relation/pageV1")
    Observable<ApiResult<CmsContentBean>> getRelation(@QueryMap Map<String, Object> params);

    @GET("/cms/pages/relation/nextPageV1")
    Observable<ApiResult<RelationBean>> getRelationList(@QueryMap Map<String, Object> params);


    /**
     * 2.20	API.01.16.001
     * 同品推荐
     */
    @GET("/api/items/other-items")
    Observable<ApiResult<List<SameRecommendBean>>> getSameRecommend(@Query(value = "Item_code") String itemCode);


    @GET("/api/search/search_center")
    Observable<ApiResult<SearchBean>> getSearchResult(@QueryMap Map<String, String> params);


    @GET("/api/items/items/globaldistrictbrand")
    Observable<ApiResult<DistrictBrandBean>> getGlobalDistrictBrand();

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/events/smg/redpackets")
    Observable<ApiResult<SMGBean>> getSmgData(@Body Map<String, String> params);

    /**
     * 写评价上传图片
     *
     * @return
     */
    @Multipart
    @POST("/api/interactions/comments/uploadpicture")
    Observable<ApiResult<REPictureBeanNew>> uploadCommentPicture(@PartMap Map<String, RequestBody> params);


    /**
     * 获取购物总数
     * <p>
     * API.03.01.005获取购物总数(购物车图标显示的数字)
     *
     * @return
     */

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/orders/carts/getCartsCount")
    Observable<ApiResult<CartNumBean>> getCartsCount(@Body Map<String, String> params);

    @GET("http://m.ocj.com.cn/mt/getLimitUrl")
    Observable<String> getScanUrls();


    /**
     * 引导页广告
     *
     * @return
     */
    @GET("cms/pages/relation/page?id=AP1706A050")
    Observable<ApiResult<CmsContentBean>> getGuidePageAdvert();

    @Headers({
            "Content-type: application/json"
    })
    @POST("/api/pay/getFullCutEvents")
    Observable<ApiResult<List<EventResultsItem>>> getFullCutEvents();

    @GET("/api/video/share")
    Observable<ApiResult<ShareBean>> getVideoShareBean();
}
