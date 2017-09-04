//
//  OCJTestDataSource.h
//  OCJ
//
//  Created by Ray on 2017/5/22.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCJTestDataSource : NSObject

/**
 抵用券详情
 */
+ (OCJBaseResponceModel *)ocj_getCouponDetailVCDataSourceWithPage:(NSInteger)page;

/**
 抢券列表
 */
+ (OCJBaseResponceModel *)ocj_getTaoCouponDetailVCDataSourceWithPage:(NSInteger)page;

/**
 兑换抵用券
 */
+ (OCJBaseResponceModel *)ocj_getExchangeCouponDataSource;

/**
 查询余额
 */
+ (OCJBaseResponceModel *)ocj_getCheckBalanceDataSource;

/**
 钱包充值
 */
+ (OCJBaseResponceModel *)ocj_getRechargeWalletDataSource;

/**
 兑换礼包
 */
+ (OCJBaseResponceModel *)ocj_getExchangeGiftTicketsDataSource;

/**
 领取淘券
 */
+ (OCJBaseResponceModel *)ocj_getExchangeTaoCouponDataSource;

/**
 积分详情
 */
+ (OCJBaseResponceModel *)ocj_getScoreDetailVCDataSource;

/**
 
 积分详情积分
 */
+ (OCJBaseResponceModel *)ocj_getScoreListBalanceDataSource;

/**
 预付金额
 */
+ (OCJBaseResponceModel *)ocj_getPreMoneyDataSource;

/**
 预付款列表
 */
+ (OCJBaseResponceModel *)ocj_getPreMoneyListDataSource;

/**
 礼包详情列表
 */
+ (OCJBaseResponceModel *)ocj_getRewardListDataSource;

/**
 礼包余额
 */
+ (OCJBaseResponceModel *)ocj_getRewardBalanceDataSource;

/**
 在线支付方式数据
 */
+ (OCJBaseResponceModel *)ocj_getOnLineDataSource;
/**
 获取欧点数据
 */
+ (OCJBaseResponceModel *)ocj_getEurposeDataSource;

/**
 获取订单号信息
 */
+ (OCJBaseResponceModel *)ocj_getAplipayDataSource;

@end
