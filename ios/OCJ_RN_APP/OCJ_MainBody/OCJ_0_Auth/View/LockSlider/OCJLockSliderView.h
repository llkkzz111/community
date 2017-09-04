//
//  OCJLockSliderView.h
//  HBLockSliderViewDemo
//
//  Created by wb_yangyang on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJLockSliderView;
@protocol OCJLockSliderViewDelegate <NSObject>

@optional
/**
 滑动事件
 */
- (void)ocj_sliderValueChanging:(OCJLockSliderView *)slider;


/**
 滑动停止
 */
- (void)ocj_sliderEndValueChanged:(OCJLockSliderView *)slider;

@end

@interface OCJLockSliderView : UIView

@property (nonatomic,readonly) OCJBaseLabel* ocjLabel; ///< 提示文本展示框
@property (nonatomic,readonly) UIView* ocjView_touch; ///< 手指滑动试图对象
@property (nonatomic) CGFloat ocjFloat_value;   ///< 滑动块偏移值 （0.0-1.0）

@property (nonatomic,readonly) UIView* ocjView_foreground; ///< 滑动过的区域视图

@property (nonatomic,assign) BOOL thumbBack; ///< 拖动但未完成时是否返回（默认为yes）
@property (nonatomic, weak) id<OCJLockSliderViewDelegate> ocjDelegate; ///< 委托对象


/**
 *  设置滑动条进度
 *  @param value 滑动块偏移值（0.0-1.0）
 *  @param animation 是否加入动画
 */
- (void)ocj_setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void(^)(BOOL finish))completion;

/**
 *  设置滑动条颜色
 *
 *  @param backgroud  背景色
 *  @param foreground 前景色
 *  @param thumb      滑动控件颜色
 *  @param border     边框色
 *  @param textColor  文本颜色
 */
- (void)ocj_setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor;

/**
 *  设置滑动控件的起始图片和完成图片(可选)
 *
 *  @param beginImage 启始图片
 *  @param endImage   完成图片
 */
- (void)ocj_setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage;


@end
