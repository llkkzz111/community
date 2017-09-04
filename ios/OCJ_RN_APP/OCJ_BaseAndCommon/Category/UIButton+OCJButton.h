//
//  UIButton+OCJButton.h
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJButtonHander) (UIButton * _Nullable image);

@interface UIButton (OCJButton)

/**
 设置UIButton网络图片

 @param urlStr 图片地址
 @param state  UIButton状态
 */
- (void)ocj_setButtonWithURLString:(NSString *_Nullable)urlStr forState:(UIControlState)state;

/**
 设置UIButton网络图片

 @param urlStr     图片地址
 @param state      UIButton状态
 @param placeholder 默认图片
 */
- (void)ocj_setButtonWithURLString:(NSString *_Nullable)urlStr forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder;

@end
