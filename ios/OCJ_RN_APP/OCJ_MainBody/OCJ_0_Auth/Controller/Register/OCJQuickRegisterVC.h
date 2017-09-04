//
//  OCJQuickRegisterVC.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"


/**
 快速注册页面
 */
@interface OCJQuickRegisterVC : OCJBaseVC

@property (nonatomic, strong) NSString *ocjStr_account; ///< 预置账户名

@property (nonatomic,copy) NSString* ocjStr_thirdPartyInfo; ///< 第三方用户信息

@end
