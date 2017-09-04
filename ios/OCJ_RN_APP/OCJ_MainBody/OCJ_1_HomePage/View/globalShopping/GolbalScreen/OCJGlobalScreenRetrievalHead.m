//
//  OCJGlobalScreenRetrievalHead.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenRetrievalHead.h"

@interface OCJGlobalScreenRetrievalHead()
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UILabel        *ocjLab_subTitle;
@property (nonatomic,strong) UIButton       *ocjBtn_AllChoose;
@property (nonatomic,strong) UIImageView     *ocjImageView_icon;

@end

@implementation OCJGlobalScreenRetrievalHead
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

#pragma mark - 私有方法区域
- (void)ocj_addViews
{
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(13);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-14);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 6));
    }];
    
    [self addSubview:self.ocjBtn_AllChoose];
    [self.ocjBtn_AllChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title.mas_right).offset(10);
        make.right.mas_equalTo(self.ocjImageView_icon.mas_left).offset(-5);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

- (void)ocj_setShowTitle:(NSString *)title SubTitle:(NSString *)subtitle
{
    [self.ocjLab_title setText:title];
    [self.ocjBtn_AllChoose setTitle:subtitle forState:UIControlStateNormal];
    if ([subtitle isEqualToString:@""]) {
        [self.ocjImageView_icon setHidden:YES];
    }
    else
    {
        [self.ocjImageView_icon setHidden:NO];
    }
    if ([subtitle isEqualToString:@"全部"]) {
        [_ocjBtn_AllChoose setTitleColor: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    }
    else
    {
        [_ocjBtn_AllChoose setTitleColor: [UIColor colorWithRed:237/255.0 green:28/255.0 blue:65/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    }
}

- (void)ocj_IsShowDetail:(BOOL)show
{
    if (show) {
        [self.ocjImageView_icon setImage:[UIImage imageNamed:@"class_up_arrow"]];
    }
    else
    {
        [self.ocjImageView_icon setImage:[UIImage imageNamed:@"icon_down"]];
    }
}

- (void)ocj_AllbuttonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_onScreenRetrievalHeadPressed:)]) {
        [self.delegate ocj_onScreenRetrievalHeadPressed:self.ocjInt_viewTag];
    }
}

#pragma mark - getter
- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc] init];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
//        _ocjLab_title.font = [UIFont systemFontOfSize:22];
        [_ocjLab_title setText:@"品牌"];
        _ocjLab_title.font = [UIFont systemFontOfSize:14];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjLab_title;
}

- (UIButton *)ocjBtn_AllChoose
{
    if (!_ocjBtn_AllChoose) {
        _ocjBtn_AllChoose = [[UIButton alloc] init];
        _ocjBtn_AllChoose.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_AllChoose setTitle:@"太平鸟" forState:UIControlStateNormal];
        [_ocjBtn_AllChoose setTitleColor: [UIColor colorWithRed:237/255.0 green:28/255.0 blue:65/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        _ocjBtn_AllChoose.backgroundColor = [UIColor clearColor];
        _ocjBtn_AllChoose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        _ocjBtn_AllChoose.tag = 2001;
        [_ocjBtn_AllChoose addTarget:self action:@selector(ocj_AllbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_AllChoose;
}

- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon = [[UIImageView alloc] init];
        [_ocjImageView_icon setBackgroundColor:[UIColor clearColor]];
        [_ocjImageView_icon setImage:[UIImage imageNamed:@"class_up_arrow"]];
    }
    return _ocjImageView_icon;
}

@end

