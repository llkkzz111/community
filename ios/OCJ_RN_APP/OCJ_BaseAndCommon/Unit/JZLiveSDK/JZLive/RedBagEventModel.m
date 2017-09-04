//
//  RedBagEventModel.m
//  东方购物new
//
//  Created by oms-youmecool on 2017/6/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "RedBagEventModel.h"
#import <objc/runtime.h>

@implementation RedBagEventModel

+(RedBagEventModel *)parseWithDictionary:(NSDictionary*)dictionary
{
    RedBagEventModel * model = [[RedBagEventModel alloc] init];
  [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"code"]) {
      self.code = [value description];
    }else if ([key isEqualToString:@"end_batch_flag"]) {
      self.end_batch_flag = [value description];
    }else if ([key isEqualToString:@"batch_no"]) {
      self.batch_no = [value description];
    }else if ([key isEqualToString:@"second"]) {
      self.second = [value description];
    }
  }
}

@end
