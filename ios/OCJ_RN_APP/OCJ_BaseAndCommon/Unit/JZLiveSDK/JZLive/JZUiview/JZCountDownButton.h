//
//  JZCountDownButton.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/16.
//  Copyright © 2017年 jz. All rights reserved.
//  倒计时按钮

#import <UIKit/UIKit.h>

@interface JZCountDownButton : UIButton
/*
 *    倒计时按钮
 *    @param timeLine  倒计时总时间
 *    @param title     还没倒计时的title
 *    @param subTitle  倒计时的子名字 如：时、分
 *    @param mColor    还没倒计时的颜色
 *    @param color     倒计时的颜色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
@end
