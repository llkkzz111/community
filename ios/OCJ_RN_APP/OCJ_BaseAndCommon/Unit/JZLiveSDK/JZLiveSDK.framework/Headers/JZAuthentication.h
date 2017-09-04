//
//  JZAuthentication.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/4/13.
//  Copyright © 2017年 jz. All rights reserved.
//  个人认证信息model

#import <Foundation/Foundation.h>

@interface JZAuthentication : NSObject
@property (nonatomic) NSInteger authType;//0 未认证；1 为个人；2 为企业
@property (nonatomic) NSInteger authStatus;//0公开, 1付费, 2密码查看, 3私人
@property (nonatomic, strong) NSString *mobile;//0 审核中 1拒绝 2通过（authType>0时此字段生效）
@property (nonatomic, strong) NSString *realName;//证件名
@property (nonatomic, strong) NSString *cardNo;//证件号
@property (nonatomic, strong) NSString *cardURL;//证件照路径,如果第一次认证为空,第二次将上次的url获取
@property (nonatomic, strong) NSString *introduction;//介绍
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
