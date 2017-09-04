//
//  OCJScreeningTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScreeningTableViewCell.h"

@interface OCJScreeningTableViewCell()
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UIView         *ocjView_gap;
@end

@implementation OCJScreeningTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-18);
        make.size.mas_equalTo(CGSizeMake(13,10));
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.ocjImageView_icon.mas_left).offset(5);
    }];
    
    [self addSubview:self.ocjView_gap];
    [self.ocjView_gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(8);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
        
    }];
}

- (void)ocj_setShowtitle:(NSString *)title
{
    [self.ocjLab_title setText:title];
}

- (void)ocj_showIsCellSelected:(BOOL)selected
{
    if (selected) {
        [self.ocjLab_title setTextColor: [UIColor colorWithRed:229/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0]];
        [self.ocjImageView_icon setHidden:NO];
//      self.ocjView_gap.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    }
    else
    {
        [self.ocjLab_title setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0]];
        [self.ocjImageView_icon setHidden:YES];
      self.ocjView_gap.backgroundColor = [UIColor colorWSHHFromHexString:@"#E6E7EB"];
      
    }
}

#pragma mark - getter
- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon = [[UIImageView alloc] init];
        [_ocjImageView_icon setBackgroundColor:[UIColor clearColor]];
        [_ocjImageView_icon setImage:[UIImage imageNamed:@"icon_selected_red_"]];
    }
    return _ocjImageView_icon;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc] init];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        _ocjLab_title.font = [UIFont systemFontOfSize:14];
        _ocjLab_title.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];

    }
    return _ocjLab_title;
}

- (UIView *)ocjView_gap
{
    if (!_ocjView_gap) {
        _ocjView_gap = [[UIView alloc] init];
        [_ocjView_gap setBackgroundColor:[UIColor colorWithRed:230/255.0 green:231/255.0 blue:235/255.0 alpha:1/1.0]];
    }
    return _ocjView_gap;
}

@end
