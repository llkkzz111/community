//
//  OCJProgressHUD.h
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "WSHHAlert.h"

typedef NS_ENUM(NSInteger,OCJAlertType) {
    OCJAlertTypeSuccessSendEmail = 1, ///< 发送邮件成功时的提示 （图片为打勾）
    OCJAlertTypeSuccessBindTelephone, ///< 登录成功绑定手机时的提示 （图片为手机）
    OCJAlertTypeFailure, ///< 操作失败时的提示 （图片为小鸟）
    OCJAlertTypeNone    ///< 不带图片
};


/**
 OCJ定制loading
 */
@interface OCJProgressHUD : MBProgressHUD


/**
 文本提示框

 @param title 文本
 @param hideDelay 自动隐藏的时间，设置为1以下时不自动隐藏
 */
+ (void)ocj_showHudWithTitle:(NSString *)title andHideDelay:(int)hideDelay;

/**
 *  显示ocj定制loading
 
 *  @param view      loading附着的父视图
 *  @param hideDelay 自动关闭loading的时间 （==0时不自动关闭）
 *  @return hud对象
 */
+(OCJProgressHUD*)ocj_showHudWithView:(UIView*)view andHideDelay:(NSInteger)hideDelay;


/**
 *  关闭loading
 */
-(void)ocj_hideHud;


/**
 东购定制弹框视图
 
 *  @param vc                当前VC
 *  @param alertType         弹框类型
 *  @param title             标题
 *  @param message           提示信息
 *  @param sureButtonTitle   确定按钮的标题
 *  @param cancelButtonTitle 取消按钮的标题
 *  @param alertAction       点击时的回调（0-取消键 1-确认键）
 */
+(void)ocj_showAlertByVC:(UIViewController *)vc withAlertType:(OCJAlertType)alertType title:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureButtonTitle CancelButtonTitle:(NSString *)cancelButtonTitle action:(WSHHBlockAlertAction)alertAction;

@end
