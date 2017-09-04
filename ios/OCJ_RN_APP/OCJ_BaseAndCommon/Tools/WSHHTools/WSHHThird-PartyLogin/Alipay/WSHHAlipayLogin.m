//
//  WSHHAlipayLogin.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHAlipayLogin.h"
#import "RSADataSigner.h"
#import "APAuthV2Info.h"

NSString* const OCJAppScheme_Alipay = @"OCJAliPay";

@implementation WSHHAlipayLogin

+ (instancetype)sharedInstance {
    static WSHHAlipayLogin *wshhAlipayLogin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wshhAlipayLogin = [[self alloc] init];
    });
    return wshhAlipayLogin;
}


- (void)wshhAlipayLoginWithSignStr:(NSString*)signStr completionHandler:(WSHHAlipayLoginHandler)handler{
    
    [[AlipaySDK defaultService] auth_V2WithInfo:signStr
                                     fromScheme:OCJAppScheme_Alipay
                                       callback:^(NSDictionary *resultDic) {
                                           NSLog(@"resultDic = %@",resultDic);
                                           // 解析 auth code
                                           NSString *result = resultDic[@"result"];
                                           NSString *authCode = nil;
                                           if (result.length>0) {
                                               NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                               for (NSString *subResult in resultArr) {
                                                   if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                       NSString* subStr = [subResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                       NSArray* authCodeArray = [subStr componentsSeparatedByString:@"="];
                                                       if (authCodeArray.count == 2) {
                                                           authCode = authCodeArray[1];
                                                       }
                                                       
                                                       break;
                                                   }
                                               }
                                           }
                                           NSLog(@"支付宝授权码：%@", authCode);
                                           handler(authCode);
                                       }];
}

- (void)wshhAlipayPaymentWithSignString:(NSString *)signStr completionHandler:(WSHHAlipayPayHandler)handler{
    
    //本地未安装支付宝客户端，或未成功调用支付宝客户端进行支付的情况下（走H5收银台），会通过该completionBlock返回支付结果
    //调用结果开始支付
    [[AlipaySDK defaultService] payOrder:signStr fromScheme:OCJAppScheme_Alipay callback:^(NSDictionary *resultDic) {
      
        handler(resultDic);
    }];
}

@end
