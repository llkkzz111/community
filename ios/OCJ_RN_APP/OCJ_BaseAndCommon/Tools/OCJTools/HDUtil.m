//
//  HDUtil.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HDUtil.h"

@implementation HDUtil

+ (NSString *)check:(NSString *)ocjStr {
  if (!([ocjStr length] > 0)) {
    ocjStr = @"";
  }
  return ocjStr;
}

+ (NSString *)returnAllStrWithStr:(NSString *)ocjStr {
  if (![ocjStr hasPrefix:@"http"]) {
    ocjStr = [NSString stringWithFormat:@"%@%@", @"https://m1.ocj.com.cn:443", ocjStr];
  }
  return ocjStr;
}

+ (NSString *)ocj_getShopNO:(NSString *)ocjStr {
  NSArray *ocjArr = [ocjStr componentsSeparatedByString:@"/"];
  NSString *ocjStr_shopNO = [ocjArr lastObject];
  NSString *ocjStr2;
  if ([ocjStr_shopNO containsString:@"?"]) {
    NSArray *ocjArr2 = [ocjStr_shopNO componentsSeparatedByString:@"?"];
    ocjStr2 = [ocjArr2 firstObject];
  }else {
    ocjStr2 = ocjStr_shopNO;
  }
  return ocjStr2;
}

@end
