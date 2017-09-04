//
//  OCJUserInfoManager.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* OCJAccessToken = @"access_token"; ///< 登录凭证
static NSString* OCJAccessToken_guest = @"guest_access_token"; ///< 游客登录凭证
static NSString* OCJCustNo = @"cust_no"; ///< 用户编号
static NSString* OCJUserInfo_Province = @"cityInfo";  ///< 分站信息
static NSString* OCJDeviceID = @"device_id"; ///< 设备编号

typedef NS_ENUM(NSInteger,OCJUserTokenType) {
  OCJUserTokenTypeMember, ///< 会员
  OCJUserTokenTypeVisitor ///< 游客
  
};


/**
 用户信息管理类
 */
@interface OCJUserInfoManager : NSObject


/**
 保存用户登录凭证

 @param loginInfoDic 登录后接口返回的信息
 @param userType 用户类型
 */
+ (void)ocj_loginAndSaveAccessToken:(NSDictionary *)loginInfoDic
                           userType:(OCJUserTokenType )userType;


/**
 用户登出替换token

 @param accessToken 游客登录凭证
 */
+ (void)ocj_loginOutAndSaveGuestAccessToken:(NSString*)accessToken;



/**
 获取用户信息并保存
 */
+ (void)ocj_getUserInfoAndSave;



/**
 为RN获取Token

 @return 带有token的字典
 */
+ (NSDictionary*)ocj_getTokenForRN;

@end



