//
//  DanmuModel.h
//  东方购物new
//
//  Created by oms-youmecool on 2017/6/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//
/**
 弹幕基本信息数据模型
 */
#import <Foundation/Foundation.h>

@interface DanmuModel : NSObject

@property  (nonatomic,copy) NSString * event_no;
@property  (nonatomic,copy) NSString * barrage_video_url;
@property  (nonatomic,copy) NSString * share_pic;
@property  (nonatomic,copy) NSString * share_title;
@property  (nonatomic,copy) NSString * share_content;
@property  (nonatomic,copy) NSString * share_url;
@property  (nonatomic,copy) NSString * play_bef_pic;
@property  (nonatomic,copy) NSString * play_bef_dsc;
@property  (nonatomic,copy) NSString * play_cur_pic;
@property  (nonatomic,copy) NSString * play_cur_dsc;
@property  (nonatomic,copy) NSString * play_aft_pic;
@property  (nonatomic,copy) NSString * play_aft_dsc;
@property  (nonatomic,copy) NSString * live_begin_time;
@property  (nonatomic,copy) NSString * live_end_time;
@property  (nonatomic,copy) NSString * live_begin_left_time;
@property  (nonatomic,copy) NSString * live_end_left_time;

@property  (nonatomic,copy) NSString * first_event_time;
@property  (nonatomic,copy) NSString * bef_first_evt_word;
@property  (nonatomic,copy) NSString * first_evt_word;
@property  (nonatomic,copy) NSString * do_evt_word;
@property  (nonatomic,copy) NSString * next_evt_word;
@property  (nonatomic,copy) NSString * over_evt_word;

+ (DanmuModel *)parseWithDictionary:(NSDictionary*)dictionary;

@end
