//
//  OCJScoreDetailTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScoreDetailTVCell.h"

@interface OCJScoreDetailTVCell()
@property (nonatomic,copy) UIView  * ocjView_line;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_tip;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_score;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_time;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_endTime;

@end

@implementation OCJScoreDetailTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_score];
        [self.contentView addSubview:self.ocjLab_time];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_score  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(60);
    }];
    
    [self.ocjLab_tip  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_score.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.ocjLab_score);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.ocjLab_time  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16.5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
        make.left.mas_equalTo(self.ocjLab_tip);
    }];
    
    [self.ocjView_line  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
}
- (void)setOcjModel_score:(OCJScoreDetaiModel *)ocjModel_score{
    self.ocjLab_score.text = ocjModel_score.ocjStr_saveAmt;
  NSString *ocjStr_labName;
  if ([ocjModel_score.ocjStr_saveAmtExpireDate length] > 0) {
    ocjStr_labName = [NSString stringWithFormat:@"%@ 有效期至%@", ocjModel_score.ocjStr_saveAmtName, ocjModel_score.ocjStr_saveAmtExpireDate];
  }else {
    ocjStr_labName = [NSString stringWithFormat:@"%@", ocjModel_score.ocjStr_saveAmtName];
  }
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:ocjStr_labName];
  //修改label的行间距
  NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paraphStyle setLineSpacing:5];
  [str addAttribute:NSParagraphStyleAttributeName value:paraphStyle range:NSMakeRange(0, str.length)];
  self.ocjLab_tip.attributedText = str;
  [self.ocjLab_tip sizeToFit];
  
    self.ocjLab_time.text = ocjModel_score.ocjStr_saveAmtGetDate;
    if ([ocjModel_score.ocjStr_sub boolValue]) {
        self.ocjLab_score.textColor = [UIColor colorWSHHFromHexString:@"FFC033 "];
    }else{
        self.ocjLab_score.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
}

- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    }
    return _ocjView_line;
}
- (OCJBaseLabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[OCJBaseLabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
      _ocjLab_tip.numberOfLines = 3;
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_tip;
}

- (OCJBaseLabel *)ocjLab_score{
    if (!_ocjLab_score) {
        _ocjLab_score = [[OCJBaseLabel alloc]init];
        _ocjLab_score.textAlignment = NSTextAlignmentRight;
        _ocjLab_score.font = [UIFont systemFontOfSize:14];
        _ocjLab_score.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjLab_score;
}

- (OCJBaseLabel *)ocjLab_time{
    if (!_ocjLab_time) {
        _ocjLab_time = [[OCJBaseLabel alloc]init];
        _ocjLab_time.font = [UIFont systemFontOfSize:12];
        _ocjLab_time.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjLab_time;
}

@end
