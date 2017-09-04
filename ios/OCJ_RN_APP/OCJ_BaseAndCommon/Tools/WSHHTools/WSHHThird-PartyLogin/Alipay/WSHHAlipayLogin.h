//
//  WSHHAlipayLogin.h
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

/**
 alipay第三方登录回调
 */
typedef void (^WSHHAlipayLoginHandler)(NSString *authCode);

typedef void (^WSHHAlipayPayHandler)(NSDictionary *resultDic);

/**
 支付宝第三方登录
 */
@interface WSHHAlipayLogin : NSObject


/**
 支付宝组件类单例

 @return 对象
 */
+ (instancetype)sharedInstance;


/**
 支付宝第三方授权登录

 @param signStr 跳转签名
 */
- (void)wshhAlipayLoginWithSignStr:(NSString*)signStr completionHandler:(WSHHAlipayLoginHandler)handler;


/**
 支付宝支付

 @param signStr 跳转签名
 */
- (void)wshhAlipayPaymentWithSignString:(NSString *)signStr completionHandler:(WSHHAlipayPayHandler)handler;



@end
