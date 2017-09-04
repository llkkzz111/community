//
//  JZLiveRecord.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  活动model

#import <Foundation/Foundation.h>
@class JZCustomer;
@interface JZLiveRecord : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconURL;//头像
@property (nonatomic, strong) NSString *stream;//
@property (nonatomic, strong) NSString *app;//
@property (nonatomic, strong) NSString *videoURL;//
@property (nonatomic) NSInteger onlineNum;//
@property (nonatomic) NSInteger startTime;//
@property (nonatomic) NSInteger endTime;//
@property (nonatomic) NSInteger videoTime;//
@property (nonatomic, strong) NSString *tag;//
@property (nonatomic) NSInteger videoDirection;//
@property (nonatomic) NSInteger publish;//是否正在直播,0未直播,1直播中,2转码中

//新增部分字段
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *roomNo;
@property (nonatomic, strong) NSString *pushVideoUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) NSInteger planStartTime;
@property (nonatomic) NSInteger activityType;//0公开, 1付费, 2密码查看, 3私人
@property (nonatomic) NSInteger baibanEnable;
@property (nonatomic) NSInteger wenjuanEnable;
@property (nonatomic) NSInteger shopEnable;
@property (nonatomic) NSInteger payFee;
@property (nonatomic, strong) NSString *code;
@property (nonatomic) NSInteger createTime;
@property (nonatomic) NSInteger publishDone;//0未直播,1回放
//new
@property (nonatomic) NSInteger fansNum;
@property (nonatomic) NSInteger activityID;
@property (nonatomic) NSInteger appointmentNum;
@property (nonatomic) NSInteger appointmentID;
@property (nonatomic) NSInteger authorID;
@property (nonatomic) NSInteger isAppointment;
@property (nonatomic) NSInteger isFocus;
@property (nonatomic) NSInteger headTime;
@property (nonatomic) NSInteger firstStartTime;//最开始创建的时间
@property (nonatomic) NSInteger lastEndTime;//视频最后的结束时间
//部分host信息
@property (nonatomic) NSInteger userID;
@property (nonatomic, strong) NSString *pic1;
@property (nonatomic, strong) NSString *pic2;
@property (nonatomic, strong) NSString *hostTag;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *receiveGiftValue;
+ (JZLiveRecord *)getLiveRecorddataInstance;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
