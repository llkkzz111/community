//
//  OCJ_GlobalShoppingHttpAPI.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"
#import "OCJResponceModel_GlobalShopping.h"

@interface OCJ_GlobalShoppingHttpAPI : NSObject
/**
 全球购首页数据获取接口
 */
+ (void)ocjGlobalShopping_checkHomeHandler:(OCJHttpResponseHander)handler;

/**
 全球购首页分页数据接口
 componentid：商品的componentid
 pagenum：当前页码
 pagesize：每页数量条目
 */
+ (void)ocjGlobalShopping_checkHomeNext:(NSString *)componentid
                                PageNum:(NSString *)pagenum
                               PageSize:(NSString *)pagesize
                      complationHandler:(OCJHttpResponseHander)handler;
/**
 全球购商品列表界面
 */
+ (void)ocjGlobalShopping_checkGoodList:(NSString *)lGroup
                            contentType:(NSString*)contentType
                      ComplationHandler:(OCJHttpResponseHander)handler;


/**全球购商品列表分页数据*/
+ (void)ocjGlobalShopping_checkGoodListNext:(NSString *)componentid
                                    PageNum:(NSString *)pagenum
                         ScreeningCondition:(NSDictionary *)dictionary
                                ContentCode:(NSString *)contenCode
                          complationHandler:(OCJHttpResponseHander)handler;



/**
 获取热门地区和品牌信息
 */
+ (void)ocjGlobalShopping_getScreeningConditionComplationHandler:(OCJHttpResponseHander)handler;

/**
 * 广告页
 */
+ (void)ocjGlobalShopping_checkOCJURLPath_StartImageHomeComplationHandler:(OCJHttpResponseHander)handler;

@end
