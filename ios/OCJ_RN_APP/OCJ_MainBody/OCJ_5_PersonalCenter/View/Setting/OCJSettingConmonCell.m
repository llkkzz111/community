//
//  OCJSettingConmonCell.m
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSettingConmonCell.h"

@interface OCJSettingConmonCell ()

@end

@implementation OCJSettingConmonCell

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
    
    self.ocjView_line = [[UIView alloc] init];
    self.ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:self.ocjView_line];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.ocjLab_title = [[OCJBaseLabel alloc] init];
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-38);
        make.height.mas_equalTo(@22);
    }];
}

- (void)ocj_setTitle:(NSString *)ocjStr_title {
    self.ocjLab_title.text = ocjStr_title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
