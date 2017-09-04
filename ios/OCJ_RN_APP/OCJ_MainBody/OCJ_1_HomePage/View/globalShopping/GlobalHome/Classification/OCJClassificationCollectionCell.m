//
//  OCJClassificationCollectionCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJClassificationCollectionCell.h"

@interface OCJClassificationCollectionCell()
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UIImageView    *ocjImageView_corner;
@property (nonatomic,strong) UILabel        *ocjLab_corner;
@property (nonatomic,strong) UILabel        *ocjLab_title;

@end

@implementation OCJClassificationCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(49.5, 49.5));

    }];
    
    [self addSubview:self.ocjImageView_corner];
    [self.ocjImageView_corner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.ocjImageView_icon).offset(-10);
        make.size.mas_equalTo(CGSizeMake(17, 17.5));
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjImageView_icon.mas_bottom).offset(11);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)ocj_setViewDataWith:(OCJGSModel_Package4 *)model
{
  
      [self.ocjImageView_icon ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
      [self.ocjLab_title setText:model.ocjStr_title];
}

#pragma mark - getter
- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon =[[UIImageView alloc] initWithFrame:CGRectZero];
      _ocjImageView_icon.layer.cornerRadius = 25;
      _ocjImageView_icon.layer.masksToBounds = YES;
      
        [_ocjImageView_icon setBackgroundColor:[UIColor colorWSHHFromHexString:@"F1DDFF"]];//粉色
//      EFEFEF 米奇色
      
        [_ocjImageView_icon setBackgroundColor:[UIColor colorWSHHFromHexString:@"#FFE6FC"]];

    }
    return _ocjImageView_icon;
}

- (UIImageView *)ocjImageView_corner
{
    if (!_ocjImageView_corner) {
        _ocjImageView_corner =[[UIImageView alloc] init];
        [_ocjImageView_corner setBackgroundColor:[UIColor clearColor]];
    }
    return _ocjImageView_corner;
}

- (UILabel *)ocjLab_corner
{
    if (!_ocjLab_corner) {
        _ocjLab_corner =[[UILabel alloc] init];
        [_ocjLab_corner setBackgroundColor:[UIColor clearColor]];
        [_ocjLab_corner setTextColor:[UIColor whiteColor]];
    }
    return _ocjLab_corner;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title =[[UILabel alloc] init];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        [_ocjLab_title setTextColor: [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1/1.0]];
//        [_ocjLab_title setText:@"厨房用具"];
        _ocjLab_title.font = [UIFont systemFontOfSize:13];

    }
    return _ocjLab_title;
}

@end
