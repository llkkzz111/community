//
//  OCJSecurityCheckVC.h
//  OCJ
//
//  Created by LZB on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

/**
 电视会员首次登录—固定电话-安全校验
 */
@interface OCJSecurityCheckVC : OCJBaseVC

@property (nonatomic, copy) NSString *ocjStr_memberID; ///< 会员ID

@property (nonatomic, copy) NSString* ocjStr_account; ///< 会员账号
@property (nonatomic, copy) NSString* ocjStr_custName;///< 会员姓名
@property (nonatomic, copy) NSString* ocjStr_mobile; ///< 会员手机号

@property (nonatomic, copy) NSString* ocjStr_thirdPartyInfo; ///< 第三方用户信息

@end
