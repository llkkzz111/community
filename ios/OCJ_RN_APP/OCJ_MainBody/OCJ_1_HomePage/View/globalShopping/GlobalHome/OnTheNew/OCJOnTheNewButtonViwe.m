//
//  OCJOnTheNewButtonViwe.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOnTheNewButtonViwe.h"

@interface OCJOnTheNewButtonViwe()
@property (nonatomic,strong) UIView         *ocjView_bg;
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UILabel        *ocjLab_SubTitle;
@property (nonatomic,strong) UIButton       *ocjBtn_Main;

@property (nonatomic,strong) UIImageView    *ocjImageView_status;//上新 促销 无


@end

@implementation OCJOnTheNewButtonViwe


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjView_bg];
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.ocjLab_title];
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.height.equalTo(@20);
    }];
    
    [self addSubview:self.ocjLab_SubTitle];
    self.ocjLab_SubTitle.textAlignment = NSTextAlignmentLeft;
    [self.ocjLab_SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(1);
        make.height.equalTo(@18);
    }];
    
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjLab_SubTitle.mas_bottom).offset(2);
        make.right.bottom.equalTo(self).offset(-8);
        make.left.offset(7);
    }];
  
    [self addSubview:self.ocjBtn_Main];
    [self.ocjBtn_Main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
  
    [self addSubview:self.ocjImageView_status];
    [self.ocjImageView_status mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self);
      make.right.offset(-5);
      make.width.equalTo(@(51*0.5));
      make.height.equalTo(@(56*0.5));
    }];
}

- (void)ocj_setViewDataWith:(OCJGSModel_Package14 *)model
{
    [self.ocjImageView_icon ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
  
    [self.ocjLab_title setText:model.ocjStr_title];
    [self.ocjLab_SubTitle setText:model.ocjStr_subTitle];
  
    if ([model.ocjStr_status isEqualToString:@"1"]){
        self.ocjImageView_status.hidden = NO;
        [self.ocjImageView_status setImage:[UIImage imageNamed:@"gs_new"]];
    }else if ([model.ocjStr_status isEqualToString:@"2"]){
        self.ocjImageView_status.hidden = NO;
      [self.ocjImageView_status setImage:[UIImage imageNamed:@"gs_cu"]];
    }else{
        self.ocjImageView_status.hidden = YES;
    }
}

-(void)ocj_mianButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_onTheNewButtonPressed:)]) {
        [self.delegate ocj_onTheNewButtonPressed:self.ocjInt_btnViewTag];
    }
}

#pragma mark - getter
- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon =[[UIImageView alloc] initWithFrame:CGRectZero];
        _ocjImageView_icon.contentMode = UIViewContentModeScaleAspectFit;
        _ocjImageView_icon.clipsToBounds = YES;
        [_ocjImageView_icon setBackgroundColor:[UIColor clearColor]];
    }
    return _ocjImageView_icon;
}

- (UIImageView *)ocjImageView_status
{
  if (!_ocjImageView_status) {
    _ocjImageView_status =[[UIImageView alloc] initWithFrame:CGRectZero];
    _ocjImageView_status.clipsToBounds = YES;
    _ocjImageView_status.contentMode = UIViewContentModeScaleAspectFit;
    [_ocjImageView_status setBackgroundColor:[UIColor clearColor]];
  }
  return _ocjImageView_status;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        _ocjLab_title.font = [UIFont systemFontOfSize:15];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjLab_title;
}

- (UILabel *)ocjLab_SubTitle
{
    if (!_ocjLab_SubTitle) {
        _ocjLab_SubTitle =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_SubTitle setBackgroundColor:[UIColor clearColor]];
        _ocjLab_SubTitle.font = [UIFont systemFontOfSize:13];
        _ocjLab_SubTitle.textColor = OCJ_COLOR_LIGHT_GRAY;
    }
    return _ocjLab_SubTitle;
}

- (UIButton *)ocjBtn_Main
{
    if (!_ocjBtn_Main) {
        _ocjBtn_Main = [[UIButton alloc] init];
        [_ocjBtn_Main setBackgroundColor:[UIColor clearColor]];
        [_ocjBtn_Main addTarget:self action:@selector(ocj_mianButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_Main;
}

- (UIView *)ocjView_bg
{
    if (!_ocjView_bg) {
        _ocjView_bg = [[UIView alloc] init];
        [_ocjView_bg setBackgroundColor:[UIColor clearColor]];
        [_ocjView_bg.layer setMasksToBounds:YES];
        [_ocjView_bg.layer setBorderWidth:0.5]; //边框宽度
        CGColorRef color = [UIColor colorWSHHFromHexString:@"DDDDDD"].CGColor;//CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
        [_ocjView_bg.layer setBorderColor:color];
        
    }
    return _ocjView_bg;
}


@end
