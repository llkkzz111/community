//
//  WSHHQQSDKCall.h
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

typedef void (^QQGotoOCJLinkingAccountVC)(id data);

/**
 分享到qq枚举类型
 */
typedef NS_ENUM(NSInteger, WSHHEnumTQQShareType) {
    WSHHEnumQQShareQZone = 1,       ///<分享到QQ空间
    WSHHEnumQQShareQFriends         ///<分享到QQ好友
};

/**
 QQ第三方登录
 */
@interface WSHHQQSDKCall : NSObject<TencentSessionDelegate,TencentApiInterfaceDelegate,TencentLoginDelegate>

+ (instancetype)sharedInstance;

/**
 设置QQ开放应用appID
 */
- (void)wshh_setTencentAppID:(NSString*)appID;

/**
 QQ第三方登录
 */
- (void)wshhQQLogin;

/**
 分享到QQ
 
 @param shareTitle 分享标题
 @param shareUrl 分享链接(网页链接)
 @param shareDescription 分享描述
 @param sharePreviewImageUrl 分享预览图片(url链接或者图片)
 @param shareType 分享到空间还是好友
 */
- (void)wshhShareQQWithTitle:(NSString *)shareTitle
                         url:(NSString *)shareUrl
                 description:(NSString *)shareDescription
             previewImageUrl:(NSString *)sharePreviewImageUrl
                        type:(WSHHEnumTQQShareType)shareType;

@property (nonatomic, copy) QQGotoOCJLinkingAccountVC gotoLinkingVCBlock;

@end
