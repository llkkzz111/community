//
//  OCJLiveSuspendView.h
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视频类型枚举
 */
typedef NS_ENUM(NSInteger, OCJEnumVideoPlayType) {
    OCJVideoPlayTypeLiving = 0,     ///<正在直播
    OCJVideoPlayTypeReplay,         ///<精彩回放
    OCJVideoPlayTypeComing          ///<即将播出
};

@class OCJLiveSuspendView;
@protocol OCJLiveSuspendViewDelegate <NSObject>

- (void)ocj_play;

- (void)ocj_pauseOrPlay;

- (void)ocj_fullScreen;

- (void)ocj_sliderTapped:(CGFloat)value;

@end

/**
 直播时悬浮窗(显示直播信息)
 */
@interface OCJLiveSuspendView : UIView

@property (nonatomic, strong) OCJBaseLabel *ocjLab_watchNum;///<观看人数
@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;    ///<名字
@property (nonatomic, strong) OCJBaseLabel *ocjLab_date;    ///<日期
@property (nonatomic, strong) UIButton *ocjBtn_play;        ///<播放按钮
@property (nonatomic) BOOL ocjBool_isShow;                  ///<是否显示浮层
@property (nonatomic, strong) UIButton *ocjBtn_pause;       ///<暂停按钮
@property (nonatomic) BOOL ocjBool_isResponseTap;           ///<是否响应点击事件

@property (nonatomic, strong) UIView *ocjView_bottom3;      ///<底部观看人数、播出时间view
@property (nonatomic, strong) UIView *ocjView_bottom2;      ///<底部view(全屏)
@property (nonatomic, strong) UIView *ocjView_bottom;       ///<底部view(播放、暂停)
@property (nonatomic, strong) UILabel *ocjLab_currentTime;  ///<当前播放时间
@property (nonatomic, strong) UILabel *ocjLab_totalTime;    ///<视频总时长
@property (nonatomic, strong) UIProgressView *ocjProgress;  ///<缓冲进度条
@property (nonatomic, strong) UISlider *ocjSlider;          ///<滑竿
@property (nonatomic, strong) UIActivityIndicatorView *activity;///<菊花图

@property (nonatomic, strong) UILabel *ocjLab_horizon;      ///<快进、快退label

@property (nonatomic, weak) id<OCJLiveSuspendViewDelegate>delegate;

- (instancetype)initWithEnumType:(OCJEnumVideoPlayType)videoPlaryType;


/**
 重置浮层
 */
- (void)ocj_resetSuspendView;

/**
 隐藏浮层
 */
- (void)ocj_hideSuspendView;

/**
 显示浮层
 */
- (void)ocj_showSuspendView;

@end
