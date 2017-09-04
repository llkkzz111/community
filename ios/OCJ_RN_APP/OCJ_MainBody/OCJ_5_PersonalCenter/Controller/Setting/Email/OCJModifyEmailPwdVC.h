//
//  OCJModifyEmailPwdVC.h
//  OCJ
//
//  Created by Ray on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void (^OCJModifyEmailBlock)(NSString *ocjStr_Email);

/**
 修改邮箱
 */
@interface OCJModifyEmailPwdVC : OCJBaseVC

@property (nonatomic, copy) OCJModifyEmailBlock ocjModifyEmailBlock;

/**
 昵称
 */
@property (nonatomic, strong) NSString *ocjStr_nickName;

@end
