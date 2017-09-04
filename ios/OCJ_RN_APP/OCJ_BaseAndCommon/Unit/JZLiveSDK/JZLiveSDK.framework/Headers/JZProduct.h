//
//  JZProduct.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/4/14.
//  Copyright © 2017年 jz. All rights reserved.
//  房间主播推广商品model

#import <Foundation/Foundation.h>

@interface JZProduct : NSObject

@property (nonatomic) NSInteger id;//产品id
@property (nonatomic) NSInteger number;//产品数量
@property (nonatomic) NSInteger price;//产品价格
//@property (nonatomic) NSInteger productName;//产品名称
@property (nonatomic) NSInteger sequence;//顺序号
@property (nonatomic) NSInteger userID;//用户ID

@property (nonatomic, strong) NSString *finValidPeriod;//金融产品 理财时间长度 以天计算
@property (nonatomic, strong) NSString *finChallenge;//金融风险：低风险、中等风险、高风险
@property (nonatomic, strong) NSString *finPercentage;//业绩基准
@property (nonatomic, strong) NSString *productName;//产品名称
@property (nonatomic, strong) NSString *activityID;//活动ID
@property (nonatomic, strong) NSString *detail;//详细信息
@property (nonatomic, strong) NSString *iconURL;//图片信息
@property (nonatomic, strong) NSString *productURL;//商品信息
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
