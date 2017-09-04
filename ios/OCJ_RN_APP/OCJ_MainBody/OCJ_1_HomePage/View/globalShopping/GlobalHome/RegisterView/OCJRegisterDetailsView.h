//
//  OCJRegisterDetailsView.h
//  OCJ
//
//  Created by 董克楠 on 13/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJRegisterDetailsModel.h"
#import "OCJRegisterSlider.h"

@class OCJRegisterDetailsView;
@protocol OCJRegisterDetailsViewDelegate <NSObject>

-(void)ocj_pushWith15DayLotteryVC;//领取15天彩票
-(void)ocj_pushWith20DayGiftVC;//领取20天礼包
-(void)ocj_pushWithActivityRuleVC;//活动规则跳转方法
-(void)ocj_popWithNextVC;//活动规则跳转方法

@end

@interface OCJRegisterDetailsView : UIView

@property(nonatomic ,strong)OCJRegisterInfoModel * model;

@property (nonatomic ,strong) UILabel * ocjLabel_ouDianLabel;//鸥点数
@property (nonatomic ,strong) UILabel * ocjLabel_regisineDayNumLabel;//签到天数label
@property (nonatomic ,strong) UIButton * ocjBtn_registerBtn;//签到按钮
@property (nonatomic ,strong) UIImageView * ocjImage_sliderBeginImg;//起始点图标
@property (nonatomic ,strong) UIImageView * ocjImage_sliderEndImg;//终点图标
@property (nonatomic, strong) UIImageView * ocjImgage_sliderFifteen;///<第15天图标
@property (nonatomic ,strong) UIButton * ocjBtn_sliderRangeBtn;//15天领取礼包图
@property (nonatomic ,strong) UIButton * ocjBtn_sliderGiftBtn;//20天领取礼包btn

@property (nonatomic ,strong) OCJRegisterSlider * ocjSlider_registerSlider;//点到天数动画进度条
@property (nonatomic ,strong) UILabel * ocjLabel_currentDayLabel;//滑动条中间可变天数label

@property (nonatomic ,assign) NSInteger registerDay;//记录签到天数 用于点击签到更新页面使用
@property (nonatomic ,weak) id<OCJRegisterDetailsViewDelegate>delegate;
@end
