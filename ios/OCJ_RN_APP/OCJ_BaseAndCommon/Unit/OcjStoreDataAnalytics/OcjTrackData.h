//
//  OcjTrackData.h
//  OcjStoreDataAnalytics
//
//  Created by apple on 2017/5/18.
//  Copyright © 2017年 ocj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OcjJastor.h"

//基础数据类，如果新扩展埋点接口，数据对象可从该类继承
@interface OcjTrackData : OcjJastor{
    //数据类型，标识是哪种类型的数据：页面日志，一个参数的事件，两个参数的事件，三个参数的事件
    NSInteger type;
    //同步标记，用于数据库中标记记录的同步状态，0为未同步，1为正在同步
    NSInteger synced;
    //记录日志的时间
    NSDate* logTime;
    //保留，该字段没有使用
    NSDate* SyncTime;
}

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger synced;
@property(nonatomic,retain) NSDate* logTime;
@property(nonatomic,retain) NSDate* SyncTime;
@end

//事件数据类，记录一、二、三个参数的事件对象
@interface OcjTrackEventData : OcjTrackData{
    //事件id
    NSString* eventId;
    //label，用于两个和三个参数的事件
    NSString* label;
    //参数容器，用于三个参数的事件，最多可放10个参数
    NSDictionary* parameters;
}
@property(nonatomic,retain) NSString* eventId;
@property(nonatomic,retain) NSString* label;
@property(nonatomic,retain) NSDictionary* parameters;
@end

//页面数据类，记录页面日志
@interface OcjTrackPageData : OcjTrackData{
    //页面id，start和end传递的pageName需要相同
    NSString* pageName;
    //页面进入时间
    NSDate* startTime;
    //离开页面时间
    NSDate* endTime;
}
@property(nonatomic,retain) NSString* pageName;
@property(nonatomic,retain) NSDate* startTime;
@property(nonatomic,retain) NSDate* endTime;
@end
