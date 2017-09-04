//
//  OCJRewardTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRewardTVCell.h"

@interface OCJRewardTVCell()
@property (nonatomic,copy) UIView  * ocjView_line;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_tip;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_score;
@property (nonatomic,copy) OCJBaseLabel * ocjLab_time;

@end

@implementation OCJRewardTVCell
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
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(100);
    }];
    
    [self.ocjLab_tip  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_score.mas_left).offset(-20);
        make.top.mas_equalTo(self.ocjLab_score);
        make.bottom.mas_equalTo(self.ocjLab_score);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.ocjLab_time  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16.5);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(5);
        make.left.mas_equalTo(self.ocjLab_tip);
    }];
    
    [self.ocjView_line  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
}
- (void)setOcjModel_score:(OCJRewardModel *)ocjModel_score{
    self.ocjLab_score.text = ocjModel_score.ocjStr_USE_AMT_APP;
    self.ocjLab_tip.text   = ocjModel_score.ocjStr_DEPOSIT_NOTE_APP;
    self.ocjLab_time.text  = ocjModel_score.ocjStr_PROC_DATE;
    
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
        _ocjLab_tip           = [[OCJBaseLabel alloc]init];
        _ocjLab_tip.font      = [UIFont systemFontOfSize:14];
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
        _ocjLab_time.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_time;
}



@end
