//
//  OCJHttp_orderConfirmAPI.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

@interface OCJHttp_orderConfirmAPI : NSObject

/**
 预约订单信息查询接口

 @param item_code 预约商品号
 @param unit_code 商品规格号
 @param qty 数量
 @param handler 回调block
 */
+ (void)ocjShoppingCart_createAppointmentOrderWithDictionary:(NSDictionary *)dic
                                         completionHandler:(OCJHttpResponseHander)handler;

/**
 
 预约订单写入接口
 
 @param item_code 预约商品号(必填)
 @param unit_code 商品规格号(必填)
 @param pay_methd 支付方式 1：货到现金 2：货到刷卡(必填)
 @param saveamt 积分
 @param deposit 预付款
 @param savebouns 礼包
 @param receiver_seq 收货人序列号
 @param itemCodeCoupon 抵用券(商品编号_抵用券编号_抵用券序列号)
 @param dccounpon_amt 抵用券金额
 @param pay_flg 是否需要发货前电话通知
 @param handler 回调block
 */
+ (void)ocjShoppingCart_confirmAppointmentOrderWithItemcode:(NSString *)item_code
                                                  unitcode:(NSString *)unit_code
                                                  payMethod:(NSString *)pay_methd
                                                    saveamt:(NSString *)saveamt
                                                    deposit:(NSString *)deposit
                                                  savebouns:(NSString *)savebouns
                                                receiverSeq:(NSString *)receiver_seq
                                             itemCodeCoupon:(NSString *)itemCodeCoupon
                                                dccouponAmt:(NSString *)dccounpon_amt
                                                  contactMe:(NSString *)pay_flg
                                          completionhandler:(OCJHttpResponseHander)handler;

@end
