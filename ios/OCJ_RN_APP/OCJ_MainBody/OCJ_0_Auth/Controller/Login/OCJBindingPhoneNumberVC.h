//
//  OCJBindingPhoneNumberVC.h
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

/**
 电话会员固话登录－绑定手机号界面
 */
@interface OCJBindingPhoneNumberVC : OCJBaseVC

@property (nonatomic, copy) NSString* ocjStr_custNo; ///< 用户编号
@property (nonatomic, copy) NSString* ocjStr_custName; ///< 用户姓名
@property (nonatomic,copy) NSString* ocjStr_internetID; //用户网络ID
@property (nonatomic, copy) NSString* ocjStr_mobile; ///< 会员手机号

@end
