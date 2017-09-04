//
//  OCJBaseButton+OCJExtension.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseButton.h"
#import "UIColor+WSHHExtension.h"

typedef NS_ENUM(NSUInteger,OCJGradientTypeDirection){
    OCJGradientTypeDirectionFromTopToBottom = 0,        //从上到下
    OCJGradientTypeDirectionFromLeftToRight,            //从左到右
    OCJGradientTypeDirectionFromUpLeftToDownRight,      //从左上到右下
    OCJGradientTypeDirectionFromUpRightToDownLeft,      //从右上到左下
};

@interface OCJBaseButton (OCJExtension)

@property (nonatomic) BOOL ocjBool_enable; ///< 控制按钮点击状态，默认值为NO（YES-可点击 NO-不可点击）

/**
 给Button设置渐变背景
 @param colors       渐变色值数组
 @param gradientType 渐变方向
 */
- (void)ocj_gradientColorWithColors:(NSArray *)colors ocj_gradientType:(OCJGradientTypeDirection )gradientType;

@end
