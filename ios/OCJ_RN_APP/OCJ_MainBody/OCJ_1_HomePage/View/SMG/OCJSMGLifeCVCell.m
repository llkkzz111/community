//
//  OCJSMGLifeCVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJSMGLifeCVCell.h"
#import "OCJResponseModel_SMG.h"

@interface OCJSMGLifeCVCell ()

@property (nonatomic, strong) UIImageView *ocjImgView_life;         ///<顶部图
@property (nonatomic,strong) UIView      * ocjView_bottom;          ///< 下文本
@property (nonatomic,strong) OCJBaseButton * ocjbtn_reward;           ///< 抽奖按钮
@property (nonatomic,strong) NSString    * ocjStr_unitCode;     ///< 抽奖编码

@property (nonatomic, strong) NSTimer *ocjTimer_reward;         ///<定时器
@property (nonatomic, strong) NSString *ocjStr_today;           ///<今天
@property (nonatomic, strong) NSString *ocjStr_startTime;       ///<活动开始时间
@property (nonatomic, strong) NSString *ocjStr_endTime;         ///<活动结束时间
@property (nonatomic, strong) NSString *ocjStr_currYear;        ///<

@end

@implementation OCJSMGLifeCVCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self ocj_addViews];
  }
  return self;
}

- (void)ocj_addViews {
  UIView * ocjView_bg = [[UIView alloc]init];
  self.backgroundColor = [UIColor clearColor];
  
  [self addSubview:ocjView_bg];
  [ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(245);
    make.height.mas_equalTo(315);
    make.center.mas_equalTo(self);
  }];
  
  self.ocjImgView_life  = [[UIImageView alloc]init];
  self.ocjImgView_life.userInteractionEnabled = YES;
  [ocjView_bg addSubview:self.ocjImgView_life];
  [self.ocjImgView_life mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjView_bg);
    make.right.mas_equalTo(ocjView_bg);
    make.top.mas_equalTo(ocjView_bg);
    make.height.mas_equalTo(215);
  }];
   
  //底部点击按钮
  self.ocjView_bottom  = [[UIView alloc]init];
  self.ocjView_bottom.backgroundColor = [UIColor whiteColor];
  [ocjView_bg addSubview:self.ocjView_bottom];
  [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjView_bg).offset(0);
    make.right.mas_equalTo(ocjView_bg).offset(0);
    make.top.mas_equalTo(self.ocjImgView_life.mas_bottom);
    make.bottom.mas_equalTo(ocjView_bg);
  }];
  
  self.ocjbtn_reward = [[OCJBaseButton alloc] initWithFrame:CGRectMake(15, 20, 215, 45)];
  [self.ocjbtn_reward ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
  [self.ocjbtn_reward addTarget:self action:@selector(ocj_clickRewardButton) forControlEvents:UIControlEventTouchUpInside];
  self.ocjbtn_reward.layer.masksToBounds = YES;
  self.ocjbtn_reward.layer.cornerRadius = 2;
  [self.ocjView_bottom addSubview:self.ocjbtn_reward];
  [self.ocjbtn_reward mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_bottom).offset(15);
    make.right.mas_equalTo(self.ocjView_bottom).offset(-15);
    make.bottom.mas_equalTo(self.ocjView_bottom).offset(-25);
    make.height.mas_equalTo(45);
  }];
}

- (void)setOcjModel_listModel:(OCJResponseModel_SMGListDetail *)ocjModel_listModel{

  
}

/**
 去掉字符串中非数字字符
 */
- (NSString *)ocj_changeStringWithString:(NSString *)oldStr{
  NSString *newStr = [[NSString alloc] init];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if (!(c >= 48 && c <= 57)) {
      newStr = [oldStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
      oldStr = newStr;
    }
    
  }
  return newStr;
}

- (void)ocj_clickRewardButton{
  NSString* unitRD = @"0.";
  NSInteger x = arc4random() % 100000000000;
  unitRD = [unitRD stringByAppendingString:[NSString stringWithFormat:@"%ld",x]];
  
  NSDictionary* dic = @{@"unitPwd":@"",@"unitNO":self.ocjModel_listModel.ocjStr_destinationUrl,@"unitRD":unitRD};
  if (self.ocj_rewardHandler) {
    
    self.ocj_rewardHandler(dic);
    
  }
}

@end
