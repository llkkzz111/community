//
//  OCJStartView.h
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJStartView;
typedef void(^OCJStartViewGuideEndBlock) (OCJStartView* startView);

//存储获取是否是第一次启动的key
FOUNDATION_EXPORT NSString * const FirstLanchKey;

//上一次启动的版本信息
FOUNDATION_EXPORT NSString * const LastLanchVerKey;

@interface OCJStartView : UIView

/**
 创建一个起始页面 并添加到keywindow上.
 
 @return 起始页面.
 
 @warning 每次startView都会创建和添加一次.
 */
+ (instancetype)ocj_StartViewCompletionHandler:(OCJStartViewGuideEndBlock)handler;


@property (nonatomic,strong) OCJStartViewGuideEndBlock ocjBlock_guideEnd;

/**
 * 广告页.
 */
- (void)ocjSetAdvImageV:(NSString *)imageUrlStr andJumpUrl:(NSString *)ocjStr_jump;

/**
 检测版本号是否被更新.
 @warning 本地化版本号信息更新只会在程序生命一次周期内更新.
 */
extern BOOL ocj_shouldShowStartView();

@end
