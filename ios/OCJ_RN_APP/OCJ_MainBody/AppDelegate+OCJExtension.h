//
//  AppDelegate+OCJExtension.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "AppDelegate.h"

typedef void(^OCJAutologinBlock) (NSDictionary* autoLoginDic);//autoLoginDic @{@"autoLoginType":@"自动登录类型 member-会员 guets-游客",@"loginResult":@"登录结果 1-成功 0-失败"}

static NSString* OCJNotice_NeedLogin = @"ocjNotice_needLogin"; ///< 需要登录的通知

@interface AppDelegate (OCJExtension)

/**
 获取唯一AppDelegate对象

 @return 唯一AppDelegate对象
 */
+(instancetype)ocj_getShareAppDelegate;


/**
 检验用户的token情况，决定是进行游客登录还是会员自动登录
 */
- (void)ocj_checkGuestOrMemberAccessTokenCompletion:(OCJAutologinBlock)handler;


/**
 请求游客token

 @param handler 
 */
-(void)ocj_regetGuestTokenCompletion:(OCJAutologinBlock)handler;


/**
 *  首页选择开关
 */
- (void)ocj_switchRootViewController;


/**
 *  返回至登录界面
 */
- (void)ocj_reLogin;


/**
 获取当前最上层的VC

 @return 最上层VC
 */
+ (UIViewController*)ocj_getTopViewController;


/**
 收起键盘
 */
+ (void)ocj_dismissKeyboard;

@end
