//
//  JZOrder.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  交易记录model

#import <Foundation/Foundation.h>

@interface JZOrder : NSObject
@property (nonatomic)         NSInteger id;
@property (nonatomic)         NSInteger userID;
@property (nonatomic, strong) NSString* nickname;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* activityTitle;
@property (nonatomic)         NSInteger activityID;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic)         NSInteger paidDate;
@property (nonatomic, strong) NSString *externalOrderID;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic)         NSInteger status;
@property (nonatomic)         NSInteger paidFee;
@property (nonatomic)         NSInteger orderTime;
@property (nonatomic)         NSInteger productType;

- (instancetype)initWithAttributes:(NSDictionary *)attributes ;
@end
