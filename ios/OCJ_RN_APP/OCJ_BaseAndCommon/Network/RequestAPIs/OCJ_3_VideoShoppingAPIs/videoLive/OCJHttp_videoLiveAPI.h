//
//  OCJHttp_videoLiveAPI.h
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

@interface OCJHttp_videoLiveAPI : NSObject

/**
 获取正在直播数据

 @param Id id
 @param contentCode 视频id
 @param handler 回调block
 */
+ (void)OCJVideoLive_getVideoLiveDetailWithID:(NSString *)Id
                                  contentCode:(NSString *)contentCode
                            completionHandler:(OCJHttpResponseHander)handler;

/**
 查看更多视频分页

 @param Id componentList中的id
 @param pageNum 查询的页数
 @param pageSize 分页显示数量
 @param handler 回调block
 */
+ (void)OCJVideoLive_getMoreVideoWithID:(NSString *)Id
                                pageNum:(NSInteger)pageNum
                               pageSize:(NSString *)pageSize
                      completionhandler:(OCJHttpResponseHander)handler;


/**
 商品详情查询接口

 @param item_code 商品编号(必填)
 @param orderno 订单编号
 @param dmnid 统计点击数量
 @param isPufa 是否靠谱闪购活动商品
 @param isBone 是否FamilyDay商品
 @param media_channel 媒体渠道
 @param source_obj 资源url
 @param handler 回调block
 */
+ (void)OCJVideoLive_getGoodsDetailWithItemCode:(NSString *)item_code
                                        orderno:(NSString *)orderno
                                          dmnid:(NSString *)dmnid
                                         isPufa:(NSString *)isPufa
                                         isBone:(NSString *)isBone
                                   mediaChannel:(NSString *)media_channel
                                      sourceUrl:(NSString *)source_obj
                              completionHandler:(OCJHttpResponseHander)handler;

/**
 加入购物车接口

 @param item_code 商品编号(必填)
 @param num 数量(必填)
 @param unit_code 规格编号(必填)
 @param gift_item_codes 赠品编号(数组如  4,5,6)(非必填)
 @param gift_unit_codes 赠品规格编号(数组如001,002,003)(非必填)
 @param gift_nos 赠品促销编号(数组如100101,100102)(非必填)
 @param giftPromo_seqs 赠品促销seqs(数组如  4,5,6)(非必填)
 @param Shop_no 店铺编号(必填)
 @param media_channel 媒体渠道(非必填)
 @param source_url 来源url(必填)
 @param handler 回调block
 */
+ (void)OCJVideoLive_addToCartWithItemCode:(NSString *)item_code
                                       num:(NSString *)num
                                  unitCode:(NSString *)unit_code
                              giftItemCode:(NSArray *)gift_item_codes
                              giftUnitCode:(NSArray *)gift_unit_codes
                              giftPromoNos:(NSArray *)gift_nos
                             giftPromoSeqs:(NSArray *)giftPromo_seqs
                                    shopNo:(NSString *)Shop_no
                              mediaChannel:(NSString *)media_channel
                                 sourceUrl:(NSString *)source_url
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 获取赠品接口

 @param item_code 商品编号
 @param handler 回调block
 */
+ (void)OCJVideoLive_getGiftListWithItemCode:(NSString *)item_code
                           completionHandler:(OCJHttpResponseHander)handler;

/**
 查询购物车数量接口

 @param handler 回调block
 */
+ (void)OCJVideoLive_getCartNumCompletionHandler:(OCJHttpResponseHander)handler;

@end
