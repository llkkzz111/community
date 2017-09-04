//
//  WSHHAlert.h
//  OCJ
//
//  Created by yangyang on 17/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 alert弹出框点击事件
 
 @param clickIndex 点击按钮序号
 */
typedef void(^WSHHBlockAlertAction) (NSInteger clickIndex);


/**
 alert控制器弹出后事件

 @param alertController alert控制器
 */
typedef void(^WSHHAlertControllerPresentCompletionAction) (UIAlertController* alertController);




/**
 弹框类工具集
 */
@interface WSHHAlert : NSObject

/**
 *  黑底白字提示框
 *
 *  @param title     提示信息
 *  @param hideDelay 关闭提示框延时
 */
+(void)wshh_showHudWithTitle:(NSString *)title
                andHideDelay:(int)hideDelay;


/**
 sheet提示框

 @param vc 当前VC
 @param title 标题
 @param message 提示信息
 @param actionTitles sheet选单标题
 @param alertAction （index=0）取消键 sheet选单（index=actionTitles下角标+1）
 */
+(void)wshh_showSheetByVC:(UIViewController*)vc
                withTitle:(NSString*)title
                  message:(NSString*)message
             actionTitles:(NSArray*)actionTitles
                   action:(WSHHBlockAlertAction)alertAction;

/**
 封装弹框视图

 *  @param vc                当前VC
 *  @param image             标题之上的图片
 *  @param title             标题
 *  @param message           提示信息
 *  @param sureButtonTitle   确定按钮的标题
 *  @param cancelButtonTitle 取消按钮的标题
 *  @param alertAction       点击时的回调（0-取消键 1-确认键）
 */
+(void)wshh_showAlertByVC:(UIViewController *)vc
          withCustomImage:(UIImage*)image
                    title:(NSString *)title
                  message:(NSString *)message
          sureButtonTitle:(NSString *)sureButtonTitle
        CancelButtonTitle:(NSString *)cancelButtonTitle
                   action:(WSHHBlockAlertAction)alertAction
      presentCompleletion:(WSHHAlertControllerPresentCompletionAction)completion;



@end
