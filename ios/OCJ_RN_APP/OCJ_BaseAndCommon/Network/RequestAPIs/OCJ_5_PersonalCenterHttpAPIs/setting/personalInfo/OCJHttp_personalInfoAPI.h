//
//  OCJHttp_personalInfoAPI.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"
#import "OCJResModel_personalInfo.h"

/**
 个人信息接口类
 */
@interface OCJHttp_personalInfoAPI : NSObject

/**
 修改会员手机号

 @param mobile 手机号
 @param smspasswd 短信验证码
 @param handler 回调block
 */
+ (void)ocjPersonal_changeMobileWithMobile:(NSString *)mobile
                               smspassword:(NSString *)smspasswd
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 修改用户头像

 @param file 图片data
 @param handler 回调block
 */
+ (void)ocjPersonal_changePortraitWithFile:(NSData *)file
                          completionHandler:(OCJHttpResponseHander)handler;

/**
 修改用户昵称

 @param cust_upstatus 修改状态(非必须)
 @param cust_name 修改的名字
 @param handler 回调block
 */
+ (void)ocjPersonal_changeNickNameWithCustUpstatus:(NSString *)cust_upstatus
                                          custName:(NSString *)cust_name
                                 completionHandler:(OCJHttpResponseHander)handler;

/**
 修改用户生日

 @param birthday 修改的生日日期
 @param handler 回调block
 */
+ (void)ocjPersonal_changeBirthdayWithDate:(NSString *)birthday
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 修改邮箱接口

 @param email 新邮箱
 @param handler 回调block
 */
+ (void)ocjPersonal_changeEmailWithNewEmail:(NSString *)email
                          completionHandler:(OCJHttpResponseHander)handler;

/**
 意见反馈接口

 @param feedback_type 意见类型
 @param feedback_detail 详情
 @param handler 回调block
 */
+ (void)ocjPersonal_suggestionFeedBackWithType:(NSInteger )feedback_type
                                        detail:(NSString *)feedback_detail
                             completionHandler:(OCJHttpResponseHander)handler;

/**
 会员信息查询接口

 @param handler 回调block
 */
+ (void)ocjPersonal_checkMenberInfoCompletionHandler:(OCJHttpResponseHander)handler;


/**
 修改手机号发送验证码接口

 @param mobile 修改的手机号
 @param handler 回调block
 */
+ (void)ocjPersonal_getChangeMobileSmsCodeWith:(NSString *)mobile
                             completionHandler:(OCJHttpResponseHander)handler;

@end
