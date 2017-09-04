//
//  OCJSMGTipView.m
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSMGTipView.h"

@interface OCJSMGTipView ()
@property (nonatomic,strong) UIView  * ocjView_bg;            ///< 背景
@property (nonatomic,strong) UILabel * ocjLab_sec;            ///< 省略号
@property (nonatomic,strong) UILabel * ocjLab_third;          ///< 获奖数量
@property (nonatomic,strong) UILabel * ocjLab_time;           ///< 使用时间
@property (nonatomic,strong) UILabel * ocjLab_rewardDetail;   ///< 奖品详情
@property (nonatomic,strong) UILabel *ocjLab_tips;            ///< 中奖信息

@end

@implementation OCJSMGTipView

+ (void)ocj_popWithRules:(NSString *)rules Completion:(OCJPopViewHandler)handler{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    OCJSMGTipView * deskView = [[OCJSMGTipView alloc]init];
    deskView.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
    deskView.alpha = 0.9;
    [window addSubview:deskView];
    [deskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    
    UIButton * ocjBtn_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_close setImage:[UIImage imageNamed:@"smg_close"] forState:UIControlStateNormal];
    [ocjBtn_close addTarget:deskView action:@selector(ocj_close) forControlEvents:UIControlEventTouchUpInside];
    [deskView addSubview:ocjBtn_close];
    [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(deskView).offset(10);
        make.right.mas_equalTo(deskView).offset(-10);
    }];
    
    UILabel * ocjLab_rule = [[UILabel alloc]init];
    ocjLab_rule.text = @"活动规则";
    ocjLab_rule.font = [UIFont systemFontOfSize:15];
    ocjLab_rule.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [deskView addSubview:ocjLab_rule];
    [ocjLab_rule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(deskView).offset(65);
        make.left.mas_equalTo(deskView).offset(20);
    }];
    
    UILabel * ocjLab_des = [[UILabel alloc]init];
    ocjLab_des.numberOfLines = 0;
    ocjLab_des.text = rules;
    ocjLab_des.font = [UIFont systemFontOfSize:15];
    ocjLab_des.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [deskView addSubview:ocjLab_des];
    [ocjLab_des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ocjLab_rule.mas_bottom).offset(10);
        make.left.mas_equalTo(deskView).offset(20);
        make.right.mas_equalTo(deskView).offset(-20);
    }];
}
- (void)ocj_close{
    [self removeFromSuperview];
}

/**
 deskViewAnimation

 @return deskViewAnimation
 */
- (CAKeyframeAnimation *)deskViewAnimation{
    CAKeyframeAnimation *maskAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    maskAni.duration = 0.25;
    maskAni.beginTime = CACurrentMediaTime() + 0.5;
    CGRect startRect = CGRectMake(0, 0, 0, 0);
    CGRect finalRect = [UIScreen mainScreen].bounds;
    maskAni.values = @[[NSValue valueWithCGRect:startRect],[NSValue valueWithCGRect:finalRect]];
    maskAni.removedOnCompletion = NO;
    maskAni.fillMode = kCAFillModeForwards;
    return maskAni;
}

/**
 deskViewAnimation
 
 @return deskViewAnimation
 */
- (CAKeyframeAnimation *)maskAni{
    CAKeyframeAnimation *maskAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    maskAni.duration = 0.25;
    maskAni.beginTime = CACurrentMediaTime() + 0.5;
    CGRect startRect = CGRectMake(0, 0, 0, 0);
    CGRect finalRect = CGRectMake((SCREEN_WIDTH -  225)/2.0, (SCREEN_HEIGHT -  225)/2.0, 225, 295);
    maskAni.values = @[[NSValue valueWithCGRect:startRect],[NSValue valueWithCGRect:finalRect]];
    maskAni.removedOnCompletion = NO;
    maskAni.fillMode = kCAFillModeForwards;
    return maskAni;
}


/**
 底部动画
 @return  底部动画
 */
- (CAKeyframeAnimation *)animationBottom{
    CAKeyframeAnimation *maskAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    maskAni.duration = 0.25;
    maskAni.beginTime = CACurrentMediaTime() + 0.5;
    CGRect startRect = CGRectMake(0, 0, 0, 0);
    CGRect finalRect = CGRectMake((SCREEN_WIDTH -  245)/2.0, 500, 245, 146);
    maskAni.values = @[[NSValue valueWithCGRect:startRect],[NSValue valueWithCGRect:finalRect]];
    maskAni.removedOnCompletion = NO;
    maskAni.fillMode = kCAFillModeForwards;
    return maskAni;
}

/**
 查看奖品详情动画

 @return  查看奖品详情动画
 */
- (CAKeyframeAnimation *)animationReward{
    CAKeyframeAnimation *maskAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    maskAni.duration = 0.25;
    maskAni.beginTime = CACurrentMediaTime() + 0.5;
    CGRect startRect = CGRectMake(0, 0, 0, 0);
    CGRect finalRect = CGRectMake((SCREEN_WIDTH -  245)/2.0, 500, 245, 146);
    maskAni.values = @[[NSValue valueWithCGRect:startRect],[NSValue valueWithCGRect:finalRect]];
    maskAni.removedOnCompletion = NO;
    maskAni.fillMode = kCAFillModeForwards;
    return maskAni;
}

+ (void)ocj_popRewardWithMessage:(NSString *)message srartDate:(NSString *)startDate endDate:(NSString *)endDate Completion:(OCJPopViewHandler)handler {

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    OCJSMGTipView * deskView = [[OCJSMGTipView alloc]init];
    deskView.contentMode = UIViewContentModeCenter;
    deskView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    [window addSubview:deskView];
    [deskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    
    UIButton * ocjBtn_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_close setBackgroundImage:[UIImage imageNamed:@"smg_close"] forState:UIControlStateNormal];
    [ocjBtn_close addTarget:deskView action:@selector(ocj_close) forControlEvents:UIControlEventTouchUpInside];
    [deskView addSubview:ocjBtn_close];
    [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
        make.top.mas_equalTo(deskView).offset(20);
        make.right.mas_equalTo(deskView).offset(-20);
    }];
    
    UIImageView * ocjImg_smgBg = [[UIImageView alloc]init];
    [ocjImg_smgBg setImage:[UIImage imageNamed:@"smg_bottom"]];
    [deskView addSubview:ocjImg_smgBg];
    [ocjImg_smgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
        make.center.mas_equalTo(deskView);
    }];
    [ocjImg_smgBg.layer addAnimation:[deskView deskViewAnimation] forKey:@"zoomAnimation"];

    
    deskView.ocjView_bg            = [[UIView alloc]init];
    deskView.ocjView_bg.backgroundColor     = [UIColor clearColor];
    deskView.ocjView_bg.layer.masksToBounds = YES;
    deskView.ocjView_bg.layer.cornerRadius  = 4;
    [deskView addSubview:deskView.ocjView_bg];
    [deskView.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(245);
        make.height.mas_equalTo(295);
        make.center.mas_equalTo(deskView);
    }];
    [deskView.ocjView_bg.layer addAnimation:[deskView deskViewAnimation] forKey:@"zoomAnimation"];


    UIImageView * ocjImg_top = [[UIImageView alloc]init];
    ocjImg_top.backgroundColor = [UIColor whiteColor];
    ocjImg_top.layer.cornerRadius = 4;
    ocjImg_top.layer.masksToBounds = YES;
    [deskView addSubview:ocjImg_top];
    [ocjImg_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.center.mas_equalTo(deskView);
    }];
    [ocjImg_top.layer addAnimation:[deskView maskAni] forKey:@"zoomAnimation"];

    UIImageView * ocjView_bottom = [[UIImageView alloc]init];
    [ocjView_bottom setImage:[UIImage imageNamed:@"smg_wallet"]];
    [deskView addSubview:ocjView_bottom];
    [ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.centerX.mas_equalTo(deskView);
        make.centerY.mas_equalTo(deskView.mas_centerY).offset(100);
    }];
    [ocjView_bottom.layer addAnimation:[deskView animationBottom] forKey:@"zoomAnimation"];

    deskView.ocjLab_rewardDetail = [[UILabel alloc]init];
    deskView.ocjLab_rewardDetail.text = @"查看奖品详情请前往: 我的 > 抵用券";
    deskView.ocjLab_rewardDetail.alpha = 0;
    deskView.ocjLab_rewardDetail.font = [UIFont systemFontOfSize:12];
    deskView.ocjLab_rewardDetail.textAlignment = NSTextAlignmentCenter;
    deskView.ocjLab_rewardDetail.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    [deskView addSubview:deskView.ocjLab_rewardDetail];
    [deskView.ocjLab_rewardDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ocjView_bottom.mas_top).offset(-60);
        make.left.mas_equalTo(ocjImg_top);
        make.right.mas_equalTo(ocjImg_top);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        deskView.ocjLab_rewardDetail.alpha = 1;
    }];

    deskView.ocjLab_time = [[UILabel alloc]init];
    deskView.ocjLab_time.alpha = 0;
    deskView.ocjLab_time.font = [UIFont systemFontOfSize:12];
    deskView.ocjLab_time.textAlignment = NSTextAlignmentCenter;
    deskView.ocjLab_time.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    [deskView addSubview:deskView.ocjLab_time];
    [deskView.ocjLab_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(deskView.ocjLab_rewardDetail.mas_top).offset(-5);
      make.left.mas_equalTo(deskView.ocjView_bg.mas_left).offset(15);
      make.right.mas_equalTo(deskView.ocjView_bg.mas_right).offset(-15);
    }];
    if ([endDate length] > 0) {
        deskView.ocjLab_time.text = [NSString stringWithFormat:@"使用时间%@ - %@", startDate, endDate];
    }else {
        deskView.ocjLab_time.hidden = YES;
    }
  
    [UIView animateWithDuration:0.25 animations:^{
        deskView.ocjLab_time.alpha = 1;
    }];
  
    deskView.ocjLab_tips = [[UILabel alloc] init];
    deskView.ocjLab_tips.text = message;
    deskView.ocjLab_tips.textColor = [UIColor colorWSHHFromHexString:@"#E73E25"];
    deskView.ocjLab_tips.font = [UIFont systemFontOfSize:16];
    deskView.ocjLab_tips.textAlignment = NSTextAlignmentCenter;
    deskView.ocjLab_tips.numberOfLines = 1;
    deskView.ocjLab_tips.alpha = 0;
    [deskView addSubview:deskView.ocjLab_tips];
    [deskView.ocjLab_tips mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(42);
      make.left.mas_equalTo(deskView.ocjView_bg.mas_left).offset(15);
      make.right.mas_equalTo(deskView.ocjView_bg.mas_right).offset(-15);
      make.centerX.mas_equalTo(deskView.ocjView_bg);
      make.bottom.mas_equalTo(deskView.ocjLab_time.mas_top).offset(-25);
    }];
    deskView.ocjLab_tips.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
      deskView.ocjLab_tips.hidden = NO;
      deskView.ocjLab_tips.alpha = 1;
    }];
  
    deskView.ocjLab_sec = [[UILabel alloc]init];
    deskView.ocjLab_sec.text = @"····································";
    deskView.ocjLab_sec.font = [UIFont boldSystemFontOfSize:1];
    deskView.ocjLab_sec.alpha=0;
    deskView.ocjLab_sec.textAlignment = NSTextAlignmentCenter;
    deskView.ocjLab_sec.textColor = [UIColor colorWSHHFromHexString:@"FF6A10"];
    [deskView addSubview:deskView.ocjLab_sec];
    [deskView.ocjLab_sec  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(deskView.ocjLab_tips.mas_top).offset(-30);
        make.left.mas_equalTo(ocjImg_top).offset(32);
        make.right.mas_equalTo(ocjImg_top).offset(-32);
        make.height.mas_equalTo(22.5);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        deskView.ocjLab_sec.alpha = 1;
        deskView.ocjLab_sec.font = [UIFont boldSystemFontOfSize:16];
       
    }];

    
    UILabel * ocjLab_main = [[UILabel alloc]init];
    ocjLab_main.text = @"恭喜您，中奖啦";
    ocjLab_main.font = [UIFont boldSystemFontOfSize:12];
    ocjLab_main.textAlignment = NSTextAlignmentCenter;
    ocjLab_main.alpha = 0;
    ocjLab_main.textColor = [UIColor colorWSHHFromHexString:@"E73E25"];
    [deskView addSubview:ocjLab_main];
    [ocjLab_main  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(deskView.ocjLab_sec.mas_top);
        make.left.mas_equalTo(ocjImg_top);
        make.right.mas_equalTo(ocjImg_top);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        ocjLab_main.alpha = 1;
        ocjLab_main.font = [UIFont boldSystemFontOfSize:25];
    }];
}

- (NSAttributedString *)ocj_changeLabFontWithString:(NSString *)ocjStr {
  NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:ocjStr];
  for (int i = 0; i < ocjStr.length; i++) {
    unichar c = [ocjStr characterAtIndex:i];
    if ((c >= 48 && c <= 57)) {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(i, 1)];
    }
  }
  return newStr;
}

@end
