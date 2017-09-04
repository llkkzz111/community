//
//  OCJPersonalInfoCell.m
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPersonalInfoCell.h"

@interface OCJPersonalInfoCell ()

@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;///<title

@end

@implementation OCJPersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    
    //line
    self.ocjView_line = [[UIView alloc] init];
    self.ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:self.ocjView_line];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    
    //信息
    self.ocjLab_info = [[OCJBaseLabel alloc] init];
    self.ocjLab_info.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_info.font = [UIFont systemFontOfSize:14];
    self.ocjLab_info.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ocjLab_info];
    [self.ocjLab_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-38);
        make.height.mas_equalTo(@20);
    }];
    
    //title
    self.ocjLab_title = [[OCJBaseLabel alloc] init];
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.ocjLab_info.mas_left).offset(-10);
        make.height.mas_equalTo(@22);
    }];
}

- (void)ocj_setInformationWithTitle:(NSString *)title {
    self.ocjLab_title.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
