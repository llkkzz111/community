//
//  OCJPaymentModeTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJPaymentModeTVCell.h"

@interface OCJPaymentModeTVCell ()

@property (nonatomic, strong) UIButton *ocjBtn_card;      ///<刷卡
@property (nonatomic, strong) UIImageView *ocjImgView_cash;

@property (nonatomic, strong) UIButton *ocjBtn_cash;      ///<现金
@property (nonatomic, strong) UIImageView *ocjImgView_card;

@end

@implementation OCJPaymentModeTVCell

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
  //部分拉伸图片
  UIImage *image = [UIImage imageNamed:@"icon_topbar_"];
  NSInteger leftCapWidth = image.size.width * 0.5;
  NSInteger topCapHeight = image.size.height * 0.5;
  UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
  
  UILabel *ocjLab_payment = [[UILabel alloc] init];
  ocjLab_payment.text = @"支付方式";
  ocjLab_payment.font = [UIFont systemFontOfSize:15];
  ocjLab_payment.textColor = OCJ_COLOR_DARK;
  ocjLab_payment.textAlignment = NSTextAlignmentLeft;
  [self addSubview:ocjLab_payment];
  [ocjLab_payment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.centerY.mas_equalTo(self);
  }];
  //现金
  self.ocjBtn_cash = [[UIButton alloc] init];
  [self.ocjBtn_cash setTitle:@"货到现金" forState:UIControlStateNormal];
  [self.ocjBtn_cash setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
  [self.ocjBtn_cash addTarget:self action:@selector(ocj_choosePaymentModeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
  self.ocjBtn_cash.titleLabel.font = [UIFont systemFontOfSize:13];
  [self.ocjBtn_cash setTitleColor:OCJ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
  self.ocjBtn_cash.layer.borderWidth = 0.5;
  self.ocjBtn_cash.layer.borderColor = OCJ_COLOR_LIGHT_GRAY.CGColor;
  self.ocjBtn_cash.layer.cornerRadius = 2;
  self.ocjBtn_cash.selected = NO;
  [self addSubview:self.ocjBtn_cash];
  [self.ocjBtn_cash mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.centerY.mas_equalTo(self);
    make.width.mas_equalTo(@80);
    make.height.mas_equalTo(25);
  }];
//  self.ocjImgView_cash = [[UIImageView alloc] init];
//  [self.ocjImgView_cash setImage:[UIImage imageNamed:@"icon_confirm"]];
//  [self.ocjBtn_cash addSubview:self.ocjImgView_cash];
//  [self.ocjImgView_cash mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.bottom.mas_equalTo(self.ocjBtn_cash.mas_bottom).offset(0);
//    make.right.mas_equalTo(self.ocjBtn_cash.mas_right).offset(0);
//    make.width.height.mas_equalTo(@17);
//  }];
//  self.ocjImgView_cash.hidden = YES;
  //刷卡
  self.ocjBtn_card = [[UIButton alloc] init];
  [self.ocjBtn_card setTitle:@"货到刷卡" forState:UIControlStateNormal];
  [self.ocjBtn_card setBackgroundImage:[UIImage imageNamed:@"Icon_label_"] forState:UIControlStateNormal];
  [self.ocjBtn_card addTarget:self action:@selector(ocj_choosePaymentModeWithBtn:) forControlEvents:UIControlEventTouchUpInside];
  self.ocjBtn_card.titleLabel.font = [UIFont systemFontOfSize:13];
  [self.ocjBtn_card setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
  self.ocjBtn_card.layer.cornerRadius = 2;
  self.ocjBtn_card.layer.borderWidth = 0.5;
  self.ocjBtn_card.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
  self.ocjBtn_card.selected = YES;
  [self addSubview:self.ocjBtn_card];
  [self.ocjBtn_card mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjBtn_cash.mas_left).offset(-10);
    make.centerY.mas_equalTo(self);
    make.width.mas_equalTo(@80);
    make.height.mas_equalTo(25);
  }];
//  self.ocjImgView_card = [[UIImageView alloc] init];
//  [self.ocjImgView_card setImage:[UIImage imageNamed:@"icon_confirm"]];
//  [self.ocjBtn_card addSubview:self.ocjImgView_card];
//  [self.ocjImgView_card mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.bottom.mas_equalTo(self.ocjBtn_card.mas_bottom).offset(0);
//    make.right.mas_equalTo(self.ocjBtn_card.mas_right).offset(0);
//    make.width.height.mas_equalTo(@17);
//  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.bottom.right.mas_equalTo(self);
    make.height.mas_equalTo(@0.5);
  }];
}

/**
 点击选择支付方式
 */
- (void)ocj_choosePaymentModeWithBtn:(UIButton *)ocjBtn_payment {
  if (ocjBtn_payment == self.ocjBtn_card) {
    self.ocjBtn_card.selected = YES;
    [self.ocjBtn_card setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
    self.ocjBtn_card.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
    [self.ocjBtn_card setBackgroundImage:[UIImage imageNamed:@"Icon_label_"] forState:UIControlStateNormal];
//    self.ocjImgView_card.hidden = NO;
    
    [self.ocjBtn_cash setTitleColor:OCJ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
    self.ocjBtn_cash.layer.borderColor = OCJ_COLOR_LIGHT_GRAY.CGColor;
    [self.ocjBtn_cash setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    self.ocjImgView_cash.hidden = YES;
  }else if (ocjBtn_payment == self.ocjBtn_cash) {
    self.ocjBtn_card.selected = NO;
    [self.ocjBtn_cash setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
    self.ocjBtn_cash.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
    [self.ocjBtn_cash setBackgroundImage:[UIImage imageNamed:@"Icon_label_"] forState:UIControlStateNormal];
//    self.ocjImgView_cash.hidden = NO;
    
    [self.ocjBtn_card setTitleColor:OCJ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
    self.ocjBtn_card.layer.borderColor = OCJ_COLOR_LIGHT_GRAY.CGColor;
    [self.ocjBtn_card setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    self.ocjImgView_card.hidden = YES;
  }
  
  if (self.ocjChoosePaymentModeBlock) {
    self.ocjChoosePaymentModeBlock(self.ocjBtn_card.selected ? @"2" : @"1");//2:货到刷卡 1:货到现金
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
