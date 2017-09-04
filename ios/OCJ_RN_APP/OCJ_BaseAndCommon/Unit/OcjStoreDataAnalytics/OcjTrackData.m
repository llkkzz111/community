//
//  OcjTrackData.m
//  OcjStoreDataAnalytics
//
//  Created by apple on 2017/5/18.
//  Copyright © 2017年 ocj. All rights reserved.
//

#import "OcjTrackData.h"

@implementation OcjTrackData
@synthesize type,synced,logTime,SyncTime;
@end

@implementation OcjTrackEventData
@synthesize eventId,label,parameters;
@end

@implementation OcjTrackPageData
@synthesize pageName,startTime,endTime;
@end
