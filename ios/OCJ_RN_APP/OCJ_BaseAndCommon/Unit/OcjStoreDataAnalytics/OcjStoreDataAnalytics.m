//
//  OcjStoreDataAnalytics.m
//  AppAnalytics
//
//  Created by apple on 2017/5/16.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "OcjStoreDataAnalytics.h"
#import "TalkingData.h"
//#import "growing.h"
#import "OcjStoreDataCenter.h"

///< TD AppKey
#define SDK_APP_KEY_Talkingdata @"C613ACBF3972802A2000152A7AAAAAAA" ///< 正式版
//#define SDK_APP_KEY_Talkingdata @"C1231B82E4C1513C2000152A6AAAAAAA" ///< 抢先版
//Growingio accountId，这个在正式版本中需要替换成真实的数据
//#define SDK_APP_KEY_Growingio @"86956356ac4a9cfd"

//ocj数据处理对象，初始化时创建
static OcjStoreDataAnalytics* mInstance;

@interface OcjStoreDataAnalytics()
//当前使用的sdk类型，可传入多个按位与操作的值
@property (nonatomic) NSInteger sdkType;
//ocj数据处理类
@property (nonatomic,retain) OcjStoreDataCenter* ocjStoreDataCenter;

@end

@implementation OcjStoreDataAnalytics

+(void) init:(DataAnalyticsSdk) sdkType{
    if (mInstance == nil){
        mInstance = [[OcjStoreDataAnalytics alloc] init];
        mInstance.sdkType = sdkType;
    }else{
        NSLog(@"OcjStoreDataAnalytics init have been called...");
        return;
    }
    if ((sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
        //todo：此处为td需使用channel，如果用户有渠道包，此处最好按照对应的渠道版本分别修改
        [TalkingData sessionStarted:SDK_APP_KEY_Talkingdata withChannelId:@"app store"];
        [TalkingData setLogEnabled:NO];
    }
    /*
    if ((sdkType & DataAnalyticsGrowingio) == DataAnalyticsGrowingio){
        [Growing startWithAccountId:SDK_APP_KEY_Growingio];
        [Growing setEnableLog:YES];
    }
     */
    if ((sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
        mInstance.ocjStoreDataCenter = [[OcjStoreDataCenter alloc] init];
        [mInstance.ocjStoreDataCenter startDataCenter];
    }
    
    NSLog(@"OcjStoreDataAnalytics init complete...");
}

+(void) trackEvent:(NSString *)eventId{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return;
    }
    if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
      [self ocj_trankEvent:eventId label:nil parameters:nil];
    }
    /*
    if ((mInstance.sdkType & DataAnalyticsGrowingio) == DataAnalyticsGrowingio){
        [Growing track:eventId properties:nil];
    }
     */
    if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
        [mInstance.ocjStoreDataCenter trackEvent:eventId];
    }
}

+(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return;
    }
  
    if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
      [self ocj_trankEvent:eventId label:eventLabel parameters:nil];
    }
  
    /*
    if ((mInstance.sdkType & DataAnalyticsGrowingio) == DataAnalyticsGrowingio){
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:eventLabel forKey:@"eventLabel"];
        [Growing track:eventId properties:dict];
    }
     */
  
    if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
        [mInstance.ocjStoreDataCenter trackEvent:eventId label:eventLabel];
    }
}

+(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return;
    }
  
  
    [self ocj_trankEvent:eventId label:eventLabel parameters:parameters];
  
}

+ (void)ocj_trankEvent:(NSString*)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters{
  NSMutableDictionary* mDic;
  if (!parameters || ![parameters isKindOfClass:[NSDictionary class]]) {
    mDic = [NSMutableDictionary dictionary];
    
  }else if([parameters isKindOfClass:[NSDictionary class]]){
    mDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
  }

  [mDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken] forKey:@"accessToken"];
  [mDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:OCJCustNo] forKey:@"custNo"];
  
  
  if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
      [TalkingData trackEvent:eventId label:eventLabel parameters:[mDic copy]];
  }

  if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
     [mInstance.ocjStoreDataCenter trackEvent:eventId label:eventLabel parameters:[mDic copy]];
  }
  
}

+ (void)trackPageBegin:(NSString *)pageName{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return;
    }
    if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
        [TalkingData trackPageBegin:pageName];
        [self ocj_trankEvent:pageName label:nil parameters:nil];
    }
    if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
        [mInstance.ocjStoreDataCenter trackPageBegin:pageName];
    }
}

+ (void)trackPageEnd:(NSString *)pageName{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return;
    }
    if ((mInstance.sdkType & DataAnalyticsTalkingdata) == DataAnalyticsTalkingdata){
        [TalkingData trackPageEnd:pageName];
    }
    if ((mInstance.sdkType & DataAnalyticsOcj) == DataAnalyticsOcj){
        [mInstance.ocjStoreDataCenter trackPageEnd:pageName];
    }
}

+ (BOOL)handleUrl:(NSURL*)url{
    if (mInstance == nil){
        NSLog(@"OcjStoreDataAnalytics init have not been called...");
        return NO;
    }
    /*
    if ((mInstance.sdkType & DataAnalyticsGrowingio) == DataAnalyticsGrowingio){
        return [Growing handleUrl:url];
    }
     */
    return NO;
}

@end
