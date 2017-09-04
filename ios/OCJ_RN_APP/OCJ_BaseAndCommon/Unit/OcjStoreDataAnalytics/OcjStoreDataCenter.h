//
//  OcjStoreDataCenter.h
//
//  ocj数据处理中心，处理ocj数据的缓存及上传
//  Created by apple on 2017/5/18.
//  Copyright © 2017年 ocj. All rights reserved.
//

#import <Foundation/Foundation.h>

//数据类型，分别对应着时间类型
typedef enum{
    OcjEventType_oneParam = 1,
    OcjEventType_twoParam = 2,
    OcjEventType_threeParam = 3,
    OcjEventType_page = 4,
} OcjEventType;


@interface OcjStoreDataCenter : NSObject

//以下各方法分别对应着OcjStoreDataAnalytics中的各个接口，在这些方法中对数据进行存储
-(void) startDataCenter;
-(void) trackEvent:(NSString *)eventId;
-(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel;
-(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters;
-(void) trackPageBegin:(NSString *)pageName;
-(void) trackPageEnd:(NSString *)pageName;

@end
