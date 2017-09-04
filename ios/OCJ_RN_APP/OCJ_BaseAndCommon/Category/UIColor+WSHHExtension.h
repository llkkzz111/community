//
//  UIColor+WSHHExtension.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WSHHExtension)

/**
 16进制颜色转UIColor对象

 @param hexString 16进制颜色码
 @return 转换后的颜色对象
 */
+ (instancetype)colorWSHHFromHexString:(NSString *)hexString;

/**
 16进制颜色转UIColor对象 附带透明度.
 @param hexString 16进制颜色码.
 @return 转换后的颜色对象.
 */
+(instancetype)colorWSHHFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
