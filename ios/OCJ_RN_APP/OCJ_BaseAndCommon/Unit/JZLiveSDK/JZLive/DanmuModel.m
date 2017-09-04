//
//  DanmuModel.m
//  东方购物new
//
//  Created by oms-youmecool on 2017/6/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "DanmuModel.h"

@implementation DanmuModel

+ (DanmuModel *)parseWithDictionary:(NSDictionary*)dictionary{
    DanmuModel * danmuModel = [[DanmuModel alloc] init];
  [danmuModel setValuesForKeysWithDictionary:dictionary];
  
    return danmuModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"event_no"]) {
      self.event_no = [value description];
    }else if ([key isEqualToString:@"barrage_video_url"]) {
      self.barrage_video_url = [value description];
    }else if ([key isEqualToString:@"share_pic"]) {
      self.share_pic = [value description];
    }else if ([key isEqualToString:@"share_title"]) {
      self.share_title = [value description];
    }else if ([key isEqualToString:@"share_content"]) {
      self.share_content = [value description];
    }else if ([key isEqualToString:@"share_url"]) {
      self.share_url = [value description];
    }else if ([key isEqualToString:@"play_bef_pic"]) {
      self.play_bef_pic = [value description];
    }else if ([key isEqualToString:@"play_bef_dsc"]) {
      self.play_bef_dsc = [value description];
    }else if ([key isEqualToString:@"play_cur_pic"]) {
      self.play_cur_pic = [value description];
    }else if ([key isEqualToString:@"play_cur_dsc"]) {
      self.play_cur_dsc = [value description];
    }else if ([key isEqualToString:@"play_aft_pic"]) {
      self.play_aft_pic = [value description];
    }else if ([key isEqualToString:@"play_aft_dsc"]) {
      self.play_aft_dsc = [value description];
    }else if ([key isEqualToString:@"live_begin_time"]) {
      self.live_begin_time = [value description];
    }else if ([key isEqualToString:@"live_end_time"]) {
      self.live_end_time = [value description];
    }else if ([key isEqualToString:@"live_begin_left_time"]) {
      self.live_begin_left_time = [value description];
    }else if ([key isEqualToString:@"live_end_left_time"]) {
      self.live_end_left_time = [value description];
    }else if ([key isEqualToString:@"first_event_time"]) {
      self.first_event_time = [value description];
    }else if ([key isEqualToString:@"bef_first_evt_word"]) {
      self.bef_first_evt_word = [value description];
    }else if ([key isEqualToString:@"first_evt_word"]) {
      self.first_evt_word = [value description];
    }else if ([key isEqualToString:@"do_evt_word"]) {
      self.do_evt_word = [value description];
    }else if ([key isEqualToString:@"next_evt_word"]) {
      self.next_evt_word = [value description];
    }else if ([key isEqualToString:@"over_evt_word"]) {
      self.over_evt_word = [value description];
    }
  }
}
@end
