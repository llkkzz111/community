//
//  WSHHBannerView.h
//  WSHH-BannerScrollView
//
//  Created by LZB on 2017/4/10.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 点击图片回调block

 @param currIndex 当前点击的图片角标
 */
typedef void (^wshh_clickedImageAtIndex)(NSInteger currIndex);

@interface WSHHBannerView : UIView


@property (nonatomic, strong) NSArray *wshhArr_image; ///< 图片数组
@property (nonatomic, copy) wshh_clickedImageAtIndex wshhBlock_clickedImage; ///< 点击图片回调

/**
 初始化banner

 @param frame 设置frame
 @param duration 设置图片轮播间隔
 */
- (instancetype)initWSHHWithFrame:(CGRect)frame
                   andScrollDuration:(NSInteger)duration;

- (void)ocj_stopTimer;

@end
