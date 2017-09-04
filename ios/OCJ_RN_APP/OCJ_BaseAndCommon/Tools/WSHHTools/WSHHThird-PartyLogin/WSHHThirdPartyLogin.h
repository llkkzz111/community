//
//  WSHHThirdPartyLogin.h
//  OCJ
//
//  Created by 吴志伟 on 2017/4/26.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSHHQQSDKCall.h"
#import "WSHHWXLogin.h"
#import "WSHHWeiboLogin.h"
#import "WSHHAlipayLogin.h"

/**
 第三方登录平台枚举类型
 */
typedef NS_ENUM(NSInteger, WSHHEnumThirdPartyLoginType) {
    WSHHEnumThirdPartyWX = 1,    ///<微信登录
    WSHHEnumThirdPartyQQ,        ///<QQ登录
    WSHHEnumThirdPartyAlipay,    ///<支付宝登录
    WSHHEnumThirdPartyWeibo      ///<微博登录
};


/**
 分享第三方平台枚举类型
 */
typedef NS_ENUM(NSInteger, WSHHEnumShareType) {
    WSHHEnumShareTypeQZone = 1,     ///<QQ空间
    WSHHEnumShareTypeQFriend,       ///<QQ好友列表
    WSHHEnumShareTypeWXSession,     ///<微信好友
    WSHHEnumShareTypeWXTimeLine,    ///<微信朋友圈
    WSHHEnumShareTypeWeibo          ///<微博
};

typedef void (^wshhThirdPartyLoginBlock)(id responseData);

@interface WSHHThirdPartyLogin : NSObject


/**
 配置第三方平台
 */
+ (void)wshh_settingThirdParty;

/**
 第三方登录调用接口
 
 @param signStr 第三方跳转签名（支付宝必填，其他选填）
 */
+ (void)wshh_thirdPartyLoginWithType:(WSHHEnumThirdPartyLoginType)loginType andSignStr:(NSString*)signStr block:(wshhThirdPartyLoginBlock)block;


/**
 判断手机是否安装QQ、微信、微博、支付宝第三方APP

 @param type 第三方平台枚举类型
 @return 返回值
 */
+ (BOOL)wshh_thirdPartyIsInstalledWithType:(WSHHEnumThirdPartyLoginType)type;


/**
 分享到第三方平台

 @param shareType 分享平台类型
 @param shareText 分享内容
 @param shareTitle 分享标题
 @param shareImageUrl 预览图片(图片或url链接)
 @param shareUrl 分享链接
 @param shareDescription 分享详细描述
 */
+ (void)wshh_ThirdPartyShareWithShareType:(WSHHEnumShareType)shareType
                                     text:(NSString *)shareText
                                    title:(NSString *)shareTitle
                          previewImageUrl:(NSString *)shareImageUrl
                                      url:(NSString *)shareUrl
                              description:(NSString *)shareDescription;

@end
