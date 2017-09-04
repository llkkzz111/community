//
//  OCJFontAdapter.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 东购字体适配器
 */
@interface OCJFontAdapter : NSObject


/**
 适配字体

 @param font 待适配的字体
 @return 适配后的字体
 */
+ (UIFont*)ocj_adapteFont:(UIFont*)font;


/**
 获取app字体状态（1-小字体 2-大字体）

 @return 字体状态
 */
+ (NSInteger)ocj_getFontStatues;

@end
