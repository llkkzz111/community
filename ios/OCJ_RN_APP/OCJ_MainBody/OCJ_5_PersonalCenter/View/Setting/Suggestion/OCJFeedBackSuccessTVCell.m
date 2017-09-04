//
//  OCJFeedBackSuccessTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJFeedBackSuccessTVCell.h"

@implementation OCJFeedBackSuccessTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_addViews];
  }
  return self;
}

- (void)ocj_addViews {
  UIImageView *ocjImgView = [[UIImageView alloc] init];
  [ocjImgView setImage:[UIImage imageNamed:@"img_success_popup_"]];
  [self addSubview:ocjImgView];
  [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self);
    make.width.height.mas_equalTo(@40);
    make.top.mas_equalTo(self.mas_top).offset(30);
  }];
  //提交成功
  UILabel *ocjLab_success = [[UILabel alloc] init];
  ocjLab_success.text = @"提交成功";
  ocjLab_success.font = [UIFont systemFontOfSize:17];
  ocjLab_success.textColor = OCJ_COLOR_DARK;
  ocjLab_success.textAlignment = NSTextAlignmentCenter;
  [self addSubview:ocjLab_success];
  [ocjLab_success mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self);
    make.top.mas_equalTo(ocjImgView.mas_bottom).offset(30);
  }];
  //感谢
  UILabel *ocjLab_tks = [[UILabel alloc] init];
  ocjLab_tks.text = @"感谢您的宝贵意见";
  ocjLab_tks.font = [UIFont systemFontOfSize:15];
  ocjLab_tks.textColor = OCJ_COLOR_DARK;
  ocjLab_tks.textAlignment = NSTextAlignmentCenter;
  [self addSubview:ocjLab_tks];
  [ocjLab_tks mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self);
    make.top.mas_equalTo(ocjLab_success.mas_bottom).offset(15);
  }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
