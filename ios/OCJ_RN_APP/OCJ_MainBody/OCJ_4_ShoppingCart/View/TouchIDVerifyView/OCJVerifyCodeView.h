//
//  OCJVerifyCodeView.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击切换密码登录
 */
typedef void (^OCJPwdLoginBlock)(NSString *ocjStr_type, NSString *ocjStr_code);  ///<type 0：切换 1：登录

/**
 验证码校验view
 */
@interface OCJVerifyCodeView : UIView

@property (nonatomic, strong) NSString *ocjStr_account; ///<账号
@property (nonatomic, copy) OCJPwdLoginBlock ocjPwdLoginBlock;

@end
