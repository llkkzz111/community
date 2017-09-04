//
//  OCJVerifyTitleTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJVerifyTitleTVCell.h"

@implementation OCJVerifyTitleTVCell

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
  self.ocjBtn_title = [[UIButton alloc] init];
  [self.ocjBtn_title setTitleColor:OCJ_COLOR_DARK forState:UIControlStateNormal];
  self.ocjBtn_title.titleLabel.font = [UIFont systemFontOfSize:15];
  self.ocjBtn_title.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjBtn_title addTarget:self action:@selector(ocj_clickedBtn) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.ocjBtn_title];
  [self.ocjBtn_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(@140);
    make.height.mas_equalTo(@40);
    make.centerX.centerY.mas_equalTo(self);
  }];
}

/**
 点击事件
 */
- (void)ocj_clickedBtn {
  if (self.ocjChangeVerifyBlock) {
    self.ocjChangeVerifyBlock();
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
