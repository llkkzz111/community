//
//  OCJWelfareCell.m
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJWelfareCell.h"

@implementation OCJWelfareCell

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
    self.ocjLabel_nameLabel = [self ocj_creatlabel:13];
    self.ocjLabel_nameLabel.text =@"第20170601期 双色球";
    [self.ocjLabel_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(14);
    }];
    
    self.ocjLabel_openAwardLabel = [self ocj_creatlabel:13];
    self.ocjLabel_openAwardLabel.text =@"等待开奖";
    [self.ocjLabel_openAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjLabel_nameLabel.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
    }];
    
    self.ocjLabel_oneNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_oneNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_oneNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_oneNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_oneNumberLabel.text =@"01";
  self.ocjLabel_oneNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_oneNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_oneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_nameLabel.mas_left);
        make.top.mas_equalTo(self.ocjLabel_nameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    self.ocjLabel_twoNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_twoNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_twoNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_twoNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_twoNumberLabel.text =@"01";
  self.ocjLabel_twoNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_twoNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_twoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
    }];
    
    self.ocjLabel_threeNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_threeNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_threeNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_threeNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_threeNumberLabel.text =@"01";
  self.ocjLabel_threeNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_threeNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_threeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_twoNumberLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
    }];
    
    self.ocjLabel_fourNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_fourNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_fourNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_fourNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_fourNumberLabel.text =@"01";
  self.ocjLabel_fourNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_fourNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_fourNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_threeNumberLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
    }];
    
    self.ocjLabel_fiveNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_fiveNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_fiveNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_fiveNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_fiveNumberLabel.text =@"01";
  self.ocjLabel_fiveNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_fiveNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_fiveNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_fourNumberLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
    }];
    
    self.ocjLabel_sixNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_sixNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_sixNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.ocjLabel_sixNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_sixNumberLabel.text =@"01";
  self.ocjLabel_sixNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLabel_sixNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_sixNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_fiveNumberLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
    }];
    
    self.ocjLabel_sevenNumberLabel = [self ocj_creatlabel:13];
    self.ocjLabel_sevenNumberLabel.layer.cornerRadius = 14;
    self.ocjLabel_sevenNumberLabel.layer.borderColor = [UIColor colorWSHHFromHexString:@"0792CC"].CGColor;
    self.ocjLabel_sevenNumberLabel.layer.borderWidth = 1;
    self.ocjLabel_sevenNumberLabel.text =@"01";
  self.ocjLabel_sevenNumberLabel.textColor = [UIColor colorWSHHFromHexString:@"0792CC"];
    self.ocjLabel_sevenNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.ocjLabel_sevenNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_sixNumberLabel.mas_right).offset(20);
        make.top.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_top);
        make.width.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_width);
        make.height.mas_equalTo(self.ocjLabel_oneNumberLabel.mas_height);
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

-(void)setOcjModel_dataModel:(OCJLotteryInfoModel *)ocjModel_dataModel
{
    _ocjModel_dataModel = ocjModel_dataModel;
    
    self.ocjLabel_nameLabel.text = [NSString stringWithFormat:@"第%@期 双色球",ocjModel_dataModel.ocjStr_drawNo];
    
    NSArray * ballArr = [ocjModel_dataModel.ocjStr_ball componentsSeparatedByString:@","];
    self.ocjLabel_oneNumberLabel.text =ballArr[0];
    self.ocjLabel_twoNumberLabel.text =ballArr[1];
    self.ocjLabel_threeNumberLabel.text =ballArr[2];
    self.ocjLabel_fourNumberLabel.text =ballArr[3];
    self.ocjLabel_fiveNumberLabel.text =ballArr[4];
    self.ocjLabel_sixNumberLabel.text =ballArr[5];
    self.ocjLabel_sevenNumberLabel.text =ballArr[6];
    
    
    if ([ocjModel_dataModel.ocjStr_drawYN isEqualToString:@"drawN"]) {
        self.ocjLabel_openAwardLabel.text = @"未中奖";
        self.ocjLabel_openAwardLabel.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
    }else if([ocjModel_dataModel.ocjStr_drawYN isEqualToString:@"drawY"]){
        self.ocjLabel_openAwardLabel.text = @"中奖";
        self.ocjLabel_openAwardLabel.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    }else if([ocjModel_dataModel.ocjStr_drawYN isEqualToString:@"drawW"]){
        self.ocjLabel_openAwardLabel.text = @"等待开奖";
        self.ocjLabel_openAwardLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    }else if([ocjModel_dataModel.ocjStr_drawYN isEqualToString:@"drawYN"]){
        self.ocjLabel_openAwardLabel.text = @"未开奖";
        self.ocjLabel_openAwardLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    }else if([ocjModel_dataModel.ocjStr_drawYN isEqualToString:@"drawF"]){
        self.ocjLabel_openAwardLabel.text = @"失败";
        self.ocjLabel_openAwardLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
