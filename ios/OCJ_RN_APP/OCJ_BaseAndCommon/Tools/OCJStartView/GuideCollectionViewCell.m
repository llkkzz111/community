//
//  GuideCollectionViewCell.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "GuideCollectionViewCell.h"

@implementation GuideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    [self setupGuideView];
  }
  return self;
}

- (void)setupGuideView{
  self.btn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [self.contentView addSubview:self.btn];
  _btn.userInteractionEnabled = NO;
  _btn.adjustsImageWhenHighlighted = NO;
  _btn.adjustsImageWhenDisabled = NO;
  [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  self.appearbtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [self.contentView addSubview:self.appearbtn];
  _appearbtn.userInteractionEnabled = NO;
  _appearbtn.adjustsImageWhenHighlighted = NO;
  _appearbtn.adjustsImageWhenDisabled = NO;
  
  [_appearbtn setTitle:@"进入app" forState:UIControlStateNormal];
  [_appearbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.appearbtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.offset(-15);
    make.right.offset(-15);
  }];
}

@end
