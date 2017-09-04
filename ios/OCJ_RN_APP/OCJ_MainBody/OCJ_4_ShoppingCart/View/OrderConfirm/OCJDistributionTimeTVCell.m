//
//  OCJDistributionTimeTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJDistributionTimeTVCell.h"

@interface OCJDistributionTimeTVCell ()

@end

@implementation OCJDistributionTimeTVCell

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
  ocjLab_time.text = @"配送时间";
  ocjLab_time.font = [UIFont systemFontOfSize:15];
  ocjLab_time.textColor = OCJ_COLOR_DARK;
  ocjLab_time.textAlignment = NSTextAlignmentLeft;
  [self addSubview:ocjLab_time];
  [ocjLab_time mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.centerY.mas_equalTo(self);
  }];
  //提示
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = @"任意日配送，订购完成后6日内送达";
  ocjLab_tip.font = [UIFont systemFontOfSize:12];
  ocjLab_tip.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_tip.textAlignment = NSTextAlignmentRight;
  [self addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.centerY.mas_equalTo(self);
    make.left.mas_equalTo(ocjLab_time.mas_right).offset(5);
  }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
