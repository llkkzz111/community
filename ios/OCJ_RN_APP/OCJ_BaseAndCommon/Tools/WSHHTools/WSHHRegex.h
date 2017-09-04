//
//  WSHHRegex.h
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSHHRegex : NSObject
/**
 *  判断是否符合电话号码标准
 */
+(BOOL)wshh_isTelPhoneNumber:(NSString*)string;

/**
 *  判断字符串是否为汉字
 */
+(BOOL)wshh_isChineseWithString:(NSString*)string;

/**
 *  判断字符串是否为邮箱地址
 */
+ (BOOL)wshh_isEmail:(NSString *)string;

/**
 *  判断字符串是否为身份证
 */
+(BOOL)wshh_isIdCard:(NSString*)string;

/**
 判断字符串符合短信验证码规则
 */
+(BOOL)wshh_isSmsCode:(NSString*)string;


/**
 判断数字符合短信验证码规则
 */
+(BOOL)wshh_isNumString:(NSString*)string;

@end
