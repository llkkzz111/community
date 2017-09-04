//
//  OCJReturnMoneyTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJReturnMoneyTVCell.h"

@interface OCJReturnMoneyTVCell ()

@property (nonatomic, strong) UIView *ocjView_prepay;   ///<预付款
@property (nonatomic, strong) UIButton *ocjBtn_prepay;

@property (nonatomic, strong) UIView *ocjView_cash;     ///<现金
@property (nonatomic, strong) UIButton *ocjBtn_cash;

@end

@implementation OCJReturnMoneyTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_addPrePayView];
    [self ocj_addCashView];
  }
  return self;
}

- (void)ocj_addPrePayView {
  self.ocjView_prepay = [[UIView alloc] init];
  self.ocjView_prepay.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_prepay];
  [self.ocjView_prepay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self);
    make.height.mas_equalTo(@60);
  }];
  //label
  UILabel *ocjLab_prepay = [[UILabel alloc] init];
  ocjLab_prepay.font = [UIFont systemFontOfSize:14];
  ocjLab_prepay.textColor = OCJ_COLOR_DARK;
  ocjLab_prepay.textAlignment = NSTextAlignmentLeft;
  ocjLab_prepay.text = @"转预付款";
  [self.ocjView_prepay addSubview:ocjLab_prepay];
  [ocjLab_prepay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_prepay.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_prepay);
  }];
  //btn
  self.ocjBtn_prepay = [[UIButton alloc] init];//icon_selected
  [self.ocjBtn_prepay setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
  [self.ocjBtn_prepay addTarget:self action:@selector(ocj_chooseReturnMoneyWay:) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_prepay addSubview:self.ocjBtn_prepay];
  [self.ocjBtn_prepay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_prepay.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_prepay);
    make.width.height.mas_equalTo(17);
  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self.ocjView_prepay addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_prepay.mas_left).offset(15);
    make.right.bottom.mas_equalTo(self.ocjView_prepay);
    make.height.mas_equalTo(@0.5);
  }];
}

- (void)ocj_addCashView {
  self.ocjView_cash = [[UIView alloc] init];
  self.ocjView_cash.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_cash];
  [self.ocjView_cash mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_prepay.mas_bottom).offset(0);
  }];
  //label
  UILabel *ocjLab_cash = [[UILabel alloc] init];
  ocjLab_cash.font = [UIFont systemFontOfSize:14];
  ocjLab_cash.textColor = OCJ_COLOR_DARK;
  ocjLab_cash.textAlignment = NSTextAlignmentLeft;
  ocjLab_cash.text = @"原方式支付返回";
  [self.ocjView_cash addSubview:ocjLab_cash];
  [ocjLab_cash mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_cash.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_cash);
  }];
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = @"现金加密退回";
  ocjLab_tip.font = [UIFont systemFontOfSize:11];
  ocjLab_tip.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_tip.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_cash addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_cash.mas_left).offset(15);
    make.top.mas_equalTo(ocjLab_cash.mas_bottom).offset(0);
  }];
  //btn
  self.ocjBtn_cash = [[UIButton alloc] init];//icon_selected
  [self.ocjBtn_cash setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
  [self.ocjBtn_cash addTarget:self action:@selector(ocj_chooseReturnMoneyWay:) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_cash addSubview:self.ocjBtn_cash];
  [self.ocjBtn_cash mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_cash.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_cash);
    make.width.height.mas_equalTo(17);
  }];
}

/**
 选择退款方式
 */
- (void)ocj_chooseReturnMoneyWay:(UIButton *)ocjBtn {
  ocjBtn.selected = !ocjBtn.selected;
  if (ocjBtn == self.ocjBtn_prepay) {
    if (ocjBtn.selected) {
      [ocjBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
      self.ocjBtn_cash.selected = NO;
      [self.ocjBtn_cash setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else {
      [ocjBtn setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
  }else if (ocjBtn == self.ocjBtn_cash) {
    if (ocjBtn.selected) {
      [ocjBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
      self.ocjBtn_prepay.selected = NO;
      [self.ocjBtn_prepay setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else {
      [ocjBtn setImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
  }
  if (self.ocjChooseReturnMomeyBlock) {
    if (self.ocjBtn_prepay.selected) {
      self.ocjChooseReturnMomeyBlock(@"2");
    }else if (self.ocjBtn_cash.selected) {
      self.ocjChooseReturnMomeyBlock(@"1");
    }else {
      self.ocjChooseReturnMomeyBlock(@"0");
    }
    
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
