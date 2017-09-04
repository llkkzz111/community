//
//  NSObject+WSHHExtension.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSObject+WSHHExtension.h"

@implementation NSObject (WSHHExtension)



-(BOOL)wshh_stringIsValid
{
  
  if (![self isKindOfClass:[NSString class]]) {
    return NO;
  }
  
  if ([[self description] isEqualToString:@"(null)"] || [[self description] isEqualToString:@"<null>"] || [self description].length==0) {
    return NO;
  }
  
  
  return YES;
}


@end
