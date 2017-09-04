//
//  OcjStoreDataAnalytics.h
//  AppAnalytics
//  数据分析封装入口，该类向外部提供，供外部程序调用
//  Created by apple on 2017/5/16.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    DataAnalyticsTalkingdata = 1, ///< TD埋点
    DataAnalyticsGrowingio = 2, ///< GIO埋点（暂不支持）
    DataAnalyticsOcj = 4,   ///< 东购自身的埋点
} DataAnalyticsSdk;

@interface OcjStoreDataAnalytics : NSObject

/*
 *  @method	init
 *  初始化数据分析接口，需在AppDelegate中application方法调用
 *  @param  sdkType     使用的分析平台类型，按位处理，可传入多个
 */
+(void) init:(DataAnalyticsSdk)sdkType;
/*
 *  @method	trackEvent
 *  记录自定义统计信息，单次调用的参数数量不能超过10个，key、value只支持NSString，在TalkingData中，label字段也传入eventId
 *  ********************重要：在RN中似乎不支持多态，所以封装RN接口时将两个参数的接口封装成了trackEvent2，将三个参数的接口封装成了trackEvent3
 *  @param  eventId
 *  @param  parameters
 */
+(void) trackEvent:(NSString *)eventId;
+(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel;
+(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters;
/**
 *  @method	trackPageBegin
 *  开始跟踪某一页面（可选），记录页面打开时间，建议在viewWillAppear或者viewDidAppear方法里调用
 *  @param  pageName    页面名称（自定义）
 */
+ (void)trackPageBegin:(NSString *)pageName;
/**
 *  @method trackPageEnd
 *  结束某一页面的跟踪（可选），记录页面的关闭时间
 此方法与trackPageBegin方法结对使用，
 建议在viewWillDisappear或者viewDidDisappear方法里调用
 *  @param  pageName    页面名称，请跟trackPageBegin方法的页面名称保持一致
 */
+ (void)trackPageEnd:(NSString *)pageName;
//GIO使用的方法
+ (BOOL)handleUrl:(NSURL*)url;

@end
