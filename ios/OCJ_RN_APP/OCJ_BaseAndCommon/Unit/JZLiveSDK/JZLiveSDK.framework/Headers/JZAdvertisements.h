//
//  JZAdvertisements.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  轮播广告model

#import <Foundation/Foundation.h>

@interface JZAdvertisements : NSObject
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *pageURL;
@property (nonatomic, strong) NSString *externalURL;//增加的
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger urlStatus;//增加的,urlStatus为0时用pageURL，为1时用externalURL
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger activityID;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end

