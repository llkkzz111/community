//
//  OCJContactMeTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJContactMeTVCell.h"

@interface OCJContactMeTVCell ()

@property (nonatomic, strong) UISwitch *ocjSwitch_contact;    ///<联系我按钮

@end

@implementation OCJContactMeTVCell

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
  self.ocjSwitch_contact = [[UISwitch alloc] init];
  [self.ocjSwitch_contact addTarget:self action:@selector(ocj_clickedContactBtn:) forControlEvents:UIControlEventValueChanged];
  [self addSubview:self.ocjSwitch_contact];
  [self.ocjSwitch_contact mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self);
    make.right.mas_equalTo(self.mas_right).offset(-10);
  }];
  
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = @"货到后直接为我安排发货，发货前电话联系";
  ocjLab_tip.font = [UIFont systemFontOfSize:15];
  ocjLab_tip.textColor = OCJ_COLOR_DARK;
  ocjLab_tip.textAlignment = NSTextAlignmentLeft;
  ocjLab_tip.numberOfLines = 2;
  [self addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.right.mas_equalTo(self.ocjSwitch_contact.mas_left).offset(-24);
    make.centerY.mas_equalTo(self);
  }];
}

/**
 点击联系我按钮
 */
- (void)ocj_clickedContactBtn:(UISwitch *)switchBtn {
  if (self.ocjContactMeBlock) {
    self.ocjContactMeBlock(self.ocjSwitch_contact.on ? @"1" : @"0");//0:联系 1:不联系
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
