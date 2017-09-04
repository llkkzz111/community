//
//  JZGiftProductStandard.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  大礼物model

#import <Foundation/Foundation.h>

@interface JZGiftProductStandard : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger price;//
@property (nonatomic) NSInteger purchasePrice;
@property (nonatomic,strong) NSString * unit;//
@property (nonatomic, strong) NSString *productName;//
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pic4;// 小图
@property (nonatomic, strong) NSString *pic1;// 大图
@property (nonatomic, strong) NSString *pic2;
@property (nonatomic, strong) NSString *pic3;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *type;//
@property (nonatomic, strong) NSString * giftNo;
@property (nonatomic) NSInteger  direction;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
