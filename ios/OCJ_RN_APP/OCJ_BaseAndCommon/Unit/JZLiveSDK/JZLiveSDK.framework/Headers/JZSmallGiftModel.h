//
//  JZSmallGiftModel.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  小礼物model

#import <Foundation/Foundation.h>
@class JZCustomer;
@interface JZSmallGiftModel : NSObject
//@property (nonatomic, strong) UIImageView *headImageV; // 头像
//@property (nonatomic, strong) UIImageView *giftImageV; // 礼物
@property (nonatomic, copy) NSString *name; // 送礼物者
@property (nonatomic, copy) NSString *giftName; // 礼物名称
@property (nonatomic, copy) NSString *grade;//等级
@property (nonatomic, assign) NSInteger giftCount; // 礼物个数
@property (nonatomic, assign) NSInteger giftState; // 状态
@property (nonatomic, strong) NSString *headUrl;//
@property (nonatomic, strong) NSString *giftUrl;//
//@property (nonatomic, strong) Customer *user;//等级
@end
