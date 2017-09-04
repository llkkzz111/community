//
//  OCJAcountLoginVC.h
//  OCJ
//
//  Created by OCJ on 2017/4/27.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef NS_ENUM(NSUInteger,OCJUserAccountLoginType){
    OCJUserAccountLoginTypePwd              =  0,        ///< 再次登录使用密码登录
    OCJUserAccountLoginTypeSSLCode          =  1,        ///< 再次登录使用动态验证码登录
};

@interface OCJAcountLoginVC : OCJBaseVC
@property (nonatomic,assign) OCJUserAccountLoginType   userType; ///< 用户类型


          
@end
