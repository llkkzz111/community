//
//  HDUtil.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUtil : NSObject

+ (NSString *)check:(NSString *)ocjStr;

+ (NSString *)returnAllStrWithStr:(NSString *)ocjStr;

+ (NSString *)ocj_getShopNO:(NSString *)ocjStr;

@end
