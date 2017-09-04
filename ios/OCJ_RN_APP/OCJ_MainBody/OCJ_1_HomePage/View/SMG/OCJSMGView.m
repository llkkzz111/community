//
//  OCJSMGView.m
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSMGView.h"
#import "OCMSMGCVC.h"
#import "OCJSMGTipView.h"
#import "OCJSMGLayout.h"
#import "OCJSMGCollectionView.h"
#import "OCJ_VipAreaHttpAPI.h"
#import "OCJResponseModel_SMG.h"
#import "OCJSMGLifeCVCell.h"

@interface OCJSMGView()

@property (nonatomic, strong) OCJSMGCollectionView * collectionView;
@property (nonatomic, strong) UIView           * ocjView_rule;   ///< 活动规则视图
@property (nonatomic, strong) UIButton         * ocjbtn_bottom;  ///< 活动规则按钮
@property (nonatomic, strong) NSTimer          * ocjTimer; ///< 定时器
@property (nonatomic, strong) OCJResponseModel_SMG* ocjModel_smg; ///< smg数据
@property (nonatomic, strong) NSArray          * ocjArr_models; ///< smg数组

@end

@implementation OCJSMGView

+ (void)ocj_popCompletion:(OCJPopViewHandler)handler{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
  
    OCJSMGView * deskView = [[OCJSMGView alloc]initWithFrame:window.bounds];
    deskView.userInteractionEnabled = YES;
    deskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [window addSubview:deskView];
  
    [[NSNotificationCenter defaultCenter] addObserver:deskView selector:@selector(ocj_keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:deskView selector:@selector(ocj_keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    OCJSMGLayout    * flowLayout = [[OCJSMGLayout alloc] init];
    deskView.collectionView    = [[OCJSMGCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [deskView.collectionView registerClass:[OCMSMGCVC class] forCellWithReuseIdentifier:@"UICollectionViewCellIdentifier"];
    [deskView addSubview:deskView.collectionView];
    [deskView.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(deskView);
    }];
  
    [OCJ_VipAreaHttpAPI ocj_SMG_getDetailInfoCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      
      OCJResponseModel_SMG *model = (OCJResponseModel_SMG *)responseModel;
      [OcjStoreDataAnalytics trackPageBegin:[NSString stringWithFormat:@"%@%@",model.ocjStr_codeValue,model.ocjStr_pageVersionName]];
      
      deskView.ocjModel_smg = model;
      deskView.ocjArr_models = model.ocjArr_smgList;
      deskView.collectionView.ocjArr_dataSource = [model.ocjArr_smgList copy];
      [deskView ocj_timerCount];//计算活动是否开始
      [deskView.collectionView reloadData];
    }];
  
    UIButton * ocjBtn_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_close setImage:[UIImage imageNamed:@"smg_close"] forState:UIControlStateNormal];
    [ocjBtn_close addTarget:deskView action:@selector(ocj_clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [deskView addSubview:ocjBtn_close];
    [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(deskView).offset(10);
        make.right.mas_equalTo(deskView).offset(-10);
    }];
  
    deskView.ocjbtn_bottom = [UIButton buttonWithType:UIButtonTypeCustom];
    [deskView.ocjbtn_bottom setImage:[UIImage imageNamed:@"smg_activity"] forState:UIControlStateNormal];
    [deskView.ocjbtn_bottom addTarget:deskView action:@selector(ocj_clickRuleButton) forControlEvents:UIControlEventTouchUpInside];
    [deskView addSubview:deskView.ocjbtn_bottom];
    [deskView.ocjbtn_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(deskView);
        make.bottom.mas_equalTo(deskView).offset(-20);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(30);
    }];
  
    [OCJ_NOTICE_CENTER addObserver:deskView selector:@selector(ocj_clickCloseButton) name:OCJNotice_NeedLogin object:nil];//接收到登录通知时先关闭本视图
  
//  [deskView ocj_startTimer];
}

/**
 启动定时器
 */
- (void)ocj_startTimer {
  self.ocjTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(ocj_timerCount) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:self.ocjTimer forMode:NSRunLoopCommonModes];
}

- (void)ocj_timerCount{
  
  for (OCJResponseModel_SMGListDetail* model in self.ocjArr_models) {
    [self ocj_checkActivityTimeWithModel:model];
  }
  
//  [self.collectionView reloadData];
}

- (void)ocj_checkActivityTimeWithModel:(OCJResponseModel_SMGListDetail*)model{
  
  if (![model isKindOfClass:[OCJResponseModel_SMGListDetail class]]) {
    return;
  }
  
  NSArray* inTimeDays = [model.ocjStr_title componentsSeparatedByString:@","];
  NSArray* inTimeHours = [model.ocjStr_subTitle componentsSeparatedByString:@","];
  
  if ([self ocj_checkSMGTimeIsInToday:inTimeDays inTime:inTimeHours]) {//时间段、星期皆吻合
    
    model.ocjBool_isIntime = YES;
  }
  
}


/**
 检验smg活动的日期是否在今天

 @param smgTimeDays 检验smg活动的日期
 @return YES-今天有活动 NO-今天无活动
 */
- (BOOL)ocj_checkSMGTimeIsInToday:(NSArray*)smgTimeDays inTime:(NSArray*)smgTimeHours{
  if (smgTimeDays.count==0 || smgTimeHours.count==0) {
    return NO;
  }
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  NSDate *now = [NSDate date];
  comps = [calendar components:unitFlags fromDate:now];
  NSInteger weekIndex = [comps weekday]-1;
  if (weekIndex == 0) {
    weekIndex = 7;
  }
  
  for (NSInteger i=0; i<smgTimeDays.count; i++) {
    NSString* day = smgTimeDays[i];
    NSString* hour = smgTimeHours.count>i+1?smgTimeHours[i]:smgTimeHours[smgTimeHours.count-1];
    if ([day isEqualToString:[NSString stringWithFormat:@"%zi",weekIndex]] && [self ocj_checkSMGTimeIsIntime:hour]) {
      return YES;
    }
  }
  
  return NO;
}


/**
 检验当前时间是否在活动时间段内
 */
-(BOOL)ocj_checkSMGTimeIsIntime:(NSString*)smgTime{
  if (![smgTime wshh_stringIsValid] && ![smgTime containsString:@"-"]) {
      return NO;
  }
  
  NSArray* inTimeArr = [smgTime componentsSeparatedByString:@"-"];
  
  if (inTimeArr.count!=2) {
    return NO;
  }
  
  NSInteger minTime = [[inTimeArr[0] stringByReplacingOccurrencesOfString:@":" withString:@""]integerValue];
  NSInteger maxTime = [[inTimeArr[1] stringByReplacingOccurrencesOfString:@":" withString:@""]integerValue];
  
  NSDate* date = [NSDate date];
  NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"HH:mm"];
  NSString* dateStr = [formatter stringFromDate:date];
  NSInteger nowDate = [[dateStr stringByReplacingOccurrencesOfString:@":" withString:@""]integerValue];
  
  if (nowDate>minTime && nowDate <maxTime) {
    return YES;
  }
  
  return NO;
}

/**
 停止定时器
 */
- (void)ocj_stopTimer {
  if (self.ocjTimer) {
    [self.ocjTimer invalidate];
    self.ocjTimer = nil;
  }
}


/**
 关闭SMG按钮点击事件
 */
- (void)ocj_clickCloseButton{
  [OcjStoreDataAnalytics trackPageBegin:[NSString stringWithFormat:@"%@%@",self.ocjModel_smg.ocjStr_codeValue,self.ocjModel_smg.ocjStr_pageVersionName]];
  
  //关闭timer
  [self ocj_stopTimer];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self removeFromSuperview];
}

- (void)ocj_keyboardShow:(NSNotification *)noti {
  NSValue *val = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect rect = [val CGRectValue];
  rect.size.height -= 50;
  
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self);
    make.bottom.mas_equalTo(self.mas_bottom).offset(-rect.size.height);
  }];
  
}

- (void)ocj_keyboardHide:(NSNotification *)noti {
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(self);
  }];
}


/**
 点击活动规则按钮
 */
- (void)ocj_clickRuleButton{
  OCJResponseModel_SMGListDetail* model = self.ocjArr_models[self.collectionView.ocjInt_currentPage];
  NSString* ruleStr = model.ocjStr_rules;
  [OCJSMGTipView ocj_popWithRules:ruleStr Completion:^(NSDictionary *dic_address) {
    
  }];
}



@end
