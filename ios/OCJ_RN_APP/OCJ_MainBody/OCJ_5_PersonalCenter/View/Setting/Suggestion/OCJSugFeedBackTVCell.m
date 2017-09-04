//
//  OCJSugFeedBackTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSugFeedBackTVCell.h"

@interface OCJSugFeedBackTVCell ()

@property (nonatomic,strong) OCJBaseLabel * ocjLab_bottom;
@end

@implementation OCJSugFeedBackTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.ocjLab_title];
        [self.contentView addSubview:self.ocjLab_bottom];
        [self.contentView setNeedsUpdateConstraints];

    }
    return self;
}
- (void)setOcjBool_showLine:(BOOL)ocjBool_showLine{
    if (ocjBool_showLine) {
        self.ocjLab_bottom.hidden = NO;
    }else{
        self.ocjLab_bottom.hidden = YES;
    }
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.ocjLab_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}
- (OCJBaseLabel *)ocjLab_title{
    if (!_ocjLab_title) {
        _ocjLab_title = [[OCJBaseLabel alloc]init];
        _ocjLab_title.font = [UIFont systemFontOfSize:14];
        _ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_title;
}
- (OCJBaseLabel *)ocjLab_bottom{
    if (!_ocjLab_bottom) {
        _ocjLab_bottom = [[OCJBaseLabel alloc]init];
        _ocjLab_bottom.backgroundColor = [UIColor colorWSHHFromHexString:@"dddddd"];
    }
    return _ocjLab_bottom;
}

@end
