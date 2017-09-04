//
//  OCJHomePageVC.h
//  OCJ
//
//  Created by yangyang on 17/4/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//
#import "OCJBaseVC.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>
typedef void(^OCJHomePageCallback) (NSDictionary * response);///< 回调block

@interface OCJHomePageVC : OCJBaseVC

@property (nonatomic, copy)OCJHomePageCallback ocjCallback; ///< 登录成功 回调


/**
 显示签到小鸟
 */
-(void)ocj_showSignInView;


/**
 隐藏签到小鸟
 */
-(void)ocj_hideSignInView;


-(void)loadRN;

@end
