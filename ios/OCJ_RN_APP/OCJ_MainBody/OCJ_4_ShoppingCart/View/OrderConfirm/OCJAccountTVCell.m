//
//  OCJAccountTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJAccountTVCell.h"

@interface OCJAccountTVCell ()

@property (nonatomic, strong) UIView *ocjView_totalPrice;     ///<商品总额

@property (nonatomic, strong) UIView *ocjView_reduce;         ///<优惠价格

@property (nonatomic, strong) UIView *ocjView_coupon;         ///<抵用券减免

@property (nonatomic, strong) UIView *ocjView_freight;        ///<运费
@property (nonatomic, strong) UILabel *ocjLab_freight;        ///<

@property (nonatomic, strong) UIView *ocjView_tips;           ///<查看提示

@end

@implementation OCJAccountTVCell

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
  [self ocj_addTotalPriceView];
  [self ocj_addReduceView];
  [self ocj_addCouponView];
  [self ocj_addFreightView];
  [self ocj_addTipsView];
}

/**
 商品总额
 */
- (void)ocj_addTotalPriceView {
  self.ocjView_totalPrice = [[UIView alloc] init];
  self.ocjView_totalPrice.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_totalPrice];
  [self.ocjView_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.mas_top).offset(15);
    make.height.mas_equalTo(@20);
  }];
  //商品总额
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"商品总额";
  ocjLab_title.font = [UIFont systemFontOfSize:13];
  ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_totalPrice addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_totalPrice.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_totalPrice);
  }];
  //金额
  self.ocjLab_totalPrice = [[UILabel alloc] init];
  self.ocjLab_totalPrice.text = @"￥200.0";
  self.ocjLab_totalPrice.font = [UIFont systemFontOfSize:13];
  self.ocjLab_totalPrice.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_totalPrice.textAlignment = NSTextAlignmentRight;
  [self.ocjView_totalPrice addSubview:self.ocjLab_totalPrice];
  [self.ocjLab_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_totalPrice.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_totalPrice);
    make.left.mas_equalTo(ocjLab_title);
  }];
}

/**
 优惠价格
 */
-(void)ocj_addReduceView {
  self.ocjView_reduce = [[UIView alloc] init];
  self.ocjView_reduce.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_reduce];
  [self.ocjView_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_totalPrice.mas_bottom).offset(5);
    make.height.mas_equalTo(@20);
  }];
  //优惠价格
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"优惠价格";
  ocjLab_title.font = [UIFont systemFontOfSize:13];
  ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_reduce addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_reduce.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_reduce);
  }];
  //金额
  self.ocjLab_reduce = [[UILabel alloc] init];
  self.ocjLab_reduce.text = @"-￥0.0";
  self.ocjLab_reduce.font = [UIFont systemFontOfSize:13];
  self.ocjLab_reduce.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_reduce.textAlignment = NSTextAlignmentRight;
  [self.ocjView_reduce addSubview:self.ocjLab_reduce];
  [self.ocjLab_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_reduce.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_reduce);
    make.left.mas_equalTo(ocjLab_title);
  }];
}

/**
 抵用券减免
 */
- (void)ocj_addCouponView {
  self.ocjView_coupon = [[UIView alloc] init];
  self.ocjView_coupon.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_coupon];
  [self.ocjView_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_reduce.mas_bottom).offset(5);
    make.height.mas_equalTo(@20);
  }];
  //抵用券价格
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"抵用券价格";
  ocjLab_title.font = [UIFont systemFontOfSize:13];
  ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_coupon addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_coupon.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_coupon);
  }];
  //金额
  self.ocjLab_coupon = [[UILabel alloc] init];
  self.ocjLab_coupon.text = @"-￥0.0";
  self.ocjLab_coupon.font = [UIFont systemFontOfSize:13];
  self.ocjLab_coupon.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_coupon.textAlignment = NSTextAlignmentRight;
  [self.ocjView_coupon addSubview:self.ocjLab_coupon];
  [self.ocjLab_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_coupon.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_coupon);
    make.left.mas_equalTo(ocjLab_title);
  }];
}

/**
 运费
 */
- (void)ocj_addFreightView {
  self.ocjView_freight = [[UIView alloc] init];
  self.ocjView_freight.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_freight];
  [self.ocjView_freight mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_coupon.mas_bottom).offset(5);
    make.height.mas_equalTo(@20);
  }];
  //运费
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"运费";
  ocjLab_title.font = [UIFont systemFontOfSize:13];
  ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_freight addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_freight.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_freight);
  }];
  //金额
  self.ocjLab_freight = [[UILabel alloc] init];
  self.ocjLab_freight.text = @"￥0.0";
  self.ocjLab_freight.font = [UIFont systemFontOfSize:13];
  self.ocjLab_freight.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_freight.textAlignment = NSTextAlignmentRight;
  [self.ocjView_freight addSubview:self.ocjLab_freight];
  [self.ocjLab_freight mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_freight.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjView_freight);
    make.left.mas_equalTo(ocjLab_title);
  }];
}

- (void)ocj_addTipsView {
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedTipsView)];
  
  self.ocjView_tips = [[UIView alloc] init];
  self.ocjView_tips.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_tips addGestureRecognizer:tap];
  [self addSubview:self.ocjView_tips];
  [self.ocjView_tips mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_freight.mas_bottom).offset(15);
    make.height.mas_equalTo(@15);
  }];
  //label
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = @"东方购物购买须知说明，点击了解退换货政策和积分优惠等更多内容";
  ocjLab_tip.font = [UIFont systemFontOfSize:10];
  ocjLab_tip.textColor = OCJ_COLOR_LIGHT_GRAY;
  ocjLab_tip.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_tips addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.centerX.mas_equalTo(self.ocjView_tips);
  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
  [self.ocjView_tips addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjLab_tip);
    make.right.mas_equalTo(ocjLab_tip);
    make.top.mas_equalTo(ocjLab_tip.mas_bottom).offset(0);
    make.height.mas_equalTo(@0.5);
  }];
}

- (void)ocj_tappedTipsView {
  if (self.ocjPurchaseNotesBlock) {
    self.ocjPurchaseNotesBlock();
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
