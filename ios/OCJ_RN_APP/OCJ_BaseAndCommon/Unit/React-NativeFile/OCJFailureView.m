//
//  OCJFailureView.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/7/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJFailureView.h"

@interface OCJFailureView()

@property (nonatomic,weak) id<OCJFailureViewDelegate> ocjDelegate;
@property (nonatomic) OCJFailureType ocjEnum_failuretype;

@end

@implementation OCJFailureView

-(instancetype)initWithFrame:(CGRect)frame imageType:(OCJFailureType)failureType delegate:(id<OCJFailureViewDelegate>)delegate{
  self = [super initWithFrame:frame];
  
  if (self) {
      self.backgroundColor = [UIColor colorWSHHFromHexString:@"#ededed"];
      [self ocj_setSubView];
      self.ocjDelegate = delegate;
      self.ocjEnum_failuretype = failureType;
  }
  
  return self;
}

- (void)ocj_setSubView{
  
  UIImageView* imageView = [[UIImageView alloc]init];
  imageView.image = [UIImage imageNamed:@"empty_networkError"];
  [self addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self);
    make.height.mas_equalTo(117);
    make.width.mas_equalTo(184);
  }];
  
  OCJBaseLabel* titleLabel = [[OCJBaseLabel alloc]init];
  titleLabel.text = @"您的网络好像很傲娇";
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:titleLabel];
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(imageView);
    make.top.mas_equalTo(imageView.mas_bottom).offset(20);
    make.height.mas_equalTo(25);
  }];
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"刷新试试" forState:UIControlStateNormal];
  [button setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:13];
  [button.layer setBorderColor:[UIColor colorWSHHFromHexString:@"#D4D4D4"].CGColor];
  [button.layer setCornerRadius:4];
  [button.layer setBorderWidth:1];
  [button addTarget:self action:@selector(ocj_clickButton) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:button];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(imageView);
    make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
    make.height.mas_equalTo(32);
    make.width.mas_equalTo(111);
  }];
  
}

-(void)ocj_clickButton{
  
  if ([self.ocjDelegate respondsToSelector:@selector(ocj_failureView:andClickRefreshButton:)]) {
    [self.ocjDelegate ocj_failureView:self andClickRefreshButton:nil];
  }
}

@end
