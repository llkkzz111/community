//
//  OCJNoAddressTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJNoAddressTVCell.h"

@interface OCJNoAddressTVCell ()

@end

@implementation OCJNoAddressTVCell

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
  [ocjImgView setImage:[UIImage imageNamed:@"Icon_colorside_"]];
  [self addSubview:ocjImgView];
  [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.mas_equalTo(self);
    make.width.mas_equalTo(@4);
  }];
  //新增
  UIImageView *ocjImgView_arrow = [[UIImageView alloc] init];
  [ocjImgView_arrow setImage:[UIImage imageNamed:@"arrow"]];
  [self addSubview:ocjImgView_arrow];
  [ocjImgView_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-10);
    make.top.mas_equalTo(self.mas_top).offset(20);
    make.width.mas_equalTo(@12);
    make.height.mas_equalTo(@13);
  }];
  
  UILabel *ocjLab_edit = [[UILabel alloc] init];
  ocjLab_edit.text = @"新增";
  ocjLab_edit.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_edit.font = [UIFont systemFontOfSize:12];
  ocjLab_edit.textAlignment = NSTextAlignmentRight;
  [self addSubview:ocjLab_edit];
  [ocjLab_edit mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(ocjImgView_arrow.mas_left).offset(-5);
    make.centerY.mas_equalTo(ocjImgView_arrow);
    make.width.mas_equalTo(28);
  }];
  
  self.ocjLab_notlogin = [[UILabel alloc] init];
  self.ocjLab_notlogin.text = @"请添加收货人和下单人信息";
  self.ocjLab_notlogin.font = [UIFont systemFontOfSize:15];
  self.ocjLab_notlogin.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_notlogin.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_notlogin];
  [self.ocjLab_notlogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjImgView.mas_right).offset(15);
    make.top.mas_equalTo(self.mas_top).offset(15);
    make.right.mas_equalTo(self.mas_right).offset(-60);
  }];
  //未登录
  self.ocjView_notLogin = [[UIView alloc] init];
  self.ocjView_notLogin.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_notLogin];
  [self.ocjView_notLogin mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjImgView.mas_right).offset(15);
    make.top.mas_equalTo(self.mas_top).offset(42);
    make.height.mas_equalTo(17);
    make.right.mas_equalTo(self.mas_right).offset(-10);
  }];
  //
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = @"未登录状态下不能享受会员优惠，如需请";
  ocjLab_tip.font = [UIFont systemFontOfSize:12];
  ocjLab_tip.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_tip.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_notLogin addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_notLogin);
    make.centerY.mas_equalTo(self.ocjView_notLogin);
  }];
  //loginBtn
  UIButton *ocjBtn_login = [[UIButton alloc] init];
  [ocjBtn_login setTitle:@"登录" forState:UIControlStateNormal];
  [ocjBtn_login setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
  ocjBtn_login.titleLabel.font = [UIFont systemFontOfSize:12];
  [ocjBtn_login addTarget:self action:@selector(ocj_clickedLoginBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_notLogin addSubview:ocjBtn_login];
  [ocjBtn_login mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjLab_tip.mas_right).offset(0);
    make.centerY.mas_equalTo(ocjLab_tip);
    make.width.mas_equalTo(@25);
    make.height.mas_equalTo(@17);
  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = OCJ_COLOR_DARK_GRAY;
  [ocjBtn_login addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(ocjBtn_login);
    make.height.mas_equalTo(@0.5);
  }];
}

- (void)ocj_clickedLoginBtn {
  if (self.ocjOrderLoginBlock) {
    self.ocjOrderLoginBlock();
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
