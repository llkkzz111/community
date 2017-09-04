//
//  JZAppointmentUser.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/2/22.
//  Copyright © 2017年 jz. All rights reserved.
//  预约用户model

#import <Foundation/Foundation.h>

@interface JZAppointmentUser : NSObject
@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *iosDeviceToken;
@property (nonatomic, strong) NSString *pic1;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
