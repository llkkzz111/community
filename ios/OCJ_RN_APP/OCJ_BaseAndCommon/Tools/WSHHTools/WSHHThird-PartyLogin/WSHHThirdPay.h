//
//  WSHHThirdPay.h
//  OCJ
//
//  Created by Ray on 2017/5/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ThirdPayCallbackBlock)(NSDictionary *order);


/**
 在线支付类
 */
@interface WSHHThirdPay : NSObject

+ (instancetype)sharedInstance;


/**
 alipay接口

 @param signStr 后台返回签名信息
 @param block 回调block
 */
- (void)wshh_alipyPayWithOrder:(NSString *)signStr block:(ThirdPayCallbackBlock)block;

/**
 微信支付接口

 @param poCode 后台返回参数
 @param block 回调block
 */
- (void)wshh_wxPayWithOrder:(NSDictionary *)poCode block:(ThirdPayCallbackBlock)block;

/**
 银联支付

 @param payOrder 后台返回参数
 @param block 回调block
 */
- (void)wshh_uPPayWithOrder:(NSString *)payOrder block:(ThirdPayCallbackBlock)block;

/**
 applePay

 @param tn 流水号
 @param block 回调block
 */
- (void)wshh_applePayWithOrder:(NSDictionary *)payDic block:(ThirdPayCallbackBlock)block;

/**
 第三方回调(银联和支付宝)

 @param url 回调url
 */
- (void)wshh_thirdPartyCompletionHandlerWithUrl:(NSURL *)url;

@property (nonatomic, copy) ThirdPayCallbackBlock wshhThirdPayBlock;

@end
