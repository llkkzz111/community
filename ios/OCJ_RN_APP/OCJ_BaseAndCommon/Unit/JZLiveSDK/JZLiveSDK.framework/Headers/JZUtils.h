//
//  JZUtils.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JZUtils : NSObject
//产生随机数
+ (NSString*)getRandomStringNum:(NSInteger)length;
//过滤图片(加保护)
+ (NSString *)filterHttpImage:(NSString *)imageString;

//检查网络及断网提示
+ (void)checkNetwork;
//检查是否无网络e
+ (BOOL)checkIsNoNetwork;
//提示框
//在window上显示
+ (void)showMessage:(NSString*)message;//1s
+ (void)showMessage:(NSString*)message time:(float)time;//自定义时间
//在view上显示
+ (void)showMessage:(NSString*)message inView:(UIView *)view;//1s
+ (void)showMessage:(NSString*)message time:(float)time inView:(UIView *)view;//自定义时间
//创建文件
+(NSString*)createDirectory:(NSString*)directory;
//保存用户信息到文件中
+ (void)saveUserInfo:(NSString *)savePath userInfo:(NSString *)userInfo fileName:(NSString *)fileName;
//获取文件中用户信息
+ (NSString*)getUserInfo:(NSString *)savePath fileName:(NSString *)fileName;

//提示框
+ (void)showSimpleAlert:(NSString*)titleStr content:(NSString*) content curView:(UIViewController*)curView ;
+ (void)showSimpleAlertAndBack:(NSString*)titleStr content:(NSString*) content curView:(UIViewController*)curView setRedirectBlock:(void (^)(BOOL addStatus, NSError *error))block;
//判断是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断是否为空值
+ (BOOL)isInvalid:(id)object;
//如果是空值转换为空字符串
+ (NSString*)convertNull:(id)object;
//验证用户名
+ (BOOL)checkUserName:(NSString *)userName;
//密码检查
#pragma 正则匹配用户密码6-16位数字和字母组合
+(BOOL)checkPassword:(NSString *) password;
//转换时间,返回星期几
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
