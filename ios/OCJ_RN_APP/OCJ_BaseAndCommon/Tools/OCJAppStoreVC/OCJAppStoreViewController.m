//
//  OCJAppStoreViewController.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJAppStoreViewController.h"
#import <POP.h>
#import "OCJMySugFeedBackVC.h"
#import "OCJStartView.h"

NSString * const ThreeStartTimesKey = @"threeStartTimeskey";//app启动次数 对3取余
NSString * const OpenAppstoreKey = @"openAppstoreKey";//是否打开appstore 默认打开即评价
NSString * const IgnoreTimesKey = @"ignoreTimesKey";//再看看 忽略次数

@interface OCJAppStoreViewController (){
  OCJBaseButton *goodOpinion;
  OCJBaseButton *badOpinion;
  OCJBaseButton *continueOpinion;
}

@end

@implementation OCJAppStoreViewController

+ (void)startCheckAppStore{
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if ([OCJAppStoreViewController shouldShowAppstoreTip]) {
      [self showSelf];
    }
  });
}

+ (void)showSelf{
  UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  UIViewController *vc = nil;
  if (rootVC.presentedViewController) {
    vc = rootVC.presentedViewController;
  }
  
  if (vc) {
    [vc dismissViewControllerAnimated:NO completion:nil];
  }
  
  //模态弹出签到成功页面
  OCJAppStoreViewController *oCJAppStoreViewController = [[OCJAppStoreViewController alloc] init];
  oCJAppStoreViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  oCJAppStoreViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [rootVC presentViewController:oCJAppStoreViewController animated:NO completion:nil];
  
}

+ (BOOL)shouldShowAppstoreTip{
  
//#warning test
//  return YES;
  
  
  if (ocj_shouldShowStartView()) {//版本更新
    [self clearCaculaterTimes];
    return YES;
  }
  
  
  NSInteger startTimes = [[[NSUserDefaults standardUserDefaults] valueForKey:ThreeStartTimesKey] integerValue];
  startTimes+=1;//带上本次
  
  NSInteger ignoreTimes = [[[NSUserDefaults standardUserDefaults] valueForKey:IgnoreTimesKey] integerValue];
  
  
  BOOL hasOpenAppstore = [[[NSUserDefaults standardUserDefaults] valueForKey:OpenAppstoreKey] boolValue];
  
  
  [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld", (long)startTimes] forKey:ThreeStartTimesKey];//保存最新的启动次数
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  if (hasOpenAppstore) {
    return NO;
  }else{
    if (startTimes==3) {//带上本次是3次 并且之前没打开过appstore
      return YES;
    }else if (startTimes%8==0 && ignoreTimes<2){//每启动8次 并且 忽略次数小于2 弹出
      return YES;
    }else{
      return NO;
    }
  }
  return NO;
}

/**
 * @brief 清空计数.
 *
 * 清空计数器.
 */
+ (void)clearCaculaterTimes{
  
  [[NSUserDefaults standardUserDefaults] setValue:nil forKey:ThreeStartTimesKey];//保存最新的启动次数
  [[NSUserDefaults standardUserDefaults] setValue:nil forKey:OpenAppstoreKey];
  [[NSUserDefaults standardUserDefaults] setValue:nil forKey:IgnoreTimesKey];//保存最新的启动次数
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    self.view.backgroundColor = [UIColor clearColor];
  
    [self ocj_setupViews];
  
    [self ocj_presentAnimation];
}

- (void)ocj_setupViews{
  UIView *backView = [[UIView alloc] init];
  [self.view addSubview:backView];
  [backView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.offset(317*0.5);
    make.centerX.equalTo(self.view);
    make.width.equalTo(@(550*0.5));
    make.height.equalTo(@(670*0.5));
  }];
  backView.backgroundColor = [UIColor whiteColor];
  backView.layer.cornerRadius = 5.f;
  backView.layer.masksToBounds = YES;
  
  UIImageView *topImageView = [[UIImageView alloc] init];
  [backView addSubview:topImageView];
  [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.equalTo(backView);
    make.height.equalTo(@(270*0.5));
  }];
  topImageView.image = [UIImage imageNamed:@"appOpinionTopImage"];
  
  goodOpinion = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [goodOpinion setBackgroundColor:[UIColor colorWSHHFromHexString:@"F14967"]];
  goodOpinion.titleLabel.font = [UIFont systemFontOfSize:15];
  [goodOpinion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [goodOpinion setTitle:@"挺好用的，鼓励下" forState:UIControlStateNormal];
  [backView addSubview:goodOpinion];
  [goodOpinion mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(topImageView.mas_bottom).offset(30);
    make.centerX.equalTo(backView);
    make.width.equalTo(@(380*0.5));
    make.height.equalTo(@35);
  }];
  goodOpinion.layer.cornerRadius = 2.f;
  goodOpinion.layer.masksToBounds = YES;
  [goodOpinion addTarget:self action:@selector(ocj_dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
  
  badOpinion = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [badOpinion setTitleColor:[UIColor colorWSHHFromHexString:@"F14967"] forState:UIControlStateNormal];
  [badOpinion setTitle:@"不怎么好，提建议" forState:UIControlStateNormal];
  badOpinion.titleLabel.font = [UIFont systemFontOfSize:15];
  
  [backView addSubview:badOpinion];
  [badOpinion addTarget:self action:@selector(ocj_dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
  [badOpinion mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(goodOpinion.mas_bottom).offset(20);
    make.width.height.equalTo(goodOpinion);
    make.centerX.equalTo(goodOpinion);
  }];
  badOpinion.layer.borderColor = [UIColor colorWSHHFromHexString:@"F14967"].CGColor;
  badOpinion.layer.borderWidth = 1.0f;
  badOpinion.layer.cornerRadius = 2.f;
  badOpinion.layer.masksToBounds = YES;
  
  continueOpinion = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [continueOpinion setTitleColor:[UIColor colorWSHHFromHexString:@"F14967"] forState:UIControlStateNormal];
  [continueOpinion setTitle:@"再用用看" forState:UIControlStateNormal];
  [continueOpinion addTarget:self action:@selector(ocj_dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
  continueOpinion.titleLabel.font = [UIFont systemFontOfSize:15];
  
  
  continueOpinion.layer.borderColor = [UIColor colorWSHHFromHexString:@"F14967"].CGColor;
  continueOpinion.layer.borderWidth = 1.0f;
  continueOpinion.layer.cornerRadius = 2.f;
  continueOpinion.layer.masksToBounds = YES;
  
  [backView addSubview:continueOpinion];
  [continueOpinion mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(badOpinion.mas_bottom).offset(20);
    make.centerX.equalTo(goodOpinion);
    make.width.height.equalTo(goodOpinion);
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 模态动画
#pragma mark 模态弹出动画
- (void)ocj_presentAnimation{
  POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
  springAnimation.springSpeed = 10;
  springAnimation.springBounciness = 10;
  springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
  springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5)];
  [self.view pop_addAnimation:springAnimation forKey:@"spring"];
  [springAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
    if (finished) {
      POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
      animation.duration = 0.5;
      animation.toValue = [UIColor colorWSHHFromHexString:@"#000000" alpha:0.5019f];
      [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
    }
  }];
}

- (void)ocj_dismissSelf:(OCJBaseButton *)btn{
  if (btn == goodOpinion) {//去appstore
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:OpenAppstoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString * ocjStr_appStoreURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=524637490"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ocjStr_appStoreURLString]]){
      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ocjStr_appStoreURLString]];
    }else{
      [WSHHAlert wshh_showHudWithTitle:@"无法打开appStore评论页面" andHideDelay:2];
    }
  }else if (btn == badOpinion){//提建议
    
    [self dismissViewControllerAnimated:NO completion:^{
      OCJMySugFeedBackVC *oCJMySugFeedBackVC = [[OCJMySugFeedBackVC alloc] init];
      
      OCJBaseNC* rootNC = (OCJBaseNC*)[AppDelegate ocj_getShareAppDelegate].window.rootViewController;
      [rootNC pushViewController:oCJMySugFeedBackVC animated:YES];
      
    }];
    return;
  }else if (btn == continueOpinion){//再用用
    NSInteger ignoreTimes = [[[NSUserDefaults standardUserDefaults] valueForKey:IgnoreTimesKey] integerValue];
    ignoreTimes++;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld", (long)ignoreTimes] forKey:IgnoreTimesKey];//保存最新的启动次数
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  [self ocj_dismissAnimation];
}

#pragma mark 模态消失动画
- (void)ocj_dismissAnimation{
  
  if (self.view.pop_animationKeys.count>0) {
    return;
  }
  
  self.view.userInteractionEnabled = NO;
  POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
  animation.duration = 0.5;
  animation.toValue = [UIColor clearColor];
  [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
  
  [animation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
    if (finished) {
      POPBasicAnimation *disappearAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
      disappearAnimation.duration = 0.5;
      disappearAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
      [self.view pop_addAnimation:disappearAnimation forKey:@"disappearAni"];
      [disappearAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
        if (finished) {
          [self.view pop_removeAllAnimations];
          [self dismissViewControllerAnimated:NO completion:^{
            
          }];
        }
      }];
    }
  }];
  
}

@end
