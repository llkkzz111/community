//
//  JZGiftRecords.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//  送礼用户的model(主播收到的礼物排行榜用到)

#import <Foundation/Foundation.h>

@interface JZGiftRecords : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger sendGiftValue;
@property (nonatomic, strong) NSString *pic1;//头像
@property (nonatomic, strong) NSString *nickname;//
@property (nonatomic, strong) NSString *sex;//
@property (nonatomic) NSInteger powerLevel;//
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
