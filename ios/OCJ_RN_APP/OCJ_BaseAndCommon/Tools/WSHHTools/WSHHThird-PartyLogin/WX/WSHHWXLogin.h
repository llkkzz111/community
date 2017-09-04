//
//  WSHHWXLogin.h
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef void (^WSHHWechatHandler)(id data);///< 回调block

typedef void (^wshhWXShareManagerBlock)(BaseResp *resp,enum WXErrCode errCode);

typedef NS_ENUM(NSInteger, WSHHWXShareType) {
    WSHHWXShareTypeSession,     ///<微信好友
    WSHHWXShareTypeTimeline     ///<微信朋友圈
};

/**
 微信第三方登录
 */
@interface WSHHWXLogin : NSObject<WXApiDelegate>


/**
 微信组件类单例

 @return 对象
 */
+ (instancetype)sharedInstance;


/**
 微信第三方登录

 @param handler 回调句柄
 */
- (void)wshhWXLoginCompletionHandler:(WSHHWechatHandler)handler;

/**
 微信分享到朋友圈
 
 @param shareText 分享内容
 @param shareImage 分享图片
 @param shareTitle 分享标题
 @param shareUrl 分享链接
 @param resultBlock 回调block
 */
- (void)wshhShareToWXWithText:(NSString *)shareText
                                 image:(NSString *)shareImage
                                 title:(NSString *)shareTitle
                                   url:(NSString *)shareUrl
                                  type:(WSHHWXShareType)type
                           resultBlock:(void (^)(BaseResp *resp, enum WXErrCode errCode))resultBlock;

- (void)wshhWXPayByPoCode:(NSDictionary *)pocode block:(void (^)(BaseResp *resp, enum WXErrCode errCode,NSString *prePayId))block;


@property (nonatomic, copy) wshhWXShareManagerBlock resultBlock;

@end
