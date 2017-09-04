//
//  OCJAppointmentCouponTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJAppointmentCouponTVCell.h"

@interface OCJAppointmentCouponTVCell ()

@end

@implementation OCJAppointmentCouponTVCell

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
  UILabel *ocjLab_time = [[UILabel alloc] init];
  ocjLab_time.text = @"使用抵用券";
  ocjLab_time.font = [UIFont systemFontOfSize:15];
  ocjLab_time.textColor = OCJ_COLOR_DARK;
  ocjLab_time.textAlignment = NSTextAlignmentLeft;
  [self addSubview:ocjLab_time];
  [ocjLab_time mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.centerY.mas_equalTo(self);
  }];
  //
  UIImageView *ocjImgView_arrow = [[UIImageView alloc] init];
  [ocjImgView_arrow setImage:[UIImage imageNamed:@"arrow"]];
  [self addSubview:ocjImgView_arrow];
  [ocjImgView_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.centerY.mas_equalTo(self);
    make.width.mas_equalTo(@12);
    make.height.mas_equalTo(@13);
  }];
  //label
  self.ocjLab_coupon = [[UILabel alloc] init];
  self.ocjLab_coupon.text = @"不使用抵用券";
  self.ocjLab_coupon.font = [UIFont systemFontOfSize:12];
  self.ocjLab_coupon.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_coupon.textAlignment = NSTextAlignmentRight;
  [self addSubview:self.ocjLab_coupon];
  [self.ocjLab_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(ocjImgView_arrow.mas_left).offset(-10);
    make.centerY.mas_equalTo(self);
    make.left.mas_equalTo(ocjLab_time.mas_right).offset(10);
  }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
