//
//  DataAnalyticsModule.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/5/22.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "DataAnalyticsModule.h"
#import "OcjStoreDataAnalytics.h"

@implementation DataAnalyticsModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(trackEvent:(NSString *)eventId)
{
  RCTLogInfo(@"trackEvent : %@", eventId);
  [OcjStoreDataAnalytics trackEvent:eventId];
}

RCT_EXPORT_METHOD(trackEvent2:(NSString *)eventId label:(NSString *)eventLabel)
{
  RCTLogInfo(@"trackEvent : %@,label : %@", eventId, eventLabel);
  [OcjStoreDataAnalytics trackEvent:eventId label:eventLabel];
}

RCT_EXPORT_METHOD(trackEvent3:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters)
{
  RCTLogInfo(@"trackEvent : %@ : %@ : parameters count %ld", eventId, eventLabel, parameters.count);
  [OcjStoreDataAnalytics trackEvent:eventId label:eventLabel parameters:parameters];
}

RCT_EXPORT_METHOD(trackPageBegin:(NSString *)pageName)
{
  RCTLogInfo(@"trackPageBegin : %@", pageName);
  [OcjStoreDataAnalytics trackPageBegin:pageName];
}

RCT_EXPORT_METHOD(trackPageEnd:(NSString *)pageName)
{
  RCTLogInfo(@"trackPageEnd : %@", pageName);
  [OcjStoreDataAnalytics trackPageEnd:pageName];
}

@end
