//
//  OCJHttp_evaluateAPI.h
//  OCJ
//
//  Created by Ray on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

@interface OCJHttp_evaluateAPI : NSObject




/**
 退换货申请写入接口
 @param orderNo 订单编号
 @param handler 接口回调
 */
+ (void)ocjPersonal_RefundGoodsWithOrderNO:(NSDictionary *)orderNo completionHandler:(OCJHttpResponseHander)handler;

/**
 获取退货原因编码接口

 @param orderNo 订单号
 @param handler 接口回调
 */
+ (void)ocj_getRefunndGoodsReasonCodeWithOrderNO:(NSDictionary *)orderNo completionHandler:(OCJHttpResponseHander)handler;

/**
 评价写入接口

 @param dic 数据字典
 @param handler 回调block
 */
+ (void)ocjPersonal_evaluateGoodsWithDictionary:(NSDictionary *)dic
                        completionHandler:(OCJHttpResponseHander)handler;

/**
 图片批量上传接口

 @param order_no 订单编号
 @param order_g_seq 订单商品序号
 @param order_d_seq 赠品序号
 @param order_w_seq 操作序号
 @param retItemCode 回收商品编号
 @param retUnitCode 回收商品单件号
 @param receiverSeq 退换货地址编码
 @param imageArr 图片数组
 @param handler 回调block
 */
+ (void)ocjPersonal_getImageAddressWithOrderNo:(NSString *)order_no
                                      goodsNo:(NSString *)order_g_seq
                                        giftNo:(NSString *)order_d_seq
                                    operatonNo:(NSString *)order_w_seq
                                   retItemCode:(NSString*)retItemCode
                                   retUnitCode:(NSString*)retUnitCode
                                   receiverSeq:(NSString*)receiverSeq
                                      imageArr:(NSArray *)imageArr
                             completionHandler:(OCJHttpResponseHander)handler;

/**
 获取订单详情接口

 @param order_no 订单编号
 @param handler 回调block
 */
+ (void)ocjPersonal_getOrderDetailWithOrderNo:(NSString *)order_no
                                    orderType:(NSString *)order_type
                                       c_code:(NSString *)c_code
                            completionHandler:(OCJHttpResponseHander)handler;

@end
