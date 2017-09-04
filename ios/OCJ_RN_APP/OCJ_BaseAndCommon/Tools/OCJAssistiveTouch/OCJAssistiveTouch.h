//
//  OCJAssistiveTouch.h
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, OCJAssistiveTouchType){
    OCJAssistiveTouchTypeNone = 0,///< 父视图完全显示无遮挡取父视图的边界.
    OCJAssistiveTouchTypeTabbar = 1,///< 父视图部分显示 有tab栏遮挡.
    OCJAssistiveTouchTypeCustomOffset = 2///< 自定义上下左右遮挡间距.
};

@interface OCJAssistiveTouch : UIView

/// 点击签到按钮事件回调block 返回的是签到天数的类型 如果从接口有返回天数 直接把天数赋值给daysType.
@property (nonatomic, copy) void(^touchAction)(NSUInteger daysType);

/**
noDismissAnimation touch消失无动画属性 默认动画.
 */
@property (nonatomic, assign, getter=isNoDismissAnimation) BOOL noDismissAnimation;

/**
 noappearAnimation 签到按钮无动画属性 默认动画.
 */
@property (nonatomic, assign, getter=isNoAppearAnimation) BOOL noAppearAnimation;

/**
 签到的悬浮球 传入的frame会根据width的值自动计算height 所以传入的height值是不采用的 用以保证图片以原始尺寸缩放.
 @param frame 位置.
 @param view 父视图.
 @param styleType 父视图遮挡类型.
 @return 小球.
 @warning 传入的frame会根据width的值自动计算height 所以传入的height值是不采用的 用以保证图片以原始尺寸缩放.
 */
+ (instancetype)ocj_appearAssistiveTouchFrame:(CGRect)frame superView:(UIView *)view appearType:(OCJAssistiveTouchType)styleType;

/**
 签到的悬浮球 传入的frame会根据width的值自动计算height 所以传入的height值是不采用的 用以保证图片以原始尺寸缩放.
 @param frame 位置.
 @param view 父视图.
 @param aroundOffset 上下左右边距.
 @return 小球.
 @warning 传入的frame会根据width的值自动计算height 所以传入的height值是不采用的 用以保证图片以原始尺寸缩放.
 */
+ (instancetype)ocj_appearAssistiveTouchFrame:(CGRect)frame superView:(UIView *)view aroundOffset:(UIEdgeInsets)aroundOffset;

/**
 移除.
 */
- (void)dismissSelf;

/**
 取得定位信息 每次调用只会返回一次地址信息.
 */
+ (void)ocj_classGetLocation:(void(^)(NSDictionary *ad, NSDictionary *local))backAddressDoneBlock;

@end
