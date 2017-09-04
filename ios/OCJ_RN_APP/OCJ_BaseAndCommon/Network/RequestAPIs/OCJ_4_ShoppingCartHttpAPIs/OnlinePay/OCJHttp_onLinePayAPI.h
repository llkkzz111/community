//
//  OCJHttp_onLinePayAPI.h
//  OCJ
//
//  Created by OCJ on 2017/5/26.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

@interface OCJHttp_onLinePayAPI : NSObject

/**
 获取换货原因接口
 */
+ (void)ocj_getReChangeResonComplationHandler:(OCJHttpResponseHander)handler;
/**
 支付完成之后商品推荐列表

 @param handler 支付完成之后商品推荐列表回调block
 */
+ (void)ocj_getAllRecommandComplationHandler:(OCJHttpResponseHander)handler;

/**
 在线支付接口
 @param orderNO 订单号
 @param handler 回调block
 */
+ (void)ocjPayMoneyWithOrderNO:(NSString *)orderNO complationHandler:(OCJHttpResponseHander)handler;
/**
 获取订单凭据接口
 @param order_no  订单号
 @param paymthod  支付id
 @param saveamt   积分
 @param deposit   预付款
 @param giftcard  礼包
 @param handler   回调block
 */
+ (void)ocjPayGetEvidenceWithOrderNo:(NSString *)order_no paymthod:(NSString *)paymthod saveamt:(NSString *)saveamt deposit:(NSString *)deposit gistcard:(NSString *)giftcard complationHandler:(OCJHttpResponseHander)handler;

/**
 订单号查询接口
 @param order_no 订单号
 */
+ (void)ocjQueryOrderSateWithOrderNO:(NSString *)order_no complationHandler:(OCJHttpResponseHander)handler;



@end

@interface OCJModel_onLinePay : OCJBaseResponceModel
@property (nonatomic,copy) NSString        * ocjStr_payStyle;      ///< 在线支付
@property (nonatomic,copy) NSString        * ocjStr_order_no;
@property (nonatomic,copy) NSString        * ocjStr_c_code;
@property (nonatomic,copy) NSArray         * ocjArr_imgUrlList;     ///< 订单商品列表
@property (nonatomic,copy) NSString        * ocjStr_double_deposit;
@property (nonatomic,copy) NSString        * ocjStr_double_cardamt;
@property (nonatomic,copy) NSString        * ocjStr_double_saveamt;
@property (nonatomic,copy) NSString        * ocjStr_cust_no;         ///< cust_no
@property (nonatomic,copy) NSString        * ocjStr_realPayAmt;      ///< 商品实际价格
@property (nonatomic,copy) NSString        * ocjStr_useable_deposit; ///< 预付款
@property (nonatomic,copy) NSString        * ocjStr_useable_saveamt; ///< 积分
@property (nonatomic,copy) NSString        * ocjStr_useable_cardamt; ///< 礼包
@property (nonatomic,copy) NSMutableArray  * ocjArr_lastPayment;
@property (nonatomic,copy) NSString        * ocjStr_useSaveamt;      ///< 是否可使用积分
@property (nonatomic,copy) NSString        * ocjStr_useCardamt;      ///< 是否可用礼包
@property (nonatomic,copy) NSString        * ocjStr_useDesposit;     ///< 是否可用预付款
@property (nonatomic,copy) NSString        * ocjStr_onlineReduce;    ///< 在线支付立减优惠

@end
