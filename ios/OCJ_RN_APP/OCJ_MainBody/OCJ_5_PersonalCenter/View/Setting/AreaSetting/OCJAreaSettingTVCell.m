//
//  OCJAreaSettingTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/5.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAreaSettingTVCell.h"

@implementation OCJAreaSettingTVCell

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
    self.ocjLab_title = [[OCJBaseLabel alloc] init];
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
