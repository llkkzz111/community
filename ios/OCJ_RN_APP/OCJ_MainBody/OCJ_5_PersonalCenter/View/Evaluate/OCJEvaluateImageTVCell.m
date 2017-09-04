//
//  OCJEvaluateImageTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEvaluateImageTVCell.h"

@implementation OCJEvaluateImageTVCell

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

- (void)ocj_addViews{
    self.ocjView_bottom = [[OCJUploadImageView alloc] init];
    [self addSubview:self.ocjView_bottom];
    [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
