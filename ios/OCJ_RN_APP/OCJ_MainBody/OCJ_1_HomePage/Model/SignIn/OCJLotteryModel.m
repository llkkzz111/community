//
//  OCJLotteryModel.m
//  OCJ
//
//  Created by 董克楠 on 14/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJLotteryModel.h"

@implementation OCJLotteryModel

@end

@implementation OCJLotteryListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
    if (value && ![value isKindOfClass:[NSNull class]]) {
      
          NSString *ocjStr_signString = [value description];
      NSData * ocjData = [ocjStr_signString dataUsingEncoding:NSUTF8StringEncoding];
      if ((!ocjData) || (![ocjData isKindOfClass:[NSData class]]) ) {
        return ;
      }
      NSArray * ocjArr = [NSJSONSerialization JSONObjectWithData:ocjData options:0 error:nil];
      if ((!ocjArr) || (![ocjArr isKindOfClass:[NSArray class]])) {
        return;
      }
      
      NSArray* array = (NSArray*)value;
      for (NSDictionary *dic in ocjArr) {
        OCJLotteryInfoModel *model = [[OCJLotteryInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.ocjArr_lotteryList addObject:model];
      }
    }
}

-(NSMutableArray *)ocjArr_lotteryList{
    if (_ocjArr_lotteryList == nil) {
        _ocjArr_lotteryList = [NSMutableArray array];
    }
    return _ocjArr_lotteryList;
}
@end

@implementation OCJLotteryInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"drawYN"]) {
            self.ocjStr_drawYN = [value description];
        }else if ([key isEqualToString:@"ball"]) {
            self.ocjStr_ball = [value description];
        }else if ([key isEqualToString:@"drawNo"]) {
            self.ocjStr_drawNo = [value description];
        }
    }
}

@end

@implementation OCJGiftListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"Ocust"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJGiftInfoModel *model = [[OCJGiftInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_GiftList addObject:model];
            }
        }
    }
}

-(NSMutableArray *)ocjArr_GiftList{
    if (_ocjArr_GiftList == nil) {
        _ocjArr_GiftList = [NSMutableArray array];
    }
    return _ocjArr_GiftList;
}
@end

@implementation OCJGiftInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"insert_dat"]) {
            self.ocjStr_insert_date = [value description];
        }else if ([key isEqualToString:@"coupon_no"]) {
            self.ocjStr_coupon_no = [value description];
        }else if ([key isEqualToString:@"coupon_note"]) {
            self.ocjStr_coupon_note = [value description];
        }else if ([key isEqualToString:@"use_yn"]) {
            self.ocjStr_user_YN = [value description];
        }
    }
}

@end
