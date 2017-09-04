//
//  JZFocusUser.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  关注用户model

#import <Foundation/Foundation.h> 
@interface JZFocusUser : NSObject
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger otherID;
@property (nonatomic) NSInteger powerLevel;
@property (nonatomic) NSInteger focus;
@property (nonatomic) NSInteger fansNum;
@property (nonatomic) NSInteger recordsNum;
@property (nonatomic, strong) NSString *pic1;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *signature;
//新增
@property (nonatomic) NSInteger publish;//是否正在直播,0未直播,1直播中,2转码
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
