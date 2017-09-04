//
//  OCJSelectCouponTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJSelectCouponTVCell.h"

@interface OCJSelectCouponTVCell ()

@property (nonatomic, strong) UIView *ocjView_bg;///<背景view

@property (nonatomic, strong) UIView *ocjView_meetCondition;///<是否满足条件
@property (nonatomic, strong) UILabel *ocjLab_condition;///<条件
@property (nonatomic, strong) UIImageView *ocjImgView_arrow;///<箭头

@property (nonatomic, strong) UIButton *ocjBtn_select;    ///<选择按钮

@property (nonatomic, strong) UIView *ocjView_left;     ///<
@property (nonatomic, strong) UIView *ocjView_discount;///折扣
@property (nonatomic, strong) UILabel *ocjLab_left;///<左半边显示折扣或'￥'
@property (nonatomic, strong) UILabel *ocjLab_right;///<右半边显示减免数额或'折'
@property (nonatomic, strong) UILabel *ocjLab_reducel;   ///<减免
@property (nonatomic, strong) UILabel *ocjLab_leftTitle; ///<

@property (nonatomic, strong) UIButton *ocjBtn_right;///右半边view
@property (nonatomic, strong) UILabel *ocjLab_title;///<适用店铺
@property (nonatomic, strong) UILabel *ocjLab_rules;///<适用规则
@property (nonatomic, strong) UILabel *ocjLab_validity;///<有效期

@property (nonatomic, strong) OCJResponceModel_coupon *ocjModel_selected;///<选中抵用券

@end

@implementation OCJSelectCouponTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_addBgView];
    [self ocj_addLeftBtn];
    [self ocj_addRightView];
  }
  return self;
}

/**
 底部视图
 */
- (void)ocj_addBgView {
  
  self.ocjBtn_select = [[UIButton alloc] init];
  [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  [self.ocjBtn_select addTarget:self action:@selector(ocj_selectCoupon:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.ocjBtn_select];
  [self.ocjBtn_select mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(10);
    make.top.bottom.mas_equalTo(self);
    make.width.mas_equalTo(@30);
  }];
  
  self.ocjView_bg = [[UIView alloc] init];
  self.ocjView_bg.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_bg];
  [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_select.mas_right).offset(0);
    make.top.mas_equalTo(self.mas_top).offset(15);
    
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.bottom.mas_equalTo(self.mas_bottom).offset(0);
  }];
}

/**
 左半边视图
 */
- (void)ocj_addLeftBtn {
  self.ocjView_left = [[UIView alloc] init];
  self.ocjView_left.backgroundColor = OCJ_COLOR_BACKGROUND;;
  
  UIImage *image = [UIImage imageNamed:@"Icon_couponleft_"];
  NSInteger leftCapWidth = image.size.width * 0.5;
  NSInteger topCapHeight = image.size.height * 0.5;
  UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
  UIImageView *ocjImgView = [[UIImageView alloc] init];
  [ocjImgView setImage:newImage];
  [self.ocjView_left addSubview:ocjImgView];
  [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(self.ocjView_left);
  }];
  
  [self.ocjView_bg addSubview:self.ocjView_left];
  [self.ocjView_left mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.mas_equalTo(self.ocjView_bg);
    make.width.mas_equalTo(@90);
  }];
  
  self.ocjView_discount = [[UIView alloc] init];
  [self.ocjView_left addSubview:self.ocjView_discount];
  [self.ocjView_discount mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjView_left.mas_top).offset(13);
    make.centerX.mas_equalTo(self.ocjView_left);
    make.width.mas_equalTo(@90);
    make.height.mas_equalTo(@40);
  }];
  [self ocj_addMinusView];
  
  self.ocjLab_leftTitle = [[UILabel alloc] init];
  self.ocjLab_leftTitle.text = @"满500元使用";
  self.ocjLab_leftTitle.font = [UIFont systemFontOfSize:13];
  self.ocjLab_leftTitle.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  self.ocjLab_leftTitle.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_left addSubview:self.ocjLab_leftTitle];
  [self.ocjLab_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.ocjView_left);
    make.top.mas_equalTo(self.ocjView_discount.mas_bottom).offset(5);
    make.left.right.mas_equalTo(self.ocjView_left);
  }];
}


/**
 右半边视图
 */
- (void)ocj_addRightView {
  self.ocjBtn_right = [[UIButton alloc] init];
  self.ocjBtn_right.adjustsImageWhenHighlighted = NO;
  //部分拉伸图片
  UIImage *image = [UIImage imageNamed:@"Icon_couponright_"];
  NSInteger leftCapWidth = image.size.width * 0.5;
  NSInteger topCapHeight = image.size.height * 0.5;
  UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
  [self.ocjBtn_right setBackgroundImage:newImage forState:UIControlStateNormal];
  
  [self.ocjView_bg addSubview:self.ocjBtn_right];
  [self.ocjBtn_right mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.right.mas_equalTo(self.ocjView_bg);
    make.left.mas_equalTo(self.ocjView_left.mas_right).offset(0);
  }];
  //名称
  self.ocjLab_title = [[UILabel alloc] init];
  self.ocjLab_title.text = @"甄选生活专营店店铺券";
  self.ocjLab_title.font = [UIFont systemFontOfSize:14];
  self.ocjLab_title.textColor = OCJ_COLOR_DARK;
  [self.ocjBtn_right addSubview:self.ocjLab_title];
  [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_right.mas_left).offset(15);
    make.top.mas_equalTo(self.ocjBtn_right.mas_top).offset(14);
    make.right.mas_equalTo(self.ocjBtn_right);
    make.height.mas_equalTo(@22);
  }];
  //使用规则
  self.ocjLab_rules = [[UILabel alloc] init];
  self.ocjLab_rules.text = @"店铺购物金额满￥500减￥20 团购商品除外";
  self.ocjLab_rules.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_rules.font = [UIFont systemFontOfSize:11];
  [self.ocjBtn_right addSubview:self.ocjLab_rules];
  [self.ocjLab_rules mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_title.mas_left);
    make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(11);
    make.right.mas_equalTo(self.ocjBtn_right);
    make.height.mas_equalTo(@12);
  }];
  //有效期
  self.ocjLab_validity = [[UILabel alloc] init];
  self.ocjLab_validity.text = @"有效期至2018年4月18日";
  self.ocjLab_validity.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_validity.font = [UIFont systemFontOfSize:11];
  [self.ocjBtn_right addSubview:self.ocjLab_validity];
  [self.ocjLab_validity mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_title.mas_left);
    make.top.mas_equalTo(self.ocjLab_rules.mas_bottom).offset(4);
    make.right.mas_equalTo(self.ocjBtn_right);
    make.height.mas_equalTo(@12);
  }];
}

/**
 减免
 */
- (void)ocj_addMinusView {
  self.ocjLab_left = [[UILabel alloc] init];
  self.ocjLab_left.text = @"￥";
  self.ocjLab_left.font = [UIFont systemFontOfSize:15];
  self.ocjLab_left.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  [self.ocjView_discount addSubview:self.ocjLab_left];
  [self.ocjLab_left mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_lessThanOrEqualTo(self.ocjView_discount.mas_left).offset(18);
    make.bottom.mas_equalTo(self.ocjView_discount.mas_bottom).offset(-3);
    make.height.mas_equalTo(@16);
    make.width.mas_equalTo(@16);
  }];
  
  self.ocjLab_right = [[UILabel alloc] init];
  self.ocjLab_right.text = @"20";
  self.ocjLab_right.font = [UIFont systemFontOfSize:28];
  self.ocjLab_right.textAlignment = NSTextAlignmentLeft;
  self.ocjLab_right.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  [self.ocjView_discount addSubview:self.ocjLab_right];
  [self.ocjLab_right mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.ocjView_discount);
    make.right.mas_lessThanOrEqualTo(self.ocjView_discount.mas_right).offset(-15);
    make.left.mas_equalTo(self.ocjLab_left.mas_right).offset(0);
    make.height.mas_equalTo(@29);
  }];
}

/**
 改变字符串中特定字符颜色
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr {
  NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if ((c >= 48 && c <= 57)) {
      [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
    }
    NSString *string = [NSString stringWithCharacters:&c length:1];
    if ([string isEqualToString:@"￥"]) {
      [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
    }
  }
  return newStr;
}

- (void)ocj_loadDataWithModel:(OCJResponceModel_coupon *)model andCouponNO:(NSString *)couponNo {
  self.ocjModel_selected = model;
  if (model.ocjStr_couponNo == couponNo) {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
  }else {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  }
  self.ocjLab_right.text = model.ocjStr_couponAmt;
  self.ocjLab_title.text = model.ocjStr_couponName;
  self.ocjLab_validity.text = [NSString stringWithFormat:@"有效期至%@", model.ocjStr_endDate];
  self.ocjLab_reducel.hidden = YES;
  self.ocjLab_rules.hidden = YES;
  self.ocjLab_leftTitle.hidden = YES;
}

- (void)ocj_selectCoupon:(UIButton *)ocjBtn {
  [ocjBtn setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
  if (self.ocjChooseCouponBlock) {
    self.ocjChooseCouponBlock(self.ocjModel_selected);
  }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
