//
//  OCJRetrieveEmailPwdVC.h
//  OCJ
//
//  Created by Ray on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef NS_ENUM(NSInteger, OCJSendEmailType) {
    OCJSendEmailTypeFindPwd = 0,        ///<找回密码
    OCJSendEmailTypeModifyMail          ///<修改邮箱
};

/**
 邮箱找回密码
 */
@interface OCJRetrieveEmailPwdVC : OCJBaseVC


/**
 用户名
 */
@property (nonatomic, strong) NSString *ocjStr_userName;


/**
 邮箱名
 */
@property (nonatomic, strong) NSString *ocjStr_email;

/**
 发送邮件枚举
 */
@property (nonatomic) OCJSendEmailType ocjSendEmailype;

@end
