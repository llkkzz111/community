//
//  OCJShoppingPOPViewCell.m
//  OCJ
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShoppingPOPViewCell.h"

@implementation OCJShoppingPOPViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self ocj_addLabel];
    }
    return self;
}

- (void)ocj_addLabel {
    self.ocjLab_description = [[OCJBaseLabel alloc] init];
    self.ocjLab_description.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_description.font = [UIFont systemFontOfSize:13];
    self.ocjLab_description.numberOfLines = 0;
    [self addSubview:self.ocjLab_description];
    [self.ocjLab_description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
