//
//  JZVideoType.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  直播活动类型model

#import <Foundation/Foundation.h>

@interface JZVideoType : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *videoType;
@property (nonatomic) NSInteger status;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
