//
//  OCJRegisterCellTableViewCell.m
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterCellTableViewCell.h"

@implementation OCJRegisterCellTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self ocj_creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)ocj_creatUI
{
  
  self.ocjLabel_isUserLabel = [self ocj_creatlabel:15];
  //    self.ocjLabel_isUserLabel.text =@"未使用";
  [self.ocjLabel_isUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.top.mas_equalTo(self.mas_top).offset(20);
    make.width.mas_equalTo(50);
    make.height.mas_equalTo(20);
  }];
  
    self.ocjLabel_nameLabel = [self ocj_creatlabel:14];
  self.ocjLabel_nameLabel.numberOfLines = 2;
//    self.ocjLabel_nameLabel.text =@"抵用券10元";
    [self.ocjLabel_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.ocjLabel_isUserLabel.mas_top);
        make.right.mas_equalTo(self.ocjLabel_isUserLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    self.ocjLabel_dateLabel = [self ocj_creatlabel:12];
//    self.ocjLabel_dateLabel.text =@"2017.4.29";
    [self.ocjLabel_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_nameLabel.mas_left);
        make.top.mas_equalTo(self.ocjLabel_nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(self.ocjLabel_nameLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_nameLabel.mas_height);
    }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.right.mas_equalTo(self);
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.height.mas_equalTo(@0.5);
  }];
}

-(UILabel *)ocj_creatlabel:(NSInteger)font;
{
    UILabel * ocj_label = [[UILabel alloc] init];
    ocj_label.font = [UIFont systemFontOfSize:font];
    ocj_label.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    [self addSubview:ocj_label];
    return ocj_label;
}

-(void)setOcjModel_dataModel:(OCJGiftInfoModel *)ocjModel_dataModel
{
  _ocjModel_dataModel = ocjModel_dataModel;
  
  NSDateFormatter * formater = [[NSDateFormatter alloc] init];
  formater.timeZone = [NSTimeZone timeZoneWithName:@"Shanghai"];
  [formater setDateStyle:NSDateFormatterMediumStyle];
  [formater setTimeStyle:NSDateFormatterShortStyle];
  [formater setDateFormat:@"yyyy.MM.dd"];
  NSDate * date = [NSDate dateWithTimeIntervalSince1970:[ocjModel_dataModel.ocjStr_insert_date doubleValue]/ 1000.0];
  
  self.ocjLabel_nameLabel.text = ocjModel_dataModel.ocjStr_coupon_note;
  self.ocjLabel_dateLabel.text = [formater stringFromDate:date];
  if ([ocjModel_dataModel.ocjStr_user_YN intValue] == 0) {
    self.ocjLabel_isUserLabel.text = @"未使用";
    self.ocjLabel_isUserLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  }else{
    self.ocjLabel_isUserLabel.text = @"已使用";
    self.ocjLabel_isUserLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
  }

}
@end
