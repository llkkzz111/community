//
//  OCJ_VipAreaHttpAPI.h
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJResponceModel_VipArea.h"
#import "OCJNetWorkCenter.h"

@interface OCJ_VipAreaHttpAPI : NSObject

/**
 VIP首页内容.
 */
+ (void)ocjVipArea_checkHomeHandler:(OCJHttpResponseHander)handler;


/**
 SMG抽奖接口

 @param unitNo 活动编号
 @param unitPassword 幸运密码
 @param rd 生活改造家随机数
 @param handler 回调
 */
+ (void)ocj_SMG_lottoWithUintNo:(NSString*)unitNo
                   unitPassword:(NSString*)unitPassword
                      lifeStyle:(NSString *)rd
              completionHandler:(OCJHttpResponseHander)handler;


/**
 获取SMG详情信息接口

 @param handler 回调
 */
+ (void)ocj_SMG_getDetailInfoCompletionHandler:(OCJHttpResponseHander)handler;

@end
