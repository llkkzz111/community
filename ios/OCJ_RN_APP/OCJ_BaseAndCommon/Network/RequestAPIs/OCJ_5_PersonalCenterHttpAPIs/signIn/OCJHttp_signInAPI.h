//
//  OCJHttp_signInAPI.h
//  OCJ
//
//  Created by wb_yangyang on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"
#import "OCJRegisterDetailsModel.h"
#import "OCJLotteryModel.h"

/**
 签到中心接口中心
 */
@interface OCJHttp_signInAPI : NSObject

/**
 签到接口
 */
+(void)OCJRegister_getSigningRecordcheck_inCompletionHandler:(OCJHttpResponseHander)handler;

/**
 领取20天礼包 signInSize 不用传值..
 @warning signInSize 不用传值.
 */
+(void)sign20Gift_inSignInSize:(id)signInSize CompletionHandler:(OCJHttpResponseHander)handler;

/**
 领取15天礼包 sign_fct 不用传值.
 @param name 真实姓名.
 @param mobile 电话号码.
 @param cardId 身份证号码.
 @warning sign_fct 不用传值.
 */
+(void)sign15Gift_inSignFct:(id)sign_fct
                               userName:(NSString *)name
                                 mobile:(NSString *)mobile
                                 cardId:(NSString *)cardId
                      CompletionHandler:(OCJHttpResponseHander)handler;

/**
 签到详情接口
 */
+(void)OCJRegister_getRegisterDetailsSign_fctLoadingType:(OCJHttpLoadingType)loadType completionHandler:(OCJHttpResponseHander)handler;

/**
 获取彩票接口
 */
+(void)OCJRegister_getWelfareLotteryInfoCompletionHandler:(OCJHttpResponseHander)handler;

/**
 获取礼包接口
 */
+(void)OCJRegister_getWelfareGiftCompletionHandler:(OCJHttpResponseHander)handler;


@end
