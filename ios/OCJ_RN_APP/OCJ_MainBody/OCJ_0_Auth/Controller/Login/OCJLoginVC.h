//
//  OCJLoginVC.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef NS_ENUM(NSInteger,OCJUserPurposeType) {
    OCJUserPurposeTypeLogin = 0, ///< 登录
    OCJUserPurposeTypeRelevance  ///< 关联
    
};

typedef NS_ENUM(NSUInteger,OCJLoginType){
    OCJLoginTypeDefault              =  0,     ///< 默认用户类型
    OCJLoginTypeEmail                =  1,     ///< 邮箱首次登录
    OCJLoginTypeMedia_pwd            =  2,     ///< 新媒体用户==使用密码登录
    OCJLoginTypeMedia_code           =  3,     ///< 新媒体用户==使用验证码登录
    OCJLoginTypeTv_mobile            =  4,     ///< 电视会员==手机号
    OCJLoginTypeTv_Telephone         =  5,     ///< 电视会员==固话
};


/**
 登录首页
 */
@interface OCJLoginVC : OCJBaseVC

@property (nonatomic) OCJUserPurposeType ocjEnum_purposeType; ///< 页面用途
@property (nonatomic,copy) NSString* ocjStr_thirdPartyInfo; ///< 第三方用户信息

@property (nonatomic,assign) OCJLoginType loginType; ///< 用户类型

@property (nonatomic,copy) NSString* ocjStr_account; ///< 预置用户名



@end
