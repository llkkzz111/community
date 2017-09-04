//
//  WSHHWeiboLogin.h
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

typedef void (^WSHHWeiboHandler)(id data);


/**
 微博第三方登录
 */
@interface WSHHWeiboLogin : NSObject<WeiboSDKDelegate>

+ (instancetype)sharedInstance;


/**
 微博登录
 
 @param redirectUrl 登录授权回调页地址
 */
- (void)wshhWeiboLoginWithRedirectURL:(NSString*)redirectUrl scope:(NSString*)scope completionHandler:(WSHHWeiboHandler)handler;


/**
 分享文字、图片、网页url
 
 @param shareText 分享内容
 @param shareImage 分享图片
 @param shareWebUrl 分享网页url
 */
- (void)wshhShareSinaWeiboWithText:(NSString *)shareText
                             image:(NSString *)shareImage
                            webUrl:(NSString *)shareWebUrl;
- (void)wshhShareSinaWeiboWithText:(NSString *)shareText;

@property (nonatomic, copy) WSHHWeiboHandler weibogotoOCJLinkVCBlock;

@end
