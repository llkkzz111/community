//
//  OCJTouchIDPwdView.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJVerifyCodeBlock)(NSString *ocjStr_type, NSString *ocjStr_pwd);///<type 0：切换 1：登录 2：忘记密码

@interface OCJTouchIDPwdView : UIView

@property (nonatomic, strong) NSString *ocjStr_account;               ///<账号
@property (nonatomic, copy) OCJVerifyCodeBlock ocjVerifyCodeBlock;    ///<

@end
