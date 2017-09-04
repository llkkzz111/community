//
//  OCJHttp_myWalletAPI.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"
#import "OCJResponceModel_myWallet.h"
#import "OCJScoreDetaiModel.h"


/**
 我的钱包模块接口类
 */
@interface OCJHttp_myWalletAPI : NSObject

/**
 礼券兑换接口

 @param gift_no 礼券号
 @param gift_password 礼券密码
 @param handler 回调block
 */
+ (void)ocjWallet_exchangeGiftTicketsWithGift_no:(NSString *)gift_no
                                       gift_password:(NSString *)gift_password
                                   completionHandler:(OCJHttpResponseHander)handler;

/**
 (礼包兑换)钱包充值接口

 @param card_no 充值卡号
 @param passwd 充值密码
 @param handler 回调block
 */
+ (void)ocjWallet_rechargeWalletWithCardNO:(NSString *)card_no
                                    passwd:(NSString *)passwd
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 (礼包兑换)余额查询

 @param card_no 礼品卡号
 @param passwd 礼品卡密码
 @param handler 回调block
 */
+ (void)ocjWallet_checkBalanceWithCardNO:(NSString *)card_no
                                  passwd:(NSString *)passwd
                       completionHandler:(OCJHttpResponseHander)handler;
/**
 (积分详情)积分列表获取
 
 @param type 类型     -1：所有记录(默认) 0:积分获取  1：积分支付 3：即将过期积分
 @param page 页序号
 @param handler 回调block
 */

+ (void)ocjWallet_scoreDetailWithType:(NSString *)type
                                page:(NSInteger)page
                               completionHandler:(OCJHttpResponseHander)handler;
/**
 (积分详情)积分余额查询
 @param handler 回调block
 */
+ (void)ocjWallet_scoreQueryCompletionHandler:(OCJHttpResponseHander)handler;
/**
 (预付款)获取积分列表
 
 @param type 类型  空=全部，1=取得, 2=使用
 @param page 页序号
 @param handler 回调block
 */

+ (void)ocjWallet_PreMoneyWithType:(NSString *)type
                                page:(NSInteger)page
                    completionHandler:(OCJHttpResponseHander)handler;

/**
 (预付款)积分余额查询
 @param handler 回调block
 */
+ (void)ocjWallet_PreMoneyQueryCompletionHandler:(OCJHttpResponseHander)handler;
/**
 抵用券明细查询接口

 @param statusType 抵用券状态
 @param page 分页
 @param handler 回调block
 */
+ (void)ocjWallet_checkCouponDetailWithStatusType:(NSString *)statusType
                                             page:(NSInteger)page
                                completionHandler:(OCJHttpResponseHander)handler;

/**
 抵用券计数查询接口

 @param handler 回调block
 */
+ (void)ocjWallet_checkCouponNumCompletionHandler:(OCJHttpResponseHander)handler;

/**
 抵用券兑换接口(未用到)

 @param coupon_no 抵用券编号
 @param handler 回调block
 */
+ (void)ocjWallet_exchangeCouponWithCouponNo:(NSString *)coupon_no
                           completionHandler:(OCJHttpResponseHander)handler;

/**
 (礼包)获取礼包详情
 
 @param type 类型  空=全部，1=取得, 2=使用
 @param page 页序号
 @param handler 回调block
 */

+ (void)ocjWallet_RewardWithType:(NSString *)type
                              page:(NSInteger)page
                 completionHandler:(OCJHttpResponseHander)handler;

/**
 (礼包)积分余额查询
 @param handler 回调block
 */
+ (void)ocjWallet_RewardQueryCompletionHandler:(OCJHttpResponseHander)handler;

/**
 淘券明细查询接口

 @param page 页序号
 @param handler 回调block
 */
+ (void)ocjWallet_checkTaoCouponDetailWithPage:(NSInteger)page
                             completionHandler:(OCJHttpResponseHander)handler;

/**
 淘券兑换接口(钱包抵用券兑换券)

 @param coupon_no 淘券代码
 @param handler 回调block
 */
+ (void)ocjWallet_exchangeTaoCouponWithCouponNO:(NSString *)coupon_no
                                completionhandler:(OCJHttpResponseHander)handler;

/**
 淘券领取接口

 @param coupon_no 券编号
 @param handler 回到block
 */
+ (void)ocjWallet_getTaoCouponWithCouponNo:(NSString *)coupon_no
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 欧点详情列表

 @param type 筛选类型（1-全部 2-使用过记录 3-获得记录 4-即将过期）
 @param page 页码
 @param handler 回调block
 */
+ (void)ocjWallet_europeDetailWithType:(NSString*)type page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler;


/**
 获取欧点余额

 @param handler 回调block
 */
+ (void)ocjWallet_checkEuropeNumCompletionHandler:(OCJHttpResponseHander)handler;

@end
